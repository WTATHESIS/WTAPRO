function [decout,staout,fitout,fitrec,tarsurproout,asssurproout] = weapon_target_asset_assign(weanum,tarnum,assnum,weasta,tarsta,asssta,weakillpro,tarkillpro,assval,weatarsta,tardec,popsize,sollen,effthr,curwei)

fitrec = [];
decrec = [];
starec = [];
tarsurprorec = [];
asssurprorec = [];
% fit = [];
% map = [];

predec = zeros(weanum,tarnum,1);
% prefit = 0;
preava = weatarsta;
presta = weasta;

for solite = 1 : weanum % 武器使用数量
    
%     disp(solite);
    
    presolnum = size(predec,3);  % 前一阶段分化数量
    
    solnum = sollen*presolnum;
    dec = zeros(weanum,tarnum,solnum);
    %     sta = repmat(presta,solnum,1);
    sta = zeros(solnum,weanum);
    %     ava = repmat(weatarsta,1,1,solnum);
    ava = zeros(weanum,tarnum,solnum);
    fit = zeros(solnum,3);
    tarsurpro = zeros(solnum,tarnum);
    asssurpro = zeros(solnum,assnum);
    
    for presolind =  presolnum : -1 : 1
        
        %if solite == 1 || any(any(predecmat(:,:,presolind))) ~= 0
        
        [tareffkillpro,~] = tareffkillpro_compute(tarsta,weakillpro,tarkillpro,predec(:,:,presolind));
        tarasseff = assval .* tareffkillpro .* tardec;
        [pritar,~] = find(tarasseff==max(tarasseff,[],'all'));    % 确定优先攻击目标
        %         [pritar,~] = target_attacked_define(tarnum,preava(:,:,presolind),tarasseff);
        
        %% 当前资源生存价值期望
        [~,sinassfit] = target_asset_fitness(assval,asssta,tareffkillpro,tardec);
        %             fit = cat(2,fit,gfit/sum(assval));
        %% 映射收益
        [weatarmap,preava(:,:,presolind)] = weatarmap_generate(weanum,tarnum,weakillpro,tareffkillpro,assval,preava(:,:,presolind),tardec,sinassfit,effthr);
        
        if all(all(preava(:,:,presolind)==0))
            for n = sollen : -1 : 1
                solind = (presolind - 1) * sollen + n;
                dec(:,:,solind) = [];
                sta(solind,:) = [];
                ava(:,:,solind) = [];
                fit(solind,:) = [];
                tarsurpro(solind,:) = [];
                asssurpro(solind,:) = [];
                if isempty(dec)
                    if solite == 1
 						decout = zeros(weanum,tarnum);
						fitrec = zeros(1,3);
                		[fitrec(1,1),fitrec(1,2),fitrec(1,3),tarsurproout,asssurproout] = fitness_compute(weasta,tarsta,asssta,weakillpro,tarkillpro,assval,decout,tardec,curwei);
						fitout = fitrec;
						staout = weasta;
						return;
                    else
                        [~,recind] = sort(fitrec(:,1),'descend');
                        indout = recind(1);
                        decout = decrec(:,:,indout);
                        staout = starec(indout,:);
                        fitout = fitrec(indout,:);
                        tarsurproout = tarsurprorec(indout,:);
                        asssurproout = asssurprorec(indout,:);
                        return;
                    end
                end
            end
            continue;
        end
        
        %% 启发式信息选择武器
        [weaeff,weaeffstd] = weapon_select_information(weanum,pritar,weatarmap);
        [nondomind] = nondominated_index(weanum,weaeff,weaeffstd,sollen);
        %                 disp([num2str(nondomind(1)),'-',num2str(pritar),'-',num2str(priass),'-',num2str(weatarmap(nondomind(1),pritar))]);
        nondomsize = length(nondomind);
        for n = sollen : -1 :1
            solind = (presolind - 1) * sollen + n;
            if n <= nondomsize
                dec(:,:,solind) = predec(:,:,presolind);
                sta(solind,:) = presta(presolind,:);
                ava(:,:,solind) = preava(:,:,presolind);
                weaind = nondomind(n,1);
                dec(weaind,pritar,solind) = 1;
                sta(solind,weaind) = 0;
                ava(weaind,:,solind) = 0;
                [fit(solind,1),fit(solind,2),fit(solind,3),tarsurpro(solind,:),asssurpro(solind,:)] = fitness_compute(sta(solind,:),tarsta,asssta,weakillpro,tarkillpro,assval,dec(:,:,solind),tardec,curwei);
                %                 1
            else
                dec(:,:,solind) = [];
                sta(solind,:) = [];
                ava(:,:,solind) = [];
                fit(solind,:) = [];
                tarsurpro(solind,:) = [];
                asssurpro(solind,:) = [];
            end
        end
        
    end
    
    [~,desind] = sort(fit(:,1),'descend');
    if size(fit,1) > popsize
        desind = desind(1:popsize,1);
    end
    
    predec = dec(:,:,desind);
    presta = sta(desind,:);
    preava = ava(:,:,desind);
    
    fitrec = cat(1,fitrec,fit(1,:));
    decrec = cat(3,decrec,dec(:,:,1));
    starec = cat(1,starec,sta(1,:));
    tarsurprorec = cat(1,tarsurprorec,tarsurpro(1,:));
    asssurprorec = cat(1,asssurprorec,asssurpro(1,:));
    
end

[~,recind] = sort(fitrec(:,1),'descend');
indout = recind(1);
decout = decrec(:,:,indout);
staout = starec(indout,:);
fitout = fitrec(indout,:);
tarsurproout = tarsurprorec(indout,:);
asssurproout = asssurprorec(indout,:);
return;

end
