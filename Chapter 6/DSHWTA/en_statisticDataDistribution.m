
stageList = NaN(1,30);
for simulateIndex = 1 : 30
    file = [pwd,'/OldResults/stageCount',num2str(simulateIndex),'.mat'];
    load(file)
    stageList(1,simulateIndex) = stageCount;
end
stageMax = max(stageList,[],2);

stageMean = mean(stageList)
stageStd = std(stageList)

subplot(6,1,1);
victoryData = NaN(1,stageMax);
for simulateIndex =  1 : 30
    fileName = [pwd,'/OldResults/victoryRecord',num2str(simulateIndex),'.mat'];
    load(fileName);
    victoryData(1,simulateIndex) = victoryRecord;
end
bar(victoryData);
% plot(victoryData);
xlim([0,31]);
ylabel('Mission state\Gamma');
yticks([0 1]);
% yticklabels({'-1','0','1'});
title('(a) Mission completion state in case 1 over 30 independent simulations')

subplot(6,1,2);
interceptionData = NaN(1,stageMax);
for simulateIndex = 1 : 30
    fileName = [pwd,'/OldResults/stageCount',num2str(simulateIndex),'.mat'];
    load(fileName)
    interceptionData(1,simulateIndex) = stageCount;
end
bar(interceptionData);
xlim([0,31]);
ylim([0,stageMax]);
ylabel('Salvo times');
title('(b) Salvo times in case 1 over 30 independent simulations');

subplot(6,1,3);
weaponData = NaN(30,stageMax);
for simulateIndex = 1 : 30
    file = [pwd,'/OldResults/weaponStateRecord',num2str(simulateIndex),'.mat'];
    load(file);
    for stageIndex = 1 : stageList(1,simulateIndex)
        if stageIndex == 1
            weaponData(simulateIndex,stageIndex) = 16 - sum(weaponStateRecord(:,stageIndex,:)~=0,'all');
        else
            weaponData(simulateIndex,stageIndex) = sum(weaponStateRecord(:,stageIndex-1,:)~=0,'all') - sum(weaponStateRecord(:,stageIndex,:)~=0,'all');
        end
    end
end
bar(weaponData,'stacked');
xlim([0,31]);
ylim([0 16]);
ylabel('Weapon consumption');
title('(c) Weapon consumption distribution in case 1 over 30 independent simulations');
weaponData = sum(weaponData,2,'omitnan');
weaponMean = mean(weaponData,'omitnan')
weaponStd = std(weaponData,'omitnan')

subplot(6,1,4)
targetData = NaN(30,stageMax);
for simulateIndex = 1 : 30
    file = [pwd,'/OldResults/targetStateRecord',num2str(simulateIndex),'.mat'];
    load(file);
    for stageIndex = 1 : stageList(1,simulateIndex)
        if stageIndex == 1
            targetData(simulateIndex,stageIndex) = 8 - sum(targetStateRecord(:,:,stageIndex),'all');
        else
            targetData(simulateIndex,stageIndex) = sum(targetStateRecord(:,:,stageIndex-1),'all') - sum(targetStateRecord(:,:,stageIndex),'all');
        end
    end
end
bar(targetData,'stacked');
xlim([0,31]);
ylim([0 8]);
ylabel('Interception number');
title('(d) Number distribution of intercepted targets in case 1 over 30 independent simulations');

subplot(6,1,5)
decisionTimeData = NaN(30,stageMax);
for simulateIndex = 1 : 30
    file = [pwd,'/OldResults/decisionTimeRecord',num2str(simulateIndex),'.mat'];
    load(file);
    for stageIndex =  1 : stageList(1,simulateIndex)
        if stageIndex == 1
            decisionTimeData(simulateIndex,stageIndex) = decisionTimeRecord(1,1,stageIndex);
        else
            decisionTimeData(simulateIndex,stageIndex) = decisionTimeRecord(1,1,stageIndex) - decisionTimeRecord(1,1,stageIndex-1);
        end
    end
end
bar(decisionTimeData,'stacked');
xlim([0,31]);
ylabel('Decision time/s');
title('(e) Decision time distribution in case 1 over 30 independent simulations')

subplot(6,1,6)
timeData = NaN(30,stageMax);
for simulateIndex = 1 : 30
    file = [pwd,'/OldResults/timeRecord',num2str(simulateIndex),'.mat'];
    load(file);
    for stageIndex =  1 : stageList(1,simulateIndex)
        timeData(simulateIndex,stageIndex) = timeRecord(1,1,stageIndex);
    end
end
bar(timeData,'stacked');
xlim([0,31]);
xlabel('Simulation sequence');
ylabel('Computation time/s')
title('(f) Computation time distribution in case 1 over 30 independent simulations');
legend('1st decision/salvo','2nd decision/salvo','3rd decision/salvo','4th decision/salvo','5th decision/salvo','decision/salvo 6','Orientation','horizontal');

timeData = sum(timeData,2,'omitnan');
timeData = timeData./stageList';
timeMean = mean(timeData,'omitnan')
timeStd = std(timeData,'omitnan')
% 
% file = [pwd,'/Chapter6Figures/StatisticsCase1.eps'];
% print('-depsc',file);
