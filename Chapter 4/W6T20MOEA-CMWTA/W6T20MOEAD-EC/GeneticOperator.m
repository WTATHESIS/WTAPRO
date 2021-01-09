function [ EP , Population , z ] = GeneticOperator( WeaponNum , KillRange , TargetNum , TargetPosition , TargetWeight , SurviveThreshold , EnforceMatrix , SafeNum , SafePosition , MaxScenario , EP , SubProblem , Population , PopSize , NeighborNum , z , muc , mum, epsilon , GenCount )
%GENETICOPERATOR 此处显示有关此函数的摘要
%   此处显示详细说明

for i = 1 : PopSize
    
    [ Child1 , Child2 ] = CrossoverOperator( WeaponNum , KillRange , TargetNum , TargetPosition , SurviveThreshold , EnforceMatrix , MaxScenario , SubProblem , Population , muc , i );
    
    [ Child1 , Child2 ] = MutationOperator( WeaponNum , TargetPosition , TargetNum , KillRange , SurviveThreshold , EnforceMatrix , MaxScenario , Child1 , Child2 , mum );
    
    %% 安排Child1表现
    if ~isempty(Child1.Position)
        
        %% 计算Child1适应度
        [ DecisionMatrix , KillPro ] = WTAMatrixGenerate( WeaponNum , Child1.Position , KillRange , TargetNum , TargetPosition );
        [ Child1.Fitness(1) , TargetSurvive ] = TargetKillProCompute( WeaponNum , TargetNum , TargetWeight , KillPro , DecisionMatrix );
        for j = 1 : WeaponNum
            if any(Child1.Position(j,:)~=0)
                Child1.Fitness(2) = Child1.Fitness(2) + 1;
            end
        end
        [ Child1.Constraint ] = ConstraintViolation( WeaponNum , Child1.Position , KillRange , SafeNum , SafePosition , TargetNum , TargetPosition , TargetSurvive , SurviveThreshold , EnforceMatrix );
        %Child1.Fitness(1) = Child1.Fitness(1) + Child1.Constraint;
        
        %% 更新z值
        if Child1.Fitness(1) < z(1,1)
            z(1,1) = Child1.Fitness(1);
        end
        if Child1.Fitness(1) > z(2,1)
            z(2,1) = Child1.Fitness(1);
        end
        if Child1.Fitness(2) < z(1,2)
            z(1,2) = Child1.Fitness(2);
        end
        if Child1.Fitness(2) > z(2,2)
            z(2,2) = Child1.Fitness(2);
        end
        
    end
    
    %% 安排Child2表现
    if ~isempty(Child2.Position)
        
        %% 计算Child2适应度
        [ DecisionMatrix , KillPro ] = WTAMatrixGenerate( WeaponNum , Child2.Position , KillRange , TargetNum , TargetPosition );
        [ Child2.Fitness(1) , TargetSurvive ] = TargetKillProCompute( WeaponNum , TargetNum , TargetWeight , KillPro , DecisionMatrix );
        for j = 1 : WeaponNum
            if any(Child2.Position(j,:)~=0)
                Child2.Fitness(2) = Child2.Fitness(2) + 1;
            end
        end
        [ Child2.Constraint ] = ConstraintViolation( WeaponNum , Child2.Position , KillRange , SafeNum , SafePosition , TargetNum , TargetPosition , TargetSurvive , SurviveThreshold , EnforceMatrix );
        %Child2.Fitness(1) = Child2.Fitness(1) + Child2.Constraint;
        
        %% 更新z值
        if Child2.Fitness(1) < z(1,1)
            z(1,1) = Child2.Fitness(1);
        end
        if Child2.Fitness(1) > z(2,1)
            z(2,1) = Child2.Fitness(1);
        end
        if Child2.Fitness(2) < z(1,2)
            z(1,2) = Child2.Fitness(2);
        end
        if Child2.Fitness(2) > z(2,2)
            z(2,2) = Child2.Fitness(2);
        end
        
    end
    
    %%更新B（i）内的个体
    if ~isempty(Child1.Position)
        [ Child1.g ] = IndividualgFitness( SubProblem(i).Lambda , Child1.Fitness , z );
        if Child1.Constraint <= epsilon(GenCount) && Population(i).Constraint <= epsilon(GenCount)
            if Child1.g <= Population(i).g
                Population(i) = Child1;
            end
        elseif Child1.Constraint == Population(i).Constraint
            if Child1.g <= Population(i).g
                Population(i) = Child1;
            end
        elseif Child1.Constraint < Population(i).Constraint
            Population(i) = Child1;
        end
        for j = 1 : NeighborNum
            NeighborIndex = SubProblem(i).Neighbor(1,j);
            [ Child1.g ] = IndividualgFitness( SubProblem(NeighborIndex).Lambda , Child1.Fitness , z );
            if Child1.Constraint <= epsilon(GenCount) && Population(NeighborIndex).Constraint <= epsilon(GenCount)
                if Child1.g <= Population(NeighborIndex).g
                    Population(NeighborIndex) = Child1;
                end
            elseif Child1.Constraint == Population(NeighborIndex).Constraint
                if Child1.g <= Population(NeighborIndex).g
                    Population(NeighborIndex) = Child1;
                end
            elseif Child1.Constraint < Population(NeighborIndex).Constraint
                Population(NeighborIndex) = Child1;
            end
        end
        [ EP ] = EPUpdate( EP , Child1 , epsilon , GenCount );
    end
    
    if ~isempty(Child2.Position)
        [ Child2.g ] = IndividualgFitness( SubProblem(i).Lambda , Child2.Fitness , z );
        if Child2.Constraint <= epsilon(GenCount) && Population(i).Constraint <= epsilon(GenCount)
            if Child2.g <= Population(i).g
                Population(i) = Child2;
            end
        elseif Child2.Constraint == Population(i).Constraint
            if Child2.g <= Population(i).g
                Population(i) = Child2;
            end
        elseif Child2.Constraint < Population(i).Constraint
            Population(i) = Child2;
        end
        for j = 1 : NeighborNum
            NeighborIndex = SubProblem(i).Neighbor(1,j);
            [ Child2.g ] = IndividualgFitness( SubProblem(NeighborIndex).Lambda , Child2.Fitness , z );
            if Child2.Constraint <= epsilon(GenCount) && Population(NeighborIndex).Constraint <= epsilon(GenCount)
                if Child2.g <= Population(NeighborIndex).g
                    Population(NeighborIndex) = Child2;
                end
            elseif Child2.Constraint == Population(NeighborIndex).Constraint
                if Child2.g <= Population(NeighborIndex).g
                    Population(NeighborIndex) = Child2;
                end
            elseif Child2.Constraint < Population(NeighborIndex).Constraint
                Population(NeighborIndex) = Child2;
            end
        end
        [ EP ] = EPUpdate( EP , Child2 , epsilon , GenCount );
    end
    
end

end

