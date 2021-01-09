function [ InterPopSize , InterPopulation ] = InterPopulationGenerate( MatingPoolSize , MatingPool , PopSize , Population , muc , mum , WeaponNum , SafeNum , SafePosition , TargetNum , TargetPosition , TargetWeight , MaxScenario , KillRange , SurviveThreshold , EnforceMatrix )
%INTERPOPULATIONGENERATE �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��

InterPopulation = Population;
InterPopSize = PopSize;

%for i = 1 : MatingPoolSize
while 1
    
    if rand < 0.8
        
        %% �������
        [ Child1 , Child2 ] = CrossoverOperator( MatingPoolSize , MatingPool , muc , WeaponNum , MaxScenario );
        
        %% �ж�Child1������
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
        
        %% �ж�Child2�Ƿ��Ѵ���
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
        
        %% �������
        [ Child3 ] = MutationOperator( MatingPoolSize , MatingPool , mum ,WeaponNum , MaxScenario );
        
        %% �ж�Child3�Ƿ��Ѵ���
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

