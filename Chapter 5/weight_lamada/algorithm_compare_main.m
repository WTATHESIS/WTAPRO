
curweilist = [0.1:0.1:0.9];

weanum = 100;
tarnum = 50;
assnum = 50;

assval = rand(1,assnum);
weakilllow = 0.3;
weakillhigh = 0.8;
weakillpro = weakilllow + (weakillhigh-weakilllow) .* rand(weanum,tarnum);
tarkilllow = 0.3;
tarkillhigh = 0.8;
tarkillpro = tarkilllow + (tarkillhigh-tarkilllow) .* rand(tarnum,assnum);

avahig = 0.9;
avalow = 0.1;
maxtim = 10;

for i = 1 : 9
    
    effthr = 0.9;
    curwei = curweilist(i);
    
    sollen = 4;
    popsize = 40;
    
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
    
    filename = ['victory',int2str(i),'.mat'];
    valuename = ['victory'];
    save(filename,valuename);
    
    filename = ['stage',int2str(i),'.mat'];
    valuename = ['stage'];
    save(filename,valuename);
    
    filename = ['nmvsa',int2str(i),'.mat'];
    valuename = ['nmvsa'];
    save(filename,valuename);
    
    filename = ['weares',int2str(i),'.mat'];
    valuename = ['weares'];
    save(filename,valuename);
    
    filename = ['tarres',int2str(i),'.mat'];
    valuename = ['tarres'];
    save(filename,valuename);
    
    filename = ['assres',int2str(i),'.mat'];
    valuename = ['assres'];
    save(filename,valuename);
    
    filename = ['time',int2str(i),'.mat'];
    valuename = ['time'];
    save(filename,valuename);
    
    filename = ['fit',int2str(i),'.mat'];
    valuename = ['fit'];
    save(filename,valuename);
    
end
