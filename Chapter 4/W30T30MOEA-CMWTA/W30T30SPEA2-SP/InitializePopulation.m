function [ Population ] = InitializePopulation( WeaponNum , KillRange , TargetNum , TargetPosition , SurviveThreshold , EnforceMatrix , MaxScenario , PopSize )
%INITIALIZEPOPULATION �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��

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

while (WeaponIndex <= PopSize)
    
    WeaponPosition = zeros(WeaponNum,2);
    UsedNum = randi([1,WeaponNum]);
    PositionSeed = randperm(WeaponNum,UsedNum);    
    for j= 1 : UsedNum
        k = PositionSeed(1,j);
        WeaponPosition(k,:) = MaxScenario * rand(1,2); 
    end
    
    [ WeaponPosition , FeasibleFlag ] = WeaponPositionFeasible( WeaponNum ,WeaponPosition , TargetNum ,  TargetPosition , KillRange , SurviveThreshold , EnforceMatrix );
    if FeasibleFlag == true
        Population(WeaponIndex).Position = WeaponPosition;
        WeaponIndex = WeaponIndex + 1;
    end
    
end

end

