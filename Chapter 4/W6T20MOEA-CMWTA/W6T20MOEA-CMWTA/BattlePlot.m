
load TargetPosition.mat
load SurviveThreshold.mat
load SafePosition.mat
load EnforceMatrix.mat

MaxScenario = 20;
sTarget = size(TargetPosition);
TargetNum = sTarget(1);
sSafe = size(SafePosition);
SafeNum = sSafe(1);

%% ����Ŀ���
for j = 1 : TargetNum
    if j == 14
        tempstr1 = '14(III)';
        text(TargetPosition(j,1)+0.2,TargetPosition(j,2),tempstr1);
        hold on
    elseif j == 6
        tempstr2 = '6(<0.2)';
        text(TargetPosition(j,1)-1.04,TargetPosition(j,2)+0.8,tempstr2);
        hold on
    elseif j == 13
        tempstr3 = '13(<0.1)';
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
