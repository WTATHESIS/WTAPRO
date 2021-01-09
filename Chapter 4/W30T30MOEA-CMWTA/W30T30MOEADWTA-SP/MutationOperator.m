function [ Child ] = MutationOperator( Child , mum ,WeaponNum , MaxScenario )
%MUTATIONOPERATOR 此处显示有关此函数的摘要
%   此处显示详细说明

Parent = Child;

IndexSeries = [];
for j = 1 : WeaponNum
    if any(Parent(j,:)~=0)
        IndexSeries = [ IndexSeries , j ];
    end
end
temp1 = size(IndexSeries);
SeriesLength = temp1(1,2);
PositionSeed = randi([1,SeriesLength]);
MutationPosition = IndexSeries(1,PositionSeed);

mu = rand;
if mu <= 0.5
    delta = (2*mu).^ (1/(mum+1)) -1;
else
    delta = 1 - (2*(1-mu)).^(1/(mum+1));
end
Child(MutationPosition,:) = Parent(MutationPosition,:) + MaxScenario .* ones(1,2) .* delta;

[ Child ] = MaxScenarioConstraint( Child , MaxScenario , WeaponNum );

end

