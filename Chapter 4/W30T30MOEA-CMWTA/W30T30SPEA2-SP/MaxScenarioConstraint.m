function [ Individual ] = MaxScenarioConstraint( Individual, MaxScenario , WeaponNum )
%MAXSCENARIOCONSTRAINT �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��

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

