
weanum = 100;
tarnum = 20;
assnum = 20;

weakilllow = 0.3;
weakillhigh = 0.8;

tarkilllow = 0.3;
tarkillhigh = 0.8;

avahig = 0.9;
avalow = 0.1;
maxtim = 10;

sollen = 2;
effthrlist = [0.1:0.1:1];
popsize = 10;
curwei = 0.8;

wealist = NaN(9,1);

for k = 1: 10
    
    effthr = effthrlist(k);
    % weakillpro = weakilllow + (weakillhigh-weakilllow) .* rand(weanum,tarnum);
    % save('weakillpro.mat','weakillpro');
    % tarkillpro = tarkilllow + (tarkillhigh-tarkilllow) .* rand(tarnum,assnum);
    % save tarkillpro.mat tarkillpro;
    % assval = rand(1,assnum);
    % save assval.mat assval
    
    load weakillpro.mat
    load tarkillpro.mat
    load assval.mat
    
    weasta = ones(1,weanum);
    tarsta = ones(1,tarnum);
    asssta = ones(1,assnum);
    tarassava = ones(tarnum,assnum);
    
    weadec = zeros(weanum,tarnum);
    
    %% 识别目标-资产攻击矩阵
    [tardec] = target_asset_assign(tarnum,assnum,tarkillpro,assval,tarassava,0);
    
    %% 判断武器-目标可行性矩阵
    weatarsta = weapon_target_state_update(weanum,tarnum,weasta,tarsta,avahig,avalow,maxtim);
    
    %% 选择待攻击目标，生成武器-目标决策矩阵
    [decout,staout,fitout,fitrec,tarsurproout,asssurproout] = weapon_target_asset_assign(weanum,tarnum,assnum,weasta,tarsta,asssta,weakillpro,tarkillpro,assval,weatarsta,tardec,popsize,sollen,effthr,curwei);
    
    wealist(k,1) = size(fitrec,1);
    
end

save wealist.mat wealist

% weare = NaN(size(fitrec,1),1);
% for i = 1 : size(fitrec,1)
%     if i == 1
%         weare(i) = fitrec(1,2);
%     else
%         weare(i) = fitrec(i,2) - fitrec(i-1,2);
%     end
% end
% 
% figure(1)
% plot(fitrec(:,2));
% figure(2)
% plot(weare);




