function [ Pop,PopNum ] = PopInitial( PopSize , WeaponNum , SafePosition , SafeNum , TargetPosition , TargetWeight , TargetNum , MaxScenario , KillRange , SurviveThreshold , EnforceMatrix )
%INITIALIZEPOPULATION 此处显示有关此函数的摘要
%   此处显示详细说明

Pop = cell(PopSize,WeaponNum);
PopNum = zeros(1,WeaponNum);

WeaponIndex = 0;

while (WeaponIndex < PopSize)
    
    WeaponPosition = zeros(WeaponNum,2);
    UsedNum = randi([1,WeaponNum]);
    PositionSeed = randperm(WeaponNum,UsedNum);
    for j= 1 : UsedNum
        k = PositionSeed(1,j);
        WeaponPosition(k,:) = MaxScenario * rand(1,2);
    end
    
    [ WeaponPosition , FeasibleFlag ] = WeaponPositionFeasible( WeaponNum , WeaponPosition , TargetNum , TargetPosition , KillRange , SurviveThreshold , EnforceMatrix );
    if FeasibleFlag == true
        [ Fitness , TargetSurvive ] = FitnessCompute( WeaponNum , WeaponPosition , TargetNum , TargetPosition , TargetWeight , KillRange );
        Constraint = ConstraintViolation( WeaponNum , WeaponPosition , KillRange , SafeNum , SafePosition , TargetNum , TargetPosition , TargetSurvive , SurviveThreshold , EnforceMatrix );     
        
        UsedNum = Fitness(1,2);
        PopNum(1,UsedNum) = PopNum(1,UsedNum)+1;
        SubNum = PopNum(1,UsedNum);
        
        Pop{SubNum,UsedNum}.Position = WeaponPosition;
        Pop{SubNum,UsedNum}.Fitness = Fitness;
        Pop{SubNum,UsedNum}.Constraint = Constraint;
        
        WeaponIndex = WeaponIndex + 1;
    end
    
end

end

