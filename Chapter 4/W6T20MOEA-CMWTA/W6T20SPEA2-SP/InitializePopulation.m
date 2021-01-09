function [ Population ] = InitializePopulation( WeaponNum , KillRange , TargetNum , TargetPosition , SurviveThreshold , EnforceMatrix , MaxScenario , PopSize )
%INITIALIZEPOPULATION 此处显示有关此函数的摘要
%   此处显示详细说明

Individual.Position = zeros(WeaponNum,2);
Individual.Fitness = zeros(1,2);
Individual.FitPen = zeros(1,2);
Individual.S = [];
Individual.R = [];
Individual.sigma = [];
Individual.sigmaK = [];
Individual.D = [];
Individual.F = [];
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
    
    [ WeaponPosition , FeasibleFlag ] = WeaponPositionFeasible( WeaponPosition , WeaponNum , TargetPosition , TargetNum , KillRange , SurviveThreshold , EnforceMatrix );
    if FeasibleFlag == true
        Population(WeaponIndex).Position = WeaponPosition;
        WeaponIndex = WeaponIndex + 1;
    end
    
end

end

