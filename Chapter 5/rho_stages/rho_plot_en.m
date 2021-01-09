
stagData = NaN(1,10);
navData = NaN(1,10);
weaResdata = NaN(1,10);
tarResData = NaN(1,10);

for rhoind = 1 : 10
    
    filename = ['stage',num2str(rhoind*10),'.mat'];
    load(filename);
    stageData(rhoind) = stage;
    
    filename = ['weares',num2str(rhoind*10),'.mat'];
    load(filename);
    weaResData(rhoind) = weares(end);
    
    filename = ['tarres',num2str(rhoind*10),'.mat'];
    load(filename);
    tarResData(rhoind) = tarres(end);
    
    filename = ['nav',num2str(rhoind*10),'.mat'];
    load(filename);
    navData(rhoind) = nav(end);
    
    filename = ['victory',num2str(rhoind*10),'.mat'];
    load(filename);
    vicData(rhoind) = victory;
    
end

figure(1);
subplot(5,1,1);
x = [0.1:0.1:1];
plot(x,vicData,'LineWidth',1.5);
set(gca,'Box','off');
ylabel('Mission indicator \Gamma');

subplot(5,1,2);
plot(x,stageData,'LineWidth',1.5);
set(gca,'Box','off');
ylabel('Number of stages');

subplot(5,1,3);
plot(x,navData,'LineWidth',1.5);
set(gca,'Box','off');
ylabel('NAV');

subplot(5,1,4);
plot(x,tarResData,'LineWidth',1.5);
set(gca,'Box','off');
ylabel('Number of targets');

subplot(5,1,5);
plot(x,weaResData,'LineWidth',1.5);
set(gca,'Box','off');
ylabel('Number of weapons');
xlabel('Threshold parameter \rho');

filename =[pwd,'/rho_stage_plot/rho_data.eps'];
print('-depsc',filename);

