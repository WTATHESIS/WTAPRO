function [ ChildIndividual1 , ChildIndividual2 ] = CrossoverOperator( ParentIndividual1 , ParentIndividual2 , WeaponNum )
%CROSSOVEROPERATOR �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��

CrossoverPosition = randi([2,WeaponNum]);
ChildIndividual1 = ParentIndividual1;
ChildIndividual2 = ParentIndividual2;
for i = CrossoverPosition : WeaponNum
    ChildIndividual1(1,i) = ParentIndividual2(1,i);
    ChildIndividual2(1,i) = ParentIndividual1(1,i);
end

end

