function [ ChildIndividual1 , ChildIndividual2 ] = EXOperator( ParentIndividual1 , ParentIndividual2 , WeaponNum , GoodGene )
%EXOPERATOR 此处显示有关此函数的摘要
%   此处显示详细说明

ChildIndividual1 = ParentIndividual1;
ChildIndividual2 = ParentIndividual2;

Mc = randi([1,WeaponNum-1]);    % 交叉重复次数

for j = 1 : Mc

    SameGene = zeros(1,WeaponNum);
    OperatorList = [1:1:WeaponNum];
    %%%%% 确定相同基因位&优秀基因位=继承位
    for i = 1 : WeaponNum
        if ParentIndividual1(1,i) == ParentIndividual2(1,i)
            SameGene(1,i) = ParentIndividual1(1,i);
            if SameGene(1,i) == GoodGene(1,i)
                OperatorList( OperatorList == i ) = [];
            end
        end
    end
    %%%%% 交叉操作
    CrossoverPosition = randperm(length(OperatorList),2);
    ChildIndividual1(1,CrossoverPosition(1)) = ParentIndividual2(1,CrossoverPosition(2));
    ChildIndividual1(1,CrossoverPosition(2)) = ParentIndividual2(1,CrossoverPosition(1));
    ChildIndividual2(1,CrossoverPosition(1)) = ParentIndividual1(1,CrossoverPosition(2));
    ChildIndividual2(1,CrossoverPosition(2)) = ParentIndividual1(1,CrossoverPosition(1));
    
    if length(OperatorList) < 2
        break;
    end
    
    ParentIndividual1 = ChildIndividual1;
    ParentIndividual2 = ChildIndividual2;
    
end

end

