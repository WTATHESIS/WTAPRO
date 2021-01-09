function [ GoodGene ] = GoodGeneGenerate( TargetWeight , KillPro , WeaponNum , TargetNum )
%UNTITLED2 �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��

GoodGeneFitness = zeros(WeaponNum,TargetNum);
GoodGene = zeros(1,WeaponNum);

for i = 1 : WeaponNum
    for j = 1 : TargetNum
        GoodGeneFitness(i,j) = TargetWeight(1,j) * KillPro(i,j);
    end
    [~,GoodGeneIndex] = max(GoodGeneFitness(i,:));
    GoodGene(1,i) = GoodGeneIndex;
end

end

