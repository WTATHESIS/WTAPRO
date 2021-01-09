%% 剩余资产数量
figure(1)
for i = 1 : 9
    filename = ['assres',int2str(i),'.mat'];
    load(filename);
    plot(assres,'LineWidth',1.5);
    statot = length(assres);
    if i == 1
        legendtext = ['\lambda',' = 0.1'];
        text(statot-0.35,assres(statot)+0.8,legendtext,"FontSize",13);
    elseif i < 7
        legendtext = ['\lambda',' = 0.',int2str(i)];
        text(statot,assres(statot),legendtext,"FontSize",13);
    elseif i == 7
        legendtext = ['\lambda',' = 0.7,0.8,0.9'];
        text(statot,assres(statot),legendtext,"FontSize",13);
    end
    hold on
end
xticks([1,2,3,4,5]);
xlabel('Index of stage',"FontSize",16);
ylabel('Number of assets',"FontSize",16);
set(gca,'FontSize',16)
filename = [pwd,'/lambda_figure/Ass_Res_en.eps'];
print('-depsc',filename);

%% 剩余目标数量
figure(2)
lentex = cell(1,9);
for i = 1 : 9
    filename = ['tarres',int2str(i),'.mat'];
    load(filename);
    plot(tarres,'LineWidth',1.5);
    plttex = ['\lambda = 0.',int2str(i)];
    lentex{i} = plttex;
    hold on
end
legend(lentex,'FontSize',13);
xticks([1,2,3,4,5]);
xlabel('Index of stage',"FontSize",16);
ylabel('Number of targets',"FontSize",16);
set(gca,'FontSize',16)
filename = [pwd,'/lambda_figure/Tar_Res_en.eps']
print('-depsc',filename);

%% 剩余武器数量
figure(3)
for i = 1 : 9
    filename = ['weares',int2str(i),'.mat'];
    load(filename);
    plot(weares,'LineWidth',1.5);
    statot = length(weares);
    if i == 1
        legendtext = ['\lambda',' = 0.1'];
        text(statot-0.35,weares(statot)+5,legendtext,"FontSize",13);
    else
        legendtext = ['\lambda',' = 0.',int2str(i)];
        text(statot,weares(statot),legendtext,"FontSize",13);
    end
    hold on
end
xticks([1,2,3,4,5]);
xlabel('Index of stage',"FontSize",16);
ylabel('Number of weapons',"FontSize",16);
set(gca,'FontSize',16)
filename = [pwd,'/lambda_figure/Wea_Res_en.eps']
print('-depsc',filename);

%% NMVSA
figure(4)
for i = 1 : 9
    filename = ['nmvsa',int2str(i),'.mat'];
    load(filename);
    plot(nmvsa,'LineWidth',1.5);
    statot = length(nmvsa);
    if i == 1
        legendtext = ['\lambda',' = 0.1'];
        text(statot-0.35,nmvsa(statot)+0.02,legendtext,"FontSize",13);
    elseif i == 6
        legendtext = ['\lambda = 0.6'];
        text(statot,nmvsa(statot)-0.005,legendtext,"FontSize",13);
    elseif i == 7
        legendtext = ['\lambda = 0.7'];
        text(statot,nmvsa(statot)+0.011,legendtext,"FontSize",13);
    elseif i == 8
        legendtext = ['\lambda = 0.8'];
        text(statot,nmvsa(statot),legendtext,"FontSize",13);
    elseif i == 9
        legendtext = ['\lambda',' = 0.9'];
        text(statot,nmvsa(statot)-0.011,legendtext,"FontSize",13);
    else
        legendtext = ['\lambda',' = 0.',int2str(i)];
        text(statot,nmvsa(statot),legendtext,"FontSize",13);
    end
    hold on
end
xticks([1,2,3,4,5]);
xlabel('Index of stage',"FontSize",16);
ylabel('NAV',"FontSize",16);
set(gca,'FontSize',16)
filename = [pwd,'/lambda_figure/NAV_en.eps']
print('-depsc',filename);

%% 目标函数fit
figure(5)
for i = 1 : 9
    filename = ['fit',int2str(i),'.mat'];
    load(filename);
    plot(fit(:,1),'LineWidth',1.5);
    statot = size(fit,1);
    if i == 1
        legendtext = ['\lambda',' = 0.1'];
        text(statot-0.28,fit(statot,1)+0.02,legendtext,"FontSize",13);
    else
        legendtext = ['\lambda',' = 0.',int2str(i)];
        text(statot,fit(statot,1),legendtext,"FontSize",13);
    end
    hold on
end
% legend(lentex,'FontSize',13);
xticks([1,2,3,4,5]);
xlabel('Index of stage',"FontSize",16);
ylabel('Fitness of plan',"FontSize",16);
set(gca,'FontSize',16)
filename = [pwd,'/lambda_figure/Fit_Res_en.eps']
print('-depsc',filename);
