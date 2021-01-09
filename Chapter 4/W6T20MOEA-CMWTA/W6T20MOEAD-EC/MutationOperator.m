function [ Child1 , Child2 ] = MutationOperator( WeaponNum , TargetPosition , TargetNum , KillRange , SurviveThreshold , EnforceMatrix , MaxScenario , Child1 , Child2 , mum )
%MUTATIONOPERATOR 此处显示有关此函数的摘要
%   此处显示详细说明
if rand < 0.2
    if ~isempty(Child1.Position)
        
        Parent1 = Child1.Position;
        
        IndexSeries = [1:6]';
        temp = sum(Parent1,2)~=0;
        IndexSeries = IndexSeries(temp);
        
        SeriesLength = length(IndexSeries);
        PositionSeed = randi([1,SeriesLength]);
        MutationPosition = IndexSeries(PositionSeed);
        
        mu = rand;
        if mu <= 0.5
            delta = (2*mu).^ (1/(mum+1)) -1;
        else
            delta = 1 - (2*(1-mu)).^(1/(mum+1));
        end
        Child1.Position(MutationPosition,:) = Parent1(MutationPosition,:) + MaxScenario/2 .* ones(1,2) .* delta;
        
        [ Child1.Position ] = MaxScenarioConstraint( Child1.Position, MaxScenario , WeaponNum );

        [ Child1.Position , FeasibleFlag ] = WeaponPositionFeasible( Child1.Position , WeaponNum , TargetPosition , TargetNum , KillRange , SurviveThreshold , EnforceMatrix );
        if FeasibleFlag == false
            Child1.Position = [];
        end
        
    end
end

if rand < 0.2
    if ~isempty(Child2.Position)
        
        Parent2 = Child2.Position;
        
        IndexSeries = [1:6]';
        temp = sum(Parent2,2)~=0;
        IndexSeries = IndexSeries(temp);
        
        SeriesLength = length(IndexSeries);
        PositionSeed = randi([1,SeriesLength]);
        MutationPosition = IndexSeries(PositionSeed);
        
        mu = rand;
        if mu <= 0.5
            delta = (2*mu).^ (1/(mum+1)) -1;
        else
            delta = 1 - (2*(1-mu)).^(1/(mum+1));
        end
        Child2.Position(MutationPosition,:) = Parent2(MutationPosition,:) + MaxScenario/2 .* ones(1,2) .* delta;
        
        [ Child2.Position ] = MaxScenarioConstraint( Child2.Position, MaxScenario , WeaponNum );

        [ Child2.Position , FeasibleFlag ] = WeaponPositionFeasible( Child2.Position , WeaponNum , TargetPosition , TargetNum , KillRange , SurviveThreshold , EnforceMatrix );
        if FeasibleFlag == false
            Child2.Position = [];
        end
        
    end
end

end

