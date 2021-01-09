function [ EP , Population , z ] = GeneticOperator( WeaponNum , KillRange , TargetNum , TargetPosition , TargetWeight , SurviveThreshold , EnforceMatrix , SafeNum , SafePosition , MaxScenario , EP , SubProblem , Population , PopSize , NeighborNum , z , muc , mum , pf )
%GENETICOPERATOR �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��

for i = 1 : PopSize
    
    [ Child1 , Child2 ] = CrossoverOperator( WeaponNum , KillRange , TargetNum , TargetPosition , SurviveThreshold , EnforceMatrix , MaxScenario, SubProblem , Population , muc , i );
    
    [ Child1 , Child2 ] = MutationOperator( WeaponNum , TargetPosition , TargetNum , KillRange , SurviveThreshold , EnforceMatrix , MaxScenario , Child1 , Child2 , mum );
    
    %% ����Child1����
    if ~isempty(Child1.Position)
        
        %% ����Child1��Ӧ��
        [ DecisionMatrix , KillPro ] = WTAMatrixGenerate( WeaponNum , Child1.Position , KillRange , TargetNum , TargetPosition );
        [ Child1.Fitness(1) , TargetSurvive ] = TargetKillProCompute( WeaponNum , TargetNum , TargetWeight , KillPro , DecisionMatrix );
        for j = 1 : WeaponNum
            if any(Child1.Position(j,:)~=0)
                Child1.Fitness(2) = Child1.Fitness(2) + 1;
            end
        end
        [ Child1.Constraint ] = ConstraintViolation( WeaponNum , Child1.Position , KillRange , SafeNum , SafePosition , TargetNum , TargetPosition , TargetSurvive , SurviveThreshold , EnforceMatrix );
        %Child1.Fitness(1) = Child1.Fitness(1) + Child1.Constraint;
        
        %% ����zֵ
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
    
    %% ����Child2����
    if ~isempty(Child2.Position)
        
        %% ����Child2��Ӧ��
        [ DecisionMatrix , KillPro ] = WTAMatrixGenerate( WeaponNum , Child2.Position , KillRange , TargetNum , TargetPosition );
        [ Child2.Fitness(1) , TargetSurvive ] = TargetKillProCompute( WeaponNum , TargetNum , TargetWeight , KillPro , DecisionMatrix );
        for j = 1 : WeaponNum
            if any(Child2.Position(j,:)~=0)
                Child2.Fitness(2) = Child2.Fitness(2) + 1;
            end
        end
        [ Child2.Constraint ] = ConstraintViolation( WeaponNum , Child2.Position , KillRange , SafeNum , SafePosition , TargetNum , TargetPosition , TargetSurvive , SurviveThreshold , EnforceMatrix );
        %Child2.Fitness(1) = Child2.Fitness(1) + Child2.Constraint;
        
        %% ����zֵ
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
    
    %%����B��i���ڵĸ���
    if ~isempty(Child1.Position)
        [ Child1.g ] = IndividualgFitness( SubProblem(i).Lambda , Child1.Fitness , z );
        if Child1.Constraint == 0 && Population(i).Constraint == 0
            if Child1.g <= Population(i).g
                Population(i) = Child1;
            end
        else
            if rand < pf
                if Child1.g <= Population(i).g
                    Population(i) = Child1;
                end
            else
                if Child1.Constraint < Population(i).Constraint
                    Population(i) = Child1;
                end
            end
        end
        for j = 1 : NeighborNum
            NeighborIndex = SubProblem(i).Neighbor(1,j);
            [ Child1.g ] = IndividualgFitness( SubProblem(NeighborIndex).Lambda , Child1.Fitness , z );
            if Child1.Constraint == 0 && Population(NeighborIndex).Constraint == 0
                if Child1.g <= Population(NeighborIndex).g
                    Population(NeighborIndex) = Child1;
                end
            else
                if rand < pf
                    if Child1.g <= Population(NeighborIndex).g
                        Population(NeighborIndex) = Child1;
                    end
                else
                    if Child1.Constraint < Population(NeighborIndex).Constraint
                        Population(NeighborIndex) = Child1;
                    end
                end
            end
        end
        [ EP ] = EPUpdate( EP , Child1 );
    end
    
    if ~isempty(Child2.Position)
        [ Child2.g ] = IndividualgFitness( SubProblem(i).Lambda , Child2.Fitness , z );
        if Child2.Constraint == 0 && Population(i).Constraint == 0
            if Child2.g <= Population(i).g
                Population(i) = Child2;
            end
        else
            if rand < pf
                if Child2.g <= Population(i).g
                    Population(i) = Child2;
                end
            else
                if Child2.Constraint < Population(i).Constraint
                    Population(i) = Child2;
                end
            end
        end
        for j = 1 : NeighborNum
            NeighborIndex = SubProblem(i).Neighbor(1,j);
            [ Child2.g ] = IndividualgFitness( SubProblem(NeighborIndex).Lambda , Child2.Fitness , z );
            if Child2.Constraint == 0 && Population(NeighborIndex).Constraint == 0
                if Child2.g <= Population(NeighborIndex).g
                    Population(NeighborIndex) = Child2;
                end
            else
                if rand < pf
                    if Child2.g <= Population(NeighborIndex).g
                        Population(NeighborIndex) = Child2;
                    end
                else
                    if Child2.Constraint < Population(NeighborIndex).Constraint
                        Population(NeighborIndex) = Child2;
                    end
                end
            end
        end
        [ EP ] = EPUpdate( EP , Child2 );
    end
    
end

