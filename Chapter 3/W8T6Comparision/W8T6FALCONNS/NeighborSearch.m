function [ DecisionVector ] = NeighborSearch( NeighborSetOutput , NeighborSetCount ,TargetWeight , KillPro , WeaponNum , TargetNum )
%NEIGHBORSEARCH 此处显示有关此函数的摘要
%   此处显示详细说明

NeighborCountMatrix = zeros(WeaponNum,TargetNum);

for i = 1 : WeaponNum
    for j = 1 : NeighborSetCount
        Assign = NeighborSetOutput(j,i);
        NeighborCountMatrix(i,Assign) = NeighborCountMatrix(i,Assign) + 1;
    end
end

GeneFitness = zeros(WeaponNum,TargetNum);
for i = 1 : WeaponNum
    for j = 1 : TargetNum
        GeneFitness(i,j) = TargetWeight(1,j) * KillPro(i,j);
    end
end

EvaluateMatrix = NeighborCountMatrix + GeneFitness;

DecisionVector = zeros(1,WeaponNum);
for i = 1 : WeaponNum
    [~,MaxNeighborAssign]=max(EvaluateMatrix(i,:));
    DecisionVector(1,i) = MaxNeighborAssign;
end

end

