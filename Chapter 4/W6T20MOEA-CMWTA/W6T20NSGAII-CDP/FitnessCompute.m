function [ Fitness , TargetSurvive ] = FitnessCompute( WeaponNum , WeaponPosition , TargetNum , TargetPosition , TargetWeight , KillRange )
%FITNESSCOMPUTE 此处显示有关此函数的摘要
%   此处显示详细说明

Fitness = zeros(1,2);

[ DecisionMatrix , KillPro ] = WTAMatrixGenerate( WeaponNum , WeaponPosition , KillRange , TargetNum , TargetPosition );

[ Fitness(1,1) , TargetSurvive ] = TargetKillProCompute( WeaponNum , TargetNum , TargetWeight , KillPro , DecisionMatrix );

for j = 1 : WeaponNum
    if any( DecisionMatrix(j,:) ~= 0 )
        Fitness(1,2) = Fitness(1,2) + 1;
    end
end

end

