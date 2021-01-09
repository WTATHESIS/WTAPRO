function [ Individual ] = MaxScenarioConstraint( Individual, MaxScenario , WeaponNum )
%MAXSCENARIOCONSTRAINT 此处显示有关此函数的摘要
%   此处显示详细说明

for i =1 : WeaponNum
    for j = 1 : 2
        if Individual(i,j) > MaxScenario
            Individual(i,j) = MaxScenario;
        elseif Individual(i,j) < 0
            Individual(i,j) = 0;
        end
    end
end

end

