
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

% wealist = NaN(9,1);



effthr = 1;


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


weare = NaN(size(fitrec,1),1);
for i = 1 : size(fitrec,1)
    if i == 1
        weare(i) = fitrec(1,2);
    else
        weare(i) = fitrec(i,2) - fitrec(i-1,2);
    end
end

load wealist.mat
% wealist = [4 10 19 20 30 40 100];

figure(1);
subplot(2,1,1);
for i = 1 : 7
    plot([wealist(i),wealist(i)],[0,1],'--','LineWidth',1);
    hold on
end
plot(fitrec(:,2),'LineWidth',1.5);
% xlabel('武器消耗数量');
ylabel('NVSA');
set(gca,'Box','off');
rho_legend = {'\rho = 0.1' '\rho = 0.2' '\rho = 0.3' '\rho = 0.4~0.7' '\rho = 0.8' '\rho = 0.9' '\rho = 1'};
legend(rho_legend);

subplot(2,1,2);
for i = 1 : 7
    plot([wealist(i),wealist(i)],[0,1],'--','LineWidth',1);
    hold on
end
plot(weare,'LineWidth',1.5);
xlabel('Weapon consumption');
ylabel('Return of asset value');
set(gca,'Box','off');
% rho_legend = {'\rho = 0.1' '\rho = 0.2' '\rho = 0.3' '\rho = 0.4~0.7' '\rho = 0.8' '\rho = 0.9' '\rho = 1'};
% legend(rho_legend);

file = ['en_rho_plot.eps'];
print('-depsc',file);



