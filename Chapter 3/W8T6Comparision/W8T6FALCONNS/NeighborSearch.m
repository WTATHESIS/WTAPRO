function [ DecisionVector ] = NeighborSearch( NeighborSetOutput , NeighborSetCount ,TargetWeight , KillPro , WeaponNum , TargetNum )
%NEIGHBORSEARCH �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��

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

