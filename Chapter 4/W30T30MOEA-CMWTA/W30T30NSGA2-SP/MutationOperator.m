function [ Child3 ] = MutationOperator( MatingPoolSize , MatingPool , mum ,WeaponNum , MaxScenario )
%MUTATIONOPERATOR 此处显示有关此函数的摘要
%   此处显示详细说明

MutationIndex = randi(MatingPoolSize);
Parent3 = MatingPool(MutationIndex).Position;
Child3 = Parent3;

for j = 1 : WeaponNum
    if any(Parent3(j,:)~=0)
        mu = rand;
        if mu <= 0.5
            delta = (2*mu).^ (1/(mum+1)) -1;
        else
            delta = 1 - (2*(1-mu)).^(1/(mum+1));
        end
        Child3(j,:) = Parent3(j,:) + MaxScenario .* ones(1,2) .* delta;
    end
end

[ Child3 ] = MaxScenarioConstraint( Child3 , MaxScenario , WeaponNum );

end

