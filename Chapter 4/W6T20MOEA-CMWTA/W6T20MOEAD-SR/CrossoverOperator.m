function [ Child1 , Child2 ] = CrossoverOperator( WeaponNum , KillRange , TargetNum , TargetPosition , SurviveThreshold , EnforceMatrix , MaxScenario , SubProblem , Population , muc , IndividualIndex )
%CROSSOVEROPERATOR 此处显示有关此函数的摘要
%   此处显示详细说明

%% 模拟二进制交叉算子
Child1.Position = zeros(WeaponNum,2);
Child1.Fitness = zeros(1,2);
Child1.g = 0;
Child1.IsDominated = 0;
Child1.Constraint = 0;

Child2.Position = zeros(WeaponNum,2);
Child2.Fitness = zeros(1,2);
Child2.g = 0;
Child2.IsDominated = 0;
Child2.Constraint = 0;

temp1 = SubProblem(IndividualIndex).Neighbor;
temp2 = temp1(randperm(length(temp1),2));
Parent1 = Population(temp2(1)).Position;
Parent2 = Population(temp2(2)).Position;

for j = 1 : WeaponNum
    if all(Parent1(j,:)==0) && any(Parent2(j,:)~=0)
        Child1.Position(j,:) = Parent2(j,:);
        Child2.Position(j,:) = Parent1(j,:);
    elseif any(Parent1(j,:)~=0) && all(Parent2(j,:)==0)
        Child1.Position(j,:) = Parent2(j,:);
        Child2.Position(j,:) = Parent1(j,:);
    elseif all(Parent1(j,:)==0) && all(Parent2(j,:)==0)
        Child1.Position(j,:) = 0;
        Child2.Position(j,:) = 0;
    else
        mu = rand;
        if mu <= 0.5
            gamma = (2*mu).^(1/(muc+1));
        else
            gamma = (1/2/(1-mu)).^(1/(muc+1));
        end
        Child1.Position(j,:) = 0.5*( (1+gamma)*Parent1(j,:) + (1-gamma)*Parent2(j,:) );
        Child2.Position(j,:) = 0.5*( (1-gamma)*Parent1(j,:) + (1+gamma)*Parent2(j,:) );
    end
end

[ Child1.Position ] = MaxScenarioConstraint( Child1.Position, MaxScenario , WeaponNum );
[ Child2.Position ] = MaxScenarioConstraint( Child2.Position, MaxScenario , WeaponNum );

[ Child1.Position , FeasibleFlag ] = WeaponPositionFeasible( Child1.Position , WeaponNum , TargetPosition , TargetNum , KillRange , SurviveThreshold , EnforceMatrix );
if FeasibleFlag == false
    Child1.Position = [];
end

[ Child2.Position , FeasibleFlag ] = WeaponPositionFeasible( Child2.Position , WeaponNum , TargetPosition , TargetNum , KillRange , SurviveThreshold , EnforceMatrix );
if FeasibleFlag == false
    Child2.Position = [];
end

end

