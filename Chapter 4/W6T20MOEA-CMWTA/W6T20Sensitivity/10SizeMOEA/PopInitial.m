function [ Pop,PopNum ] = PopInitial( PopSize , WeaponNum , SafePosition , SafeNum , TargetPosition , TargetWeight , TargetNum , MaxScenario , KillRange , SurviveThreshold , EnforceMatrix )
%INITIALIZEPOPULATION �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��

Pop = cell(PopSize,WeaponNum);
PopNum = zeros(1,WeaponNum);

WeaponIndex = 0;
[ EnforceWeaponIndex , EnforceTargetIndex ] = find(EnforceMatrix==1);
while (WeaponIndex < PopSize)
    
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

