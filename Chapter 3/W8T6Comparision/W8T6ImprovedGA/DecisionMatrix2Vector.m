function [ DecisionVector ] = DecisionMatrix2Vector( DecisionMatrix , WeaponNum , TargetNum )
%UNTITLED2 此处显示有关此函数的摘要
%   此处显示详细说明
DecisionVector = zeros(1,WeaponNum);
for i = 1 : WeaponNum
    for j = 1 : TargetNum
        if DecisionMatrix(i,j) == 1
            DecisionVector(1,i) = j;
        end
    end
end

end

