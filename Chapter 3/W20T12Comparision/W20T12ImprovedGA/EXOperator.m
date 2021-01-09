function [ ChildIndividual1 , ChildIndividual2 ] = EXOperator( ParentIndividual1 , ParentIndividual2 , WeaponNum , GoodGene )
%EXOPERATOR �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��

ChildIndividual1 = ParentIndividual1;
ChildIndividual2 = ParentIndividual2;

Mc = randi([1,WeaponNum-1]);    % �����ظ�����

for j = 1 : Mc

    SameGene = zeros(1,WeaponNum);
    OperatorList = [1:1:WeaponNum];
    %%%%% ȷ����ͬ����λ&�������λ=�̳�λ
    for i = 1 : WeaponNum
        if ParentIndividual1(1,i) == ParentIndividual2(1,i)
            SameGene(1,i) = ParentIndividual1(1,i);
            if SameGene(1,i) == GoodGene(1,i)
                OperatorList( OperatorList == i ) = [];
            end
        end
    end
    %%%%% �������
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

