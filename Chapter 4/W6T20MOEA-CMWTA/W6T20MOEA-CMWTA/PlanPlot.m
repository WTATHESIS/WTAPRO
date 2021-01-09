function [] = PlanPlot(OptimalSolution,WeaponNum,KillRange,TargetNum,TargetWeight,TargetPosition,SafePosition,EnforceWeaponIndex,EnforceTargetIndex,Str , ColorSet,i)
%PLANPLOT �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
if ~isempty(OptimalSolution{1,i})
    
    figure(i);
    
    %% ����Ŀ���
    for j = 1 : TargetNum
        text(TargetPosition(j,1)+0.2,TargetPosition(j,2),num2str(j));
        hold on
    end
    
    %% ���ư�ȫ��
    scatter(TargetPosition(:,1),TargetPosition(:,2),'d','r','filled');
    scatter(SafePosition(:,1),SafePosition(:,2),'o','b','filled');
    
    WeaponPosition = OptimalSolution{1,i}.Position;
    tempCount = 0;
    for j = 1 : WeaponNum
        if WeaponPosition(j,:) ~= 0
            scatter(WeaponPosition(j,1),WeaponPosition(j,2),'x','k','LineWidth',1.5);
            tempCount = tempCount + 1;
            if tempCount == 1
                tempx = [TargetPosition(EnforceTargetIndex,1),WeaponPosition(EnforceWeaponIndex,1)];
                tempy = [TargetPosition(EnforceTargetIndex,2),WeaponPosition(EnforceWeaponIndex,2)];
                plot(tempx,tempy,'k--');
            end
        end
    end
    
    axis equal
    xlim([-3,22]);
    ylim([-5,20]);
    xlabel('X');
    ylabel('Y','Rotation',360);
    %% ����������Χ
    WeaponPlot( WeaponPosition , KillRange , WeaponNum , Str , ColorSet );
    %legend('Threat','Friendly/Neutral','Aiming Point','Preference','Weapon ��','Weapon ��','Weapon ��','Weapon ��','Weapon ��','Weapon ��');
    %% ��ʾ���˸�������ֵ
    [ DecisionMatrix , KillPro ] = WTAMatrixGenerate( WeaponNum , WeaponPosition , KillRange , TargetNum , TargetPosition );
    [ ~ , TargetSurvive ] = TargetKillProCompute( WeaponNum , TargetNum , TargetWeight , KillPro , DecisionMatrix );
    
    x1 = [ 0.385 , 0.404 ];
    y1 = [ 0.686 , 0.646 ];
    if TargetSurvive(1,6) < 0.01
        annotation('textarrow',x1,y1,'String','<0.01(0.2)');
    else
        TargetSurvive(1,6) = roundn(TargetSurvive(1,6),-2);
        str1 = num2str(TargetSurvive(1,6));
        str2 = [str1,'(0.2)'];
        annotation('textarrow',x1,y1,'String',str2);
    end
    x1 = [ 0.590 , 0.606 ];
    y1 = [ 0.363 , 0.323 ];
    if TargetSurvive(1,13) < 0.01
        annotation('textarrow',x1,y1,'String','<0.01(0.1)');
    else
        TargetSurvive(1,13) = roundn(TargetSurvive(1,13),-2);
        str1 = num2str(TargetSurvive(1,13));
        str2 = [str1,'(0.1)'];
        annotation('textarrow',x1,y1,'String',str2);
    end
    
end
end

