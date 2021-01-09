
poplist = [10:10:100];
diffnumlist = [1:1:10];

weanum = 70;
tarnum = 50;
assnum = 50;

assval = rand(1,assnum);
weakillpro = rand(weanum,tarnum);
tarkillpro = rand(tarnum,assnum);

save assval.mat assval
save weakillpro.mat weakillpro
save tarkillpro.mat tarkillpro

for popind = 1 : 10
    
    for diffind = 1 : 10
        
        disp([num2str(popind*10),'_',num2str(diffind)]);
        
        load assval.mat
        load tarkillpro.mat
        load weakillpro.mat
        
        avahig = 0.9;
        avalow = 0.1;
        maxtim = 10;
        
        diffnum = diffnumlist(diffind);
        effthr = 0.9;
        popsize = poplist(popind);
        curwei = 0.8;
        
        victory = NaN(1,1);
        stage = NaN(1,1);
        time = NaN(1,1);
        nav = 1;
        fit = [];
        
        weasta = ones(1,weanum);
        tarsta = ones(1,tarnum);
        asssta = ones(1,assnum);
        tarassava = ones(tarnum,assnum);
        
        weares = weanum;
        tarres = tarnum;
        assres = assnum;
        
        weadec = zeros(weanum,tarnum);
        tardec = zeros(tarnum,assnum);
        statim = 1;
        
        a = tic;
        while(1)
            
            %% 识别目标-资产攻击矩阵
            [tardec] = target_asset_assign(tarnum,assnum,tarkillpro,assval,tarassava,0);
            
            %% 判断武器-目标可行性矩阵
            weatarsta = weapon_target_state_update(weanum,tarnum,weasta,tarsta,avahig,avalow,statim,maxtim);
            
            %% 选择待攻击目标，生成武器-目标决策矩阵
            [decout,staout,fitout,fitrec,tarsurproout,asssurproout] = weapon_target_asset_assign(weanum,tarnum,assnum,weasta,tarsta,asssta,weakillpro,tarkillpro,assval,weatarsta,tardec,popsize,diffnum,effthr,curwei);
            
            %% 更新武、目标、资产状态
            weasta = staout;
            tarsta = rand(1,tarnum)<tarsurproout;
            asssta = rand(1,assnum)<asssurproout;
            
            nav = sum(asssta.*assval,2)/sum(assval,2);
            
            if all(asssta == 0)
                time(1,1) = toc(a);
                victory(1,1) = 0;
                stage(1,1) = statim;
                nav = cat(1,nav,0);
                fit = cat(1,fit,fitout);
                weacon = sum(weasta,2);
                weares = cat(2,weares,weacon);
                tarcon = sum(tarsta);
                tarres = cat(2,tarres,tarcon);
                break;
            elseif all(tarsta == 0)
                time(1,1) = toc(a);
                victory(1,1) = 1;
                stage(1,1) = statim;
                nav = cat(1,nav,sum(asssta.*assval,2)/sum(assval,2));
                fit = cat(1,fit,fitout);
                weacon = sum(weasta,2);
                weares = cat(2,weares,weacon);
                tarcon = sum(tarsta);
                tarres = cat(2,tarres,tarcon);
                asscon = sum(asssta);
                assres = cat(2,assres,asscon);
                break;
            elseif all(weasta == 0)
                time(1,1) = toc(a);
                victory(1,1) = -1;
                stage(1,1) = statim;
                nav = cat(1,nav,0);
                fit = cat(1,fit,fitout);
                weacon = sum(weasta,2);
                weares = cat(2,weares,weacon);
                tarcon = sum(tarsta);
                tarres = cat(2,tarres,tarcon);
                break;
            end
            
            nav = cat(1,nav,sum(asssta.*assval,2)/sum(assval,2));
            fit = cat(1,fit,fitout);
            weacon = sum(weasta,2);
            weares = cat(2,weares,weacon);
            tarcon = sum(tarsta);
            tarres = cat(2,tarres,tarcon);
            
            tarassava = tarsta' .* asssta;
            
            statim = statim + 1;
            
        end
        
        filename = ['victory',int2str(popind*10),'_',int2str(diffind),'.mat'];
        valuename = ['victory'];
        save(filename,valuename);
        
        filename = ['stage',int2str(popind*10),'_',int2str(diffind),'.mat'];
        valuename = ['stage'];
        save(filename,valuename);
        
        filename = ['nav',int2str(popind*10),'_',int2str(diffind),'.mat'];
        valuename = ['nav'];
        save(filename,valuename);
        
        filename = ['time',int2str(popind*10),'_',int2str(diffind),'.mat'];
        valuename = ['time'];
        save(filename,valuename);
        
        filename = ['fit',int2str(popind*10),'_',int2str(diffind),'.mat'];
        valuename = ['fit'];
        save(filename,valuename);
        
        filename = ['weares',int2str(popind*10),'_',int2str(diffind),'.mat'];
        valuename = ['weares'];
        save(filename,valuename);
        
        filename = ['tarres',int2str(popind*10),'_',int2str(diffind),'.mat'];
        valuename = ['tarres'];
        save(filename,valuename);
        
        nmvmean = mean(nav,1);
        nmvstd = std(nav,0,1);
        timemean = mean(time,1);
        timestd = std(time,0,1);
        
        filename = ['nmvmean',int2str(popind*10),'_',int2str(diffind),'.mat'];
        valuename = ['nmvmean'];
        save(filename,valuename);
        
        filename = ['nmvstd',int2str(popind*10),'_',int2str(diffind),'.mat'];
        valuename = ['nmvstd'];
        save(filename,valuename);
        
        filename = ['timemean',int2str(popind*10),'_',int2str(diffind),'.mat'];
        valuename = ['timemean'];
        save(filename,valuename);
        
        filename = ['timestd',int2str(popind*10),'_',int2str(diffind),'.mat'];
        valuename = ['timestd'];
        save(filename,valuename);
        
    end
    
end
