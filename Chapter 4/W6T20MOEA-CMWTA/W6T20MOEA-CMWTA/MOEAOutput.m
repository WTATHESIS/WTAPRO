function [ MOEAOptimalSolution, MOEAFitnessRecord, MOEAConstraint ] = MOEAOutput( ElitePopSet , WeaponNum , MOEAFitnessRecord , MOEAConstraint , GenCount )
%MOEAOUTPUT 此处显示有关此函数的摘要
%   此处显示详细说明

j = 0;
for i = 1 : WeaponNum
    if ~isempty(ElitePopSet{1,i})
        j = j + 1;
        MOEAOptimalSolution(j,1) = ElitePopSet{1,i};
        temp = MOEAOptimalSolution(j,1).Fitness(1,2);
        if MOEAOptimalSolution(j,1).Constraint < MOEAConstraint(temp,GenCount)
            MOEAConstraint(temp,GenCount) = MOEAOptimalSolution(j,1).Constraint;
            MOEAFitnessRecord(temp,GenCount) = MOEAOptimalSolution(j,1).Fitness(1,1);
        elseif MOEAOptimalSolution(j,1).Constraint < MOEAConstraint(temp,GenCount) && MOEAOptimalSolution(j,1).Fitness(1,1) < MOEAFitnessRecord(temp,GenCount)
            MOEAFitnessRecord(temp,GenCount) = MOEAOptimalSolution(j,1).Fitness(1,1);
        end
    end
end

end

