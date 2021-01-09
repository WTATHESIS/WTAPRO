function [decout,staout,fitout,fitrec,tarsurproout,asssurproout] = weapon_target_asset_assign(weanum,tarnum,assnum,weasta,tarsta,asssta,weakillpro,tarkillpro,assval,weatarsta,tardec,popsize,diffnum,effthr,curwei)

fitrec = [];
decrec = [];
starec = [];
tarsurprorec = [];
asssurprorec = [];

predec = zeros(weanum,tarnum,1);
preava = weatarsta;
presta = weasta;

for solite = 1 : weanum % ����ʹ������
    
    presolnum = size(predec,3);  % ǰһ�׶ηֻ�����
    
    solnum = diffnum*presolnum;
    dec = zeros(weanum,tarnum,solnum);
    sta = zeros(solnum,weanum);
    ava = zeros(weanum,tarnum,solnum);
    fit = zeros(solnum,3);
    tarsurpro = zeros(solnum,tarnum);
    asssurpro = zeros(solnum,assnum);
    
    for presolind =  presolnum : -1 : 1
          
        [tareffkillpro,~] = tareffkillpro_compute(tarsta,weakillpro,tarkillpro,predec(:,:,presolind));
        tarasseff = assval .* tareffkillpro .* tardec;
        [pritar,~] = find(tarasseff==max(tarasseff,[],'all'));    % ȷ�����ȹ���Ŀ��
        
        %% ��ǰ��Դ�����ֵ����
        [~,sinassfit] = target_asset_fitness(assval,asssta,tareffkillpro,tardec);
        
        %% ӳ������
        [weatarmap,preava(:,:,presolind)] = weatarmap_generate(weanum,tarnum,weakillpro,tareffkillpro,assval,preava(:,:,presolind),tardec,sinassfit,effthr);
        
        if all(all(preava(:,:,presolind)==0))
           
            for n = diffnum : -1 : 1
                solind = (presolind - 1) * diffnum + n;
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
        
        %% ����ʽ��Ϣѡ������
        [weaeff,weaeffstd] = weapon_select_information(weanum,pritar,weatarmap);
        [nondomind] = nondominated_index(weanum,weaeff,weaeffstd,diffnum);
        
        nondomsize = length(nondomind);
        for n = diffnum : -1 :1
            solind = (presolind - 1) * diffnum + n;
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
