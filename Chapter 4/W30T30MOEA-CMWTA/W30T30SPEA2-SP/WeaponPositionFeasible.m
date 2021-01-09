function [ WeaponPosition , FeasibleFlag ] = WeaponPositionFeasible( WeaponNum , WeaponPosition , TargetNum , TargetPosition , KillRange , SurviveThreshold , EnforceMatrix )
%SOLUTIONFEASIBLE 此处显示有关此函数的摘要
%   此处显示详细说明

%FeasibleFlag = 0;

DecisionMatrix = zeros(WeaponNum,TargetNum);
weaponvec = zeros(1,WeaponNum);
UseWeaponNum = 0;

for i = 1 : WeaponNum
    if any(WeaponPosition(i,:) ~= 0)
        weaponvec(1,i) = 1;
        for j = 1 : TargetNum
            D = KillRange(1,i)^2;
            R = (TargetPosition(j,1)-WeaponPosition(i,1)).^2 + (TargetPosition(j,2)-WeaponPosition(i,2)).^2;
            if R<=D
                DecisionMatrix(i,j) = 1;
            end
        end
    end
end

%% 强制分配检测
for j = 1 : TargetNum
    for i = 1 : WeaponNum
        if EnforceMatrix(i,j) == 1 && weaponvec(1,i) + DecisionMatrix(i,j) == 1
            AngleSeed = 2*pi*rand;
            DisSeed = KillRange(1,i).*rand;
            WeaponPosition(i,1) = TargetPosition(j,1) + DisSeed .* cos(AngleSeed);
            WeaponPosition(i,2) = TargetPosition(j,2) + DisSeed .* sin(AngleSeed);
            for k = 1 : TargetNum
                D = KillRange(1,i)^2;
                R = (TargetPosition(j,1)-WeaponPosition(i,1)).^2 + (TargetPosition(j,2)-WeaponPosition(i,2)).^2;
                if R<=D
                    DecisionMatrix(i,j) = 1;
                end
            end
            break;
        end
    end
end

%% 门限目标攻击检测
weaponind = [];
for i = 1 : WeaponNum
    if weaponvec(1,i) == 1 && sum(EnforceMatrix(i,:))==0
        weaponind = [weaponind,i];
    end
end
availablenum = length(weaponind);
for j = 1 : TargetNum
    if SurviveThreshold(1,j) + sum(DecisionMatrix(:,j)) <1
        if availablenum ~= 0
            selectedind = randi([1,availablenum]);
            selectedwea= weaponind(selectedind);
            weaponind(selectedind)=[];
            availablenum = availablenum - 1;
            AngleSeed = 2*pi*rand;
            DisSeed = KillRange(1,selectedwea).*rand;
            WeaponPosition(selectedwea,1) = TargetPosition(j,1) + DisSeed .* cos(AngleSeed);
            WeaponPosition(selectedwea,2) = TargetPosition(j,2) + DisSeed .* sin(AngleSeed);
            for k = 1 : TargetNum
                D = KillRange(1,i)^2;
                R = (TargetPosition(j,1)-WeaponPosition(i,1)).^2 + (TargetPosition(j,2)-WeaponPosition(i,2)).^2;
                if R<=D
                    DecisionMatrix(i,j) = 1;
                end
            end
        else
            break;
        end
    end
end

%% 一致性检测
for j = 1 : WeaponNum
    if any(DecisionMatrix(j,:) ~= 0)
        UseWeaponNum = UseWeaponNum + 1;
    else
        WeaponPosition(j,:) = [0,0];
    end
end

if UseWeaponNum == 0
    FeasibleFlag = false;
else
    FeasibleFlag = true;
end

end

