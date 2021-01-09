function [NSGA2OptimalSolution,NSGA2FitnessRecord,NSGA2Constraint] = NSGA2_SP_Output(NextPopulation,NSGA2FitnessRecord,NSGA2Constraint,GenCount)
%NSGA2OUTPUT 此处显示有关此函数的摘要
%   此处显示详细说明

NonDomSol = NextPopulation([NextPopulation.LevelRank]==1);
NonDomNum = numel(NonDomSol);
NonDomIndex = ones(NonDomNum,1);

for i = 1 : NonDomNum-1
    for j = i+1 : NonDomNum
        if all(NonDomSol(i).Fitness>=NonDomSol(j).Fitness) && any(NonDomSol(i).Fitness>NonDomSol(j).Fitness)
            NonDomIndex(i,1) = 0;
        end
        if all(NonDomSol(i).Fitness<=NonDomSol(j).Fitness) && any(NonDomSol(i).Fitness<NonDomSol(j).Fitness)
            NonDomIndex(j,1) = 0;
        end
    end
end

NSGA2OptimalSolution = NonDomSol(NonDomIndex==1);

OptimalSolutionNum = numel(NSGA2OptimalSolution);
for j = 1 : OptimalSolutionNum
    temp = NSGA2OptimalSolution(j).Fitness(1,2);
    NSGA2FitnessRecord(temp,GenCount) = NSGA2OptimalSolution(j).Fitness(1,1);
    NSGA2Constraint(temp,GenCount) = NSGA2OptimalSolution(j).Constraint;
end

end

