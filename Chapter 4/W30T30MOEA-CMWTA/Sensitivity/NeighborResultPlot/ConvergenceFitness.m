function [ FitnessConvergence ] = ConvergenceFitness( ParetoSet, FitnessSet )
%CONVERGENCEFITNESS �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
FitnessConvergence = 0;

for i = 2 : 6
    FitnessConvergence = FitnessConvergence + FitnessSet(i,1) - ParetoSet(i,1);
end

FitnessConvergence = FitnessConvergence/5;

end

