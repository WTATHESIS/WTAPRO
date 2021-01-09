x = [55:5:100];
y = [5:5:100];
for i = 1 : length(x)
    for j = 1 : length(y)
        filename = ['victory_',int2str(x(i)),'_',int2str(y(j))];
        load(filename);
        if victory == 1
            g = scatter(x(i),y(j),50,[0 0.4470 0.7410],'filled');
        elseif victory == 0
            b = scatter(x(i),y(j),50,[0.9290 0.6940 0.1250],'LineWidth',2);
        elseif victory == -1
            r = scatter(x(i),y(j),50,[0.8500 0.3250 0.0980],'x','LineWidth',2);
        end
        hold on
    end
end
grid on
xlim([50,105]);
xticks([55:5:100]);
% xlabel('武器数量');
xlabel('Weapon Number');
ylim([0,105]);
yticks([5:5:100]);
% ylabel('资产数量');
ylabel('Asset Number');
legend([g,b,r],'\Gamma = 1','\Gamma = 0','\Gamma = -1', ...
    'Location','southoutside','Orientation',"horizontal",'EdgeColor','none');

filename = [pwd,'/WeaAssVic/WeaAssVic_plt_en.eps'];
print('-depsc',filename);