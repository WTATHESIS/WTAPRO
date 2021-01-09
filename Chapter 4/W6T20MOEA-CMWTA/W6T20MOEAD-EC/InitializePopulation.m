function [ Population ] = InitializePopulation( WeaponNum , KillRange , TargetNum , TargetPosition , SurviveThreshold , EnforceMatrix , MaxScenario , PopSize )
%INITIALIZEPOPULATION 此处显示有关此函数的摘要
%   此处显示详细说明

Individual.Position = zeros(WeaponNum,2);
Individual.Fitness = zeros(1,2);
Individual.g = 0;
Individual.IsDominated = 0;
Individual.Constraint = 0;
Population = repmat(Individual,PopSize,1);

WeaponIndex = 1;
[ EnforceWeaponIndex , EnforceTargetIndex ] = find(EnforceMatrix==1);
while (WeaponIndex <= PopSize)
    
    UsedNum = randi([1,WeaponNum]);
    PositionSeed = randperm(WeaponNum,UsedNum);
    for j = 1 : UsedNum
        k = PositionSeed(1,j);
        if k == EnforceWeaponIndex
            AngleSeed = 2*pi*rand;
            DisSeed = KillRange(1,k).*rand;
            Population(WeaponIndex).Position(k,1) = TargetPosition(EnforceTargetIndex,1) + DisSeed .* cos(AngleSeed);
            Population(WeaponIndex).Position(k,2) = TargetPosition(EnforceTargetIndex,2) + DisSeed .* sin(AngleSeed);
        else
            Population(WeaponIndex).Position(k,:) = MaxScenario * rand(1,2);
        end
    end
    
    [ Population(WeaponIndex).Position , FeasibleFlag ] = WeaponPositionFeasible( Population(WeaponIndex).Position , WeaponNum , TargetPosition , TargetNum , KillRange , SurviveThreshold , EnforceMatrix );
    if FeasibleFlag == true
        WeaponIndex = WeaponIndex + 1;
    end
    
end

end

