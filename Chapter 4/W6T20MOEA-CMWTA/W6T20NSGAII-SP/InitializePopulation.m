function [ Population ] = InitializePopulation( PopSize , WeaponNum , SafeNum , SafePosition , TargetNum , TargetPosition , TargetWeight , MaxScenario , KillRange , SurviveThreshold , EnforceMatrix )
%INITIALIZEPOPULATION 此处显示有关此函数的摘要
%   此处显示详细说明

Individual.Position = zeros(WeaponNum,2);
Individual.Fitness = zeros(1,2);
Individual.FitPen = zeros(1,2);
Individual.DominatedNum = 0;
Individual.DominateSet = zeros(1,PopSize);
Individual.DominateNum = 0;
Individual.LevelRank = 0;
Individual.CrowdingDistance = 0;
Individual.Constraint = 0;
Individual.subCon = zeros(1,3);
Population = repmat(Individual,PopSize,1);

WeaponIndex = 1;
[ EnforceWeaponIndex , EnforceTargetIndex ] = find(EnforceMatrix==1);
while (WeaponIndex <= PopSize)
    
    WeaponPosition = zeros(6,2);
    UsedNum = randi([1,WeaponNum]);
    PositionSeed = randperm(WeaponNum,UsedNum);
    for j= 1 : UsedNum
        k = PositionSeed(1,j);
        if k == EnforceWeaponIndex
            AngleSeed = 2*pi*rand;
            DisSeed = KillRange(1,k).*rand;
            WeaponPosition(k,1) = TargetPosition(EnforceTargetIndex,1) + DisSeed .* cos(AngleSeed);
            WeaponPosition(k,2) = TargetPosition(EnforceTargetIndex,2) + DisSeed .* sin(AngleSeed);
        else
            WeaponPosition(k,:) = MaxScenario * rand(1,2);
        end
        
    end
    
    [ WeaponPosition , FeasibleFlag ] = WeaponPositionFeasible( WeaponNum , WeaponPosition , TargetNum , TargetPosition , KillRange , SurviveThreshold , EnforceMatrix );
    if FeasibleFlag == true
        [ Fitness , TargetSurvive ] = FitnessCompute( WeaponNum , WeaponPosition , TargetNum , TargetPosition , TargetWeight , KillRange );
        Population(WeaponIndex).Position = WeaponPosition;
        Population(WeaponIndex).Fitness = Fitness;
        [ Population(WeaponIndex).subCon ] = ConstraintViolation( WeaponNum , Population(WeaponIndex).Position , KillRange , SafeNum , SafePosition , TargetNum , TargetPosition , TargetSurvive , SurviveThreshold , EnforceMatrix );
        Population(WeaponIndex).Constraint = sum(Population(WeaponIndex).subCon);
        WeaponIndex = WeaponIndex + 1;
    end
    
end

end

