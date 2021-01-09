function [NSGA2OptimalSolution,NSGA2FitnessRecord,NSGA2Constraint] = NSGA2Output(NSGA2OptimalSolution,NSGA2FitnessRecord,NSGA2Constraint,GenCount)
%NSGA2OUTPUT 此处显示有关此函数的摘要
%   此处显示详细说明
OptimalSolutionNum = numel(NSGA2OptimalSolution);
for j = 1 : OptimalSolutionNum
    temp = NSGA2OptimalSolution(j).Fitness(1,2);
    if NSGA2OptimalSolution(j).Constraint <  NSGA2Constraint(temp,GenCount)
        NSGA2Constraint(temp,GenCount) = NSGA2OptimalSolution(j).Constraint;
        NSGA2FitnessRecord(temp,GenCount) = NSGA2OptimalSolution(j).Fitness(1,1);
    elseif NSGA2OptimalSolution(j).Constraint ==  NSGA2Constraint(temp,GenCount) && NSGA2OptimalSolution(j).Fitness(1,1) < NSGA2FitnessRecord(temp,GenCount)
        NSGA2FitnessRecord(temp,GenCount) = NSGA2OptimalSolution(j).Fitness(1,1);
    end
end

