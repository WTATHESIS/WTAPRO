
TargetNum = 30;
WeaponNum = 30;
MaxScenario = 30;
SafeNum = 3;

load('TargetPosition.mat')
load('SurviveThreshold.mat')
load('SafePosition.mat')
load('EnforceMatrix.mat')
load('KillRange.mat')

% TargetPosition = 28*rand(TargetNum,2)+1;
% KillRange = [2.1:0.1:5];
% SurviveThreshold = ones(1,30);
% SurviveThreshold(5) = 0.3;
% SurviveThreshold(12) = 0.2;
% SurviveThreshold(25) = 0.4;
% EnforceMatrix = zeros(WeaponNum,TargetNum);
% EnforceMatrix(7,9) = 1;
% EnforceMatrix(19,13) = 1;
%SafePosition = 20*rand(SafeNum,2)+5;

%% ����Ŀ���?
for j = 1 : TargetNum
    if j == 7
        tempstr1 = '7(IX)';
        text(TargetPosition(j,1)+0.2,TargetPosition(j,2),tempstr1);
        hold on
    elseif j == 19
        tempstr1 = '7(XIII)';
        text(TargetPosition(j,1)+0.2,TargetPosition(j,2),tempstr1);
        hold on
    elseif j == 5
        tempstr2 = '5(<0.3)';
        text(TargetPosition(j,1)-1.04,TargetPosition(j,2)+0.8,tempstr2);
        hold on
    elseif j == 12
        tempstr3 = '12(<0.2)';
        text(TargetPosition(j,1)-1.2,TargetPosition(j,2)+0.8,tempstr3);
        hold on
    elseif j == 25
        tempstr3 = '25(<0.4)';
        text(TargetPosition(j,1)-1.2,TargetPosition(j,2)+0.8,tempstr3);
        hold on
    else
        text(TargetPosition(j,1)+0.2,TargetPosition(j,2),num2str(j));
        hold on
    end
end

% x1 = [ 0.323 , 0.323 ];
% y1 = [ 0.636 , 0.586 ];
% annotation('textarrow',x1,y1,'String','���˸���<0.2');
% 
% x1 = [ 0.645 , 0.645 ];
% y1 = [ 0.23 , 0.18 ];
% annotation('textarrow',x1,y1,'String','���˸���<0.1');

%% ���ư�ȫ��
scatter(TargetPosition(:,1),TargetPosition(:,2),'d','r','filled');
scatter(SafePosition(:,1),SafePosition(:,2),'o','b','filled');
xlim([0,MaxScenario]);
ylim([0,MaxScenario]);
legend('Threat Target','Friendly/Neutral');
xlabel('X');
ylabel('Y','Rotation',360);
%set(gca, 'color', [0.99,0.99,0.99]);
print('-depsc','BattlePlot.eps')

% save('TargetPosition.mat','TargetPosition')
% save('SurviveThreshold.mat','SurviveThreshold')
% save('SafePosition.mat','SafePosition')
% save('EnforceMatrix.mat','EnforceMatrix')
% save('KillRange.mat','KillRange')
