
weanumlist = [55:5:100];
tarnum = 50;
assnumlist = [5:5:100];

weakilllow = 0.3;
weakillhigh = 0.8;

tarkilllow = 0.3;
tarkillhigh = 0.8;

avahig = 0.9;
avalow = 0.1;
maxtim = 10;

effthr = 0.9;
curwei = 0.8;

sollen = 4;
popsize = 40;

for i = 1 : length(weanumlist)
    for j = 1 : length(assnumlist)
        
        weanum = weanumlist(i);
        assnum = assnumlist(j);
        
        assval = rand(1,assnum);
        weakillpro = weakilllow + (weakillhigh-weakilllow) .* rand(weanum,tarnum);
        tarkillpro = tarkilllow + (tarkillhigh-tarkilllow) .* rand(tarnum,assnum);
        
        victory = NaN(1,1);
        stage = NaN(1,1);
        nmvsa = 1;
        weares = weanum;
        tarres = tarnum;
        assres = assnum;
        time = NaN(1,1);
        fit = [];
        
        weasta = ones(1,weanum);
        tarsta = ones(1,tarnum);
        asssta = ones(1,assnum);
        
        tarassava = ones(tarnum,assnum);
        weadec = zeros(weanum,tarnum);
        tardec = zeros(tarnum,assnum);
        
        statim = 1;
        
        tic;
        while(1)
            
            %% 识别目标-资产攻击矩阵
            [tardec] = target_asset_assign(tarnum,assnum,tarkillpro,assval,tarassava,0);
            
            %% 判断武器-目标可行性矩阵
            weatarsta = weapon_target_state_update(weanum,tarnum,weasta,tarsta,avahig,avalow,statim,maxtim);
            
            %% 选择待攻击目标，生成武器-目标决策矩阵
            [decout,staout,fitout,fitrec,tarsurproout,asssurproout] = weapon_target_asset_assign(weanum,tarnum,assnum,weasta,tarsta,asssta,weakillpro,tarkillpro,assval,weatarsta,tardec,popsize,sollen,effthr,curwei);
            
            %% 更新武、目标、资产状态
            weasta = staout;
            tarsta = rand(1,tarnum)<tarsurproout;
            acttardec = tardec .* tarsta' .* asssta;
            acttarkillpro = tarkillpro .* tardec .* tarsta';
            [totexcassval,sinexcassval,actasssurpro] = target_asset_fitness(assval,asssta,tarkillpro,acttardec);
            asssta = rand(1,assnum) < actasssurpro;
            
            if all(asssta == 0)
                toc;
                time(1,1) = toc;
                victory(1,1) = 0;
                stage(1,1) = statim;
                curnmvsa = 0;
                nmvsa = cat(2,nmvsa,curnmvsa);
                weacon = sum(weasta,2);
                weares = cat(2,weares,weacon);
                tarcon = sum(tarsta);
                tarres = cat(2,tarres,tarcon);
                asscon = sum(asssta,2);
                assres = cat(2,assres,asscon);
                fit = cat(1,fit,fitout);
                break;
            elseif all(tarsta == 0)
                toc;
                time(1,1) = toc;
                victory(1,1) = 1;
                stage(1,1) = statim;
                curnmvsa = sum(asssta.*assval,2)/sum(assval,2);
                nmvsa = cat(2,nmvsa,curnmvsa);
                weacon = sum(weasta,2);
                weares = cat(2,weares,weacon);
                tarcon = sum(tarsta);
                tarres = cat(2,tarres,tarcon);
                asscon = sum(asssta,2);
                assres = cat(2,assres,asscon);
                fit = cat(1,fit,fitout);
                break;
            elseif all(weasta == 0)
                toc;
                time(1,1) = toc;
                victory(1,1) = -1;
                stage(1,1) = statim;
                curnmvsa = 0;
                nmvsa = cat(2,nmvsa,curnmvsa);
                weacon = sum(weasta,2);
                weares = cat(2,weares,weacon);
                tarcon = sum(tarsta);
                tarres = cat(2,tarres,tarcon);
                asscon = sum(asssta,2);
                assres = cat(2,assres,asscon);
                fit = cat(1,fit,fitout);
                break;
            end
            
            curnmvsa = sum(asssta.*assval,2)/sum(assval,2);
            nmvsa = cat(2,nmvsa,curnmvsa);
            weacon = sum(weasta,2);
            weares = cat(2,weares,weacon);
            tarcon = sum(tarsta);
            tarres = cat(2,tarres,tarcon);
            asscon = sum(asssta,2);
            assres = cat(2,assres,asscon);
            fit = cat(1,fit,fitout);
            
            tarassava = tarsta' .* asssta;
            
            statim = statim + 1;
            
        end
        
        filename = ['victory_',int2str(weanumlist(i)),'_',int2str(assnumlist(j)),'.mat'];
        valuename = ['victory'];
        save(filename,valuename);
        
        filename = ['stage_',int2str(weanumlist(i)),'_',int2str(assnumlist(j)),'.mat'];
        valuename = ['stage'];
        save(filename,valuename);
        
        filename = ['nmvsa_',int2str(weanumlist(i)),'_',int2str(assnumlist(j)),'.mat'];
        valuename = ['nmvsa'];
        save(filename,valuename);
        
        filename = ['weares_',int2str(weanumlist(i)),'_',int2str(assnumlist(j)),'.mat'];
        valuename = ['weares'];
        save(filename,valuename);
        
        filename = ['tarres_',int2str(weanumlist(i)),'_',int2str(assnumlist(j)),'.mat'];
        valuename = ['tarres'];
        save(filename,valuename);
        
        filename = ['assres_',int2str(weanumlist(i)),'_',int2str(assnumlist(j)),'.mat'];
        valuename = ['assres'];
        save(filename,valuename);
        
        filename = ['time_',int2str(weanumlist(i)),'_',int2str(assnumlist(j)),'.mat'];
        valuename = ['time'];
        save(filename,valuename);
        
        filename = ['fit_',int2str(weanumlist(i)),'_',int2str(assnumlist(j)),'.mat'];
        valuename = ['fit'];
        save(filename,valuename);
        
    end
end
