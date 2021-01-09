function [MOEADOptimalSolution,MOEADFitnessRecord,MOEADConstraint] = MOEADOutput(MOEADOptimalSolution,MOEADFitnessRecord,MOEADConstraint,GenCount)
%MOEADOUTPUT �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
OptimalSolutionNum = numel(MOEADOptimalSolution);
for j = 1 : OptimalSolutionNum
    temp = MOEADOptimalSolution(j).Fitness(1,2);
    if MOEADOptimalSolution(j).Constraint <  MOEADConstraint(temp,GenCount)
        MOEADConstraint(temp,GenCount) = MOEADOptimalSolution(j).Constraint;
        MOEADFitnessRecord(temp,GenCount) = MOEADOptimalSolution(j).Fitness(1,1);
    elseif MOEADOptimalSolution(j).Constraint ==  MOEADConstraint(temp,GenCount) && MOEADOptimalSolution(j).Fitness(1,1) < MOEADFitnessRecord(temp,GenCount)
        MOEADFitnessRecord(temp,GenCount) = MOEADOptimalSolution(j).Fitness(1,1);
    end
end

