function [ WeaponPosition , FeasibleFlag ] = WeaponPositionFeasible( WeaponPosition , WeaponNum , TargetPosition , TargetNum , KillRange , SurviveThreshold , EnforceMatrix )
%SOLUTIONFEASIBLE �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��

DecisionMatrix = zeros(WeaponNum,TargetNum);
UseWeaponNum = 0;

for i = 1 : WeaponNum
    if any(WeaponPosition(i,:) ~= 0)
        for j = 1 : TargetNum
            D = KillRange(1,i).^2;
            R = (TargetPosition(j,1)-WeaponPosition(i,1)).^2 + (TargetPosition(j,2)-WeaponPosition(i,2)).^2;
            if R<=D
                DecisionMatrix(i,j) = 1;
            end
        end
    end
end

for j = 1 : WeaponNum
    if any(DecisionMatrix(j,:) ~= 0)
        UseWeaponNum = UseWeaponNum + 1;
    else
        WeaponPosition(j,:) = [0,0];
    end
end

%% �����ǿռ��
if UseWeaponNum == 0
    UseFlag = false;
else
    UseFlag = true;
end

%% ����Ŀ�깥�����
for j = 1 : TargetNum
    if SurviveThreshold(1,j) < 1
        if all(DecisionMatrix(:,j) == 0)
            SurviveFlag = false;
            break;
        else
            SurviveFlag = true;
        end
    end
end
 %% ǿ�Ʒ�����
[ EnforceWeaponIndex , EnforceTargetIndex ] = find(EnforceMatrix==1);
if DecisionMatrix(EnforceWeaponIndex,EnforceTargetIndex) == 1
    EnforceFlag = true;
else
    EnforceFlag = false;
end

FeasibleFlag = UseFlag && SurviveFlag && EnforceFlag;

end

