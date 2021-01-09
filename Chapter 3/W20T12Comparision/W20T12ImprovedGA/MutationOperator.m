function [ Individual ] = MutationOperator( Individual , WeaponNum , TargetNum )
%UNTITLED 此处显示有关此函数的摘要
%   此处显示详细说明

MutationPos = randi(WeaponNum);     % 随机生成变异基因位
PreMutationGene = Individual(1,MutationPos);     % 保存变异基因位原基因编码
Individual(1,MutationPos) = randi(TargetNum);     % 变异操作

%   避免变异失效
while ( Individual(1,MutationPos) == PreMutationGene )
    Individual(1,MutationPos) = randi(TargetNum);
end

end

