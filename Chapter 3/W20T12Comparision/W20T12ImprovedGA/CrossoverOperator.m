function [ ChildIndividual1 , ChildIndividual2 ] = CrossoverOperator( ParentIndividual1 , ParentIndividual2 , WeaponNum )
%CROSSOVEROPERATOR 此处显示有关此函数的摘要
%   此处显示详细说明

CrossoverPosition = randi([2,WeaponNum]);
ChildIndividual1 = ParentIndividual1;
ChildIndividual2 = ParentIndividual2;
for i = CrossoverPosition : WeaponNum
    ChildIndividual1(1,i) = ParentIndividual2(1,i);
    ChildIndividual2(1,i) = ParentIndividual1(1,i);
end

end

