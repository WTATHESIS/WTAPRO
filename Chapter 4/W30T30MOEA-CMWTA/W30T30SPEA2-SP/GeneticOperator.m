function [ OffSpring ] = GeneticOperator( PopSize , MatingPool , MatingPoolSize , WeaponNum , TargetPosition , TargetNum , KillRange , SurviveThreshold , EnforceMatrix , MaxScenario , muc , mum )
%GENETICOPERATOR 此处显示有关此函数的摘要
%   此处显示详细说明

Individual.Position = zeros(6,2);
Individual.Fitness = zeros(1,2);
Individual.FitPen = zeros(1,2);
Individual.S = [];
Individual.R = [];
Individual.sigma = [];
Individual.sigmaK = [];
Individual.D = [];
Individual.F = [];
Individual.Constraint = 0;
Individual.subCon = 0;
OffSpring = repmat(Individual,PopSize,1);
OffSpringSize = 0;

%for i = 1 : MatingPoolSize
while OffSpringSize < PopSize
    
    if rand < 0.8
        %% 模拟二进制交叉算子
        Child1 = zeros(WeaponNum,2);
        Child2 = zeros(WeaponNum,2);
        
        ParentIndex = randperm(MatingPoolSize,2);
        
        Parent1 = MatingPool(ParentIndex(1)).Position;
        Parent2 = MatingPool(ParentIndex(2)).Position;
        
        for j = 1 : WeaponNum
            if all(Parent1(j,:)==0) && any(Parent2(j,:)~=0)
                Child1(j,:) = Parent2(j,:);
                Child2(j,:) = Parent1(j,:);
            elseif any(Parent1(j,:)~=0) && all(Parent2(j,:)==0)
                Child1(j,:) = Parent2(j,:);
                Child2(j,:) = Parent1(j,:);
            elseif all(Parent1(j,:)==0) && all(Parent2(j,:)==0)
                Child1(j,:) = 0;
                Child2(j,:) = 0;
            else
                mu = rand;
                if mu <= 0.5
                    gamma = (2*mu).^(1/(muc+1));
                else
                    gamma = (1/2/(1-mu)).^(1/(muc+1));
                end
                Child1(j,:) = 0.5*( (1+gamma)*Parent1(j,:) + (1-gamma)*Parent2(j,:) );
                Child2(j,:) = 0.5*( (1-gamma)*Parent1(j,:) + (1+gamma)*Parent2(j,:) );
            end
        end
        
        [ Child1 ] = MaxScenarioConstraint( Child1, MaxScenario , WeaponNum );
        [ Child2 ] = MaxScenarioConstraint( Child2, MaxScenario , WeaponNum );
        
        [ Child1 , FeasibleFlag ] = WeaponPositionFeasible(WeaponNum , Child1 ,TargetNum ,  TargetPosition ,  KillRange , SurviveThreshold , EnforceMatrix );
        if FeasibleFlag == true
            
            OffSpring(OffSpringSize+1,1).Position = Child1;
            OffSpring(OffSpringSize+1,1).Fitness = zeros(1,2);
            OffSpring(OffSpringSize+1,1).FitPen = zeros(1,2);
            OffSpring(OffSpringSize+1,1).S = [];
            OffSpring(OffSpringSize+1,1).R = [];
            OffSpring(OffSpringSize+1,1).sigma = [];
            OffSpring(OffSpringSize+1,1).sigmaK = [];
            OffSpring(OffSpringSize+1,1).D = [];
            OffSpring(OffSpringSize+1,1).F = [];
            OffSpring(OffSpringSize+1,1).Constraint = 0;
            OffSpring(OffSpringSize+1,1).subCon = zeros(1,3);
            OffSpringSize = OffSpringSize + 1;
            
        end
        
        if OffSpringSize == PopSize
            break;
        end
        
        [ Child2 , FeasibleFlag ] = WeaponPositionFeasible(WeaponNum , Child2 ,  TargetNum , TargetPosition , KillRange , SurviveThreshold , EnforceMatrix );
        if FeasibleFlag == true
            
            OffSpring(OffSpringSize+1,1).Position = Child2;
            OffSpring(OffSpringSize+1,1).Fitness = zeros(1,2);
            OffSpring(OffSpringSize+1,1).FitPen = zeros(1,2);
            OffSpring(OffSpringSize+1,1).S = [];
            OffSpring(OffSpringSize+1,1).R = [];
            OffSpring(OffSpringSize+1,1).sigma = [];
            OffSpring(OffSpringSize+1,1).sigmaK = [];
            OffSpring(OffSpringSize+1,1).D = [];
            OffSpring(OffSpringSize+1,1).F = [];
            OffSpring(OffSpringSize+1,1).Constraint = 0;
            OffSpring(OffSpringSize+1,1).subCon = zeros(1,3);
            OffSpringSize = OffSpringSize + 1;
            
        end
        
        if OffSpringSize == PopSize
            break;
        end
        
    else
        
        MutationIndex = randi(MatingPoolSize);
        Parent3 = MatingPool(MutationIndex).Position;
        Child3 = Parent3;
        
        IndexSeries = [1:WeaponNum]';
        temp = sum(Parent3,2)~=0;
        IndexSeries = IndexSeries(temp);
        
        SeriesLength = length(IndexSeries);
        PositionSeed = randi([1,SeriesLength]);
        MutationPosition = IndexSeries(PositionSeed);
        
        mu = rand;
        if mu <= 0.5
            delta = (2*mu).^ (1/(mum+1)) -1;
        else
            delta = 1 - (2*(1-mu)).^(1/(mum+1));
        end
        Child3(MutationPosition,:) = Parent3(MutationPosition,:) + MaxScenario .* ones(1,2) .* delta;
        [ Child3 ] = MaxScenarioConstraint( Child3 , MaxScenario , WeaponNum );      
        
        [ Child3 , FeasibleFlag ] = WeaponPositionFeasible(WeaponNum , Child3 ,TargetNum ,  TargetPosition ,  KillRange , SurviveThreshold , EnforceMatrix );
        if FeasibleFlag == true
            
            OffSpring(OffSpringSize+1,1).Position = Child3;
            OffSpring(OffSpringSize+1,1).Fitness = zeros(1,2);
            OffSpring(OffSpringSize+1,1).FitPen = zeros(1,2);
            OffSpring(OffSpringSize+1,1).S = [];
            OffSpring(OffSpringSize+1,1).R = [];
            OffSpring(OffSpringSize+1,1).sigma = [];
            OffSpring(OffSpringSize+1,1).sigmaK = [];
            OffSpring(OffSpringSize+1,1).D = [];
            OffSpring(OffSpringSize+1,1).F = [];
            OffSpring(OffSpringSize+1,1).Constraint = 0;
            OffSpring(OffSpringSize+1,1).subCon = zeros(1,3);
            OffSpringSize = OffSpringSize + 1;
            
        end
        
        if OffSpringSize == PopSize
            break;
        end
        
    end
    
end

end

