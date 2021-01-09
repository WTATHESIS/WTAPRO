function [SPEA2OptimalSolution,SPEA2FitnessRecord,SPEA2Constraint] = SPEA2_SP_Output(archive,nArchive,SPEA2FitnessRecord,SPEA2Constraint,GenCount)
%SPEA2OUTPUT 此处显示有关此函数的摘要
%   此处显示详细说明

NonDomIndex = ones(nArchive,1);

for i = 1 : nArchive-1
    for j = i+1 : nArchive
        if all(archive(i).Fitness>=archive(j).Fitness) && any(archive(i).Fitness>archive(j).Fitness)
            NonDomIndex(i,1) = 0;
        end
        if all(archive(i).Fitness<=archive(j).Fitness) && any(archive(i).Fitness<archive(j).Fitness)
            NonDomIndex(j,1) = 0;
        end
    end
end

SPEA2OptimalSolution = archive(NonDomIndex==1);

OptimalSolutionNum = numel(SPEA2OptimalSolution);
for j = 1 : OptimalSolutionNum
    temp = SPEA2OptimalSolution(j).Fitness(1,2);
    SPEA2FitnessRecord(temp,GenCount) = SPEA2OptimalSolution(j).Fitness(1,1);
    SPEA2Constraint(temp,GenCount) = SPEA2OptimalSolution(j).Constraint;
end

end

