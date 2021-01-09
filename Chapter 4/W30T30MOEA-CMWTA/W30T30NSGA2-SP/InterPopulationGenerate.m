function [ InterPopSize , InterPopulation ] = InterPopulationGenerate( MatingPoolSize , MatingPool , PopSize , Population , muc , mum , WeaponNum , SafeNum , SafePosition , TargetNum , TargetPosition , TargetWeight , MaxScenario , KillRange , SurviveThreshold , EnforceMatrix )
%INTERPOPULATIONGENERATE 此处显示有关此函数的摘要
%   此处显示详细说明

InterPopulation = Population;
InterPopSize = PopSize;

%for i = 1 : MatingPoolSize
while 1
    
    if rand < 0.8
        
        %% 交叉操作
        [ Child1 , Child2 ] = CrossoverOperator( MatingPoolSize , MatingPool , muc , WeaponNum , MaxScenario );
        
        %% 判定Child1可行性
        [ Child1 , FeasibleFlag ] = WeaponPositionFeasible( WeaponNum , Child1 , TargetNum , TargetPosition , KillRange , SurviveThreshold , EnforceMatrix );
        if FeasibleFlag == true
            [ Child1Fitness , Child1TargetSurvive ] = FitnessCompute( WeaponNum , Child1 , TargetNum , TargetPosition , TargetWeight , KillRange );
            
            InterPopSize = InterPopSize + 1;
            InterPopulation(InterPopSize).Position = Child1;
            InterPopulation(InterPopSize).Fitness = Child1Fitness;
            [ InterPopulation(InterPopSize).subCon ] = ConstraintViolation( WeaponNum , Child1 , KillRange , SafeNum , SafePosition , TargetNum , TargetPosition , Child1TargetSurvive , SurviveThreshold , EnforceMatrix );;
            InterPopulation(InterPopSize).Constraint = sum(InterPopulation(InterPopSize).subCon);
            
            if InterPopSize == 2 * PopSize
                break;
            end
        end
        
        %% 判断Child2是否已存在
        [ Child2 , FeasibleFlag ] = WeaponPositionFeasible( WeaponNum , Child2 , TargetNum , TargetPosition , KillRange , SurviveThreshold , EnforceMatrix );
        if FeasibleFlag == true
            [ Child2Fitness , Child2TargetSurvive ] = FitnessCompute( WeaponNum , Child2 , TargetNum , TargetPosition , TargetWeight , KillRange );
            
            InterPopSize = InterPopSize + 1;
            InterPopulation(InterPopSize).Position = Child2;
            InterPopulation(InterPopSize).Fitness = Child2Fitness;
            [ InterPopulation(InterPopSize).subCon ] = ConstraintViolation( WeaponNum , Child2 , KillRange , SafeNum , SafePosition , TargetNum , TargetPosition , Child2TargetSurvive , SurviveThreshold , EnforceMatrix );
            InterPopulation(InterPopSize).Constraint = sum(InterPopulation(InterPopSize).subCon);
            
            if InterPopSize == 2 * PopSize
                break;
            end
        end
        
    else
        
        %% 变异操作
        [ Child3 ] = MutationOperator( MatingPoolSize , MatingPool , mum ,WeaponNum , MaxScenario );
        
        %% 判断Child3是否已存在
        [ Child3 , FeasibleFlag ] = WeaponPositionFeasible( WeaponNum , Child3 , TargetNum , TargetPosition , KillRange , SurviveThreshold , EnforceMatrix );
        if FeasibleFlag == true
            [ Child3Fitness , Child3TargetSurvive ] = FitnessCompute( WeaponNum , Child3 , TargetNum , TargetPosition , TargetWeight , KillRange );
            
            InterPopSize = InterPopSize + 1;
            InterPopulation(InterPopSize).Position = Child3;
            InterPopulation(InterPopSize).Fitness = Child3Fitness;
            [ InterPopulation(InterPopSize).subCon ] = ConstraintViolation( WeaponNum , Child3 , KillRange , SafeNum , SafePosition , TargetNum , TargetPosition , Child3TargetSurvive , SurviveThreshold , EnforceMatrix );;
            InterPopulation(InterPopSize).Constraint = sum(InterPopulation(InterPopSize).subCon);
            
            if InterPopSize == 2 * PopSize
                break;
            end
        end
        
    end
    
end

end

