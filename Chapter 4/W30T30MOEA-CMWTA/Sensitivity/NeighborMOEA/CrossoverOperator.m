function [ Child1 , Child2 ] = CrossoverOperator( Parent1 , Parent2 , muc ,WeaponNum , MaxScenario )
%CROSSOVEROPERATOR 此处显示有关此函数的摘要
%   此处显示详细说明

Child1 = zeros(WeaponNum,2);
Child2 = zeros(WeaponNum,2);

mu = rand;
for j = 1 : WeaponNum
    if all(Parent1(j,:)==0) || all(Parent2(j,:)==0)
        Child1(j,:) = Parent2(j,:);
        Child2(j,:) = Parent1(j,:);
    else
%        mu = rand;
        if mu <= 0.5
            gamma = (2*mu).^(1/(muc+1));
        else
            gamma = (1/2/(1-mu)).^(1/(muc+1));
        end
        Child1(j,:) = 0.5*( (1+gamma)*Parent1(j,:) + (1-gamma)*Parent2(j,:) );
        Child2(j,:) = 0.5*( (1-gamma)*Parent1(j,:) + (1+gamma)*Parent2(j,:) );
    end
end

[ Child1 ] = MaxScenarioConstraint( Child1, MaxScenario , WeaponNum );
[ Child2 ] = MaxScenarioConstraint( Child2, MaxScenario , WeaponNum );

end

