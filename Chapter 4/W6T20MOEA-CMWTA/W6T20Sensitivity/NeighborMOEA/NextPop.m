function [ ElitePop , EliteNum ] = NextPop( ElitePop , EliteNum , PopSize , Neighbor , NeighborNum , muc , mum , WeaponNum , SafePosition , SafeNum , TargetPosition , TargetNum , TargetWeight , MaxScenario , KillRange , SurviveThreshold , EnforceMatrix)
%NEXTPOP 此处显示有关此函数的摘要
%   此处显示详细说明

IndividualCount = 0;

tally = 1;
while IndividualCount < PopSize
    
    if EliteNum(1,tally) ~= 0
        
        Paren1Index = randi([1,EliteNum(1,tally)]);
        Parent1 = ElitePop{Paren1Index,tally}.Position;
        
        if rand <= 0.8
            
            NeighborSet = [];
            NeighborSum = 0;
            for i = 1 : NeighborNum+1
                tempVar = Neighbor{tally}(1,i);
                tempVarNum = EliteNum(1,tempVar);
                NeighborSum = NeighborSum + tempVarNum;
                NeighborSet = [NeighborSet;ElitePop(1:tempVarNum,tempVar)];
            end
            
            Parent2Index = randi([1,NeighborSum]);
            Parent2 = NeighborSet{Parent2Index,1}.Position;
            
            %% 进化操作
            [ Child1 , Child2 ] = CrossoverOperator( Parent1 , Parent2 , muc ,WeaponNum , MaxScenario );
            
            %% 判定Child1可行性
            [ Child1 , FeasibleFlag ] = WeaponPositionFeasible( WeaponNum , Child1 , TargetNum , TargetPosition , KillRange , SurviveThreshold , EnforceMatrix );
            if FeasibleFlag == true
                
                [ Child1Fitness , Child1TargetSurvive ] = FitnessCompute( WeaponNum , Child1 , TargetNum , TargetPosition , TargetWeight , KillRange );
                Child1Constraint = ConstraintViolation( WeaponNum , Child1 , KillRange , SafeNum , SafePosition , TargetNum , TargetPosition , Child1TargetSurvive , SurviveThreshold , EnforceMatrix );
                
                IndividualCount = IndividualCount + 1;
                Child1UsedNum = Child1Fitness(1,2);
                
                EliteNum(1,Child1UsedNum) = EliteNum(1,Child1UsedNum) + 1;
                SubNum = EliteNum(1,Child1UsedNum);
                ElitePop{SubNum,Child1UsedNum}.Position = Child1;
                ElitePop{SubNum,Child1UsedNum}.Fitness = Child1Fitness;
                ElitePop{SubNum,Child1UsedNum}.Constraint = Child1Constraint;
                if IndividualCount == PopSize
                    break;
                end
            end
            
            %% 判定Child2可行性
            [ Child2 , FeasibleFlag ] = WeaponPositionFeasible( WeaponNum , Child2 , TargetNum , TargetPosition , KillRange , SurviveThreshold , EnforceMatrix );
            if FeasibleFlag == true
                
                [ Child2Fitness , Child2TargetSurvive ] = FitnessCompute( WeaponNum , Child2 , TargetNum , TargetPosition , TargetWeight , KillRange );
                Child2Constraint = ConstraintViolation( WeaponNum , Child2 , KillRange , SafeNum , SafePosition , TargetNum , TargetPosition , Child2TargetSurvive , SurviveThreshold , EnforceMatrix );
                
                IndividualCount = IndividualCount + 1;
                Child2UsedNum = Child2Fitness(1,2);
                
                EliteNum(1,Child2UsedNum) = EliteNum(1,Child2UsedNum) + 1;
                SubNum = EliteNum(1,Child2UsedNum);
                ElitePop{SubNum,Child2UsedNum}.Position = Child2;
                ElitePop{SubNum,Child2UsedNum}.Fitness = Child2Fitness;
                ElitePop{SubNum,Child2UsedNum}.Constraint = Child2Constraint;
                if IndividualCount == PopSize
                    break;
                end
            end
            
        else
            
            [ Parent1 ] = MutationOperator( Parent1 , mum ,WeaponNum , MaxScenario );
            [ Parent1 , FeasibleFlag ] = WeaponPositionFeasible( WeaponNum , Parent1 , TargetNum , TargetPosition , KillRange , SurviveThreshold , EnforceMatrix );
            if FeasibleFlag == true
                
                [ Parent1Fitness , Parent1TargetSurvive ] = FitnessCompute( WeaponNum , Parent1 , TargetNum , TargetPosition , TargetWeight , KillRange );
                Parent1Constraint = ConstraintViolation( WeaponNum , Parent1 , KillRange , SafeNum , SafePosition , TargetNum , TargetPosition , Parent1TargetSurvive , SurviveThreshold , EnforceMatrix );
                
                IndividualCount = IndividualCount + 1;
                Parent1UsedNum = Parent1Fitness(1,2);
                
                EliteNum(1,Parent1UsedNum) = EliteNum(1,Parent1UsedNum) + 1;
                SubNum = EliteNum(1,Parent1UsedNum);
                ElitePop{SubNum,Parent1UsedNum}.Position = Parent1;
                ElitePop{SubNum,Parent1UsedNum}.Fitness = Parent1Fitness;
                ElitePop{SubNum,Parent1UsedNum}.Constraint = Parent1Constraint;
                if IndividualCount == PopSize
                    break;
                end
            end
            
        end
        
    end
    
    if tally < WeaponNum
        tally = tally +1;
    else
        tally = 1;
    end
    
end

end


