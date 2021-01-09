function [ DecisionMatrix , KillPro ] = WTAMatrixGenerate( WeaponNum , WeaponPosition , KillRange , TargetNum , TargetPosition )
%DECISIONMATRIXGENERATE 此处显示有关此函数的摘要
%   此处显示详细说明

DecisionMatrix = zeros(WeaponNum,TargetNum);
KillPro = zeros(WeaponNum,TargetNum);
%UsedWeaponNum = sum(WeaponPosition(:,1)~=0);

for i = 1 : WeaponNum
    if any(WeaponPosition(i,:) ~= 0)
        for j = 1 : TargetNum
            D = KillRange(1,i)^2;
            R = (TargetPosition(j,1)-WeaponPosition(i,1)).^2 + (TargetPosition(j,2)-WeaponPosition(i,2)).^2;
            if R < D
                KillPro(i,j) = 1 - exp(-D/R);
                DecisionMatrix(i,j) = 1;
            end
        end
    end
end

end

