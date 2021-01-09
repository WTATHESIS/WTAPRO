function [ FitnessConvergence ] = ConvergenceFitness( ParetoSet, FitnessSet )
%CONVERGENCEFITNESS 此处显示有关此函数的摘要
%   此处显示详细说明
FitnessConvergence = 0;

for i = 2 : 6
    FitnessConvergence = FitnessConvergence + FitnessSet(i,1) - ParetoSet(i,1);
end

FitnessConvergence = FitnessConvergence/5;

end

