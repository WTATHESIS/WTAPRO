function [ Population , EP ] = NonDominatedCount( Population , PopSize , pf )
%NONDOMINATED 此处显示有关此函数的摘要
%   此处显示详细说明

FitMat = reshape([Population.Fitness],[2 PopSize])';
ConMat = [Population.Constraint]';

IsDominated = [Population.IsDominated]';

for i = 1 : PopSize-1
    for j = i+1 : PopSize
        
        if ConMat(i)==0 && ConMat(j)==0
            if all(FitMat(i,:) <= FitMat(j,:)) && any(FitMat(i,:) < FitMat(j,:))
                IsDominated(j) = 1;
            end
            if all(FitMat(i,:) >= FitMat(j,:)) && any(FitMat(i,:) > FitMat(j,:))
                IsDominated(i) = 1;
            end
        else
            if rand < pf
                if all(FitMat(i,:) <= FitMat(j,:)) && any(FitMat(i,:) < FitMat(j,:))
                    IsDominated(j) = 1;
                end
                if all(FitMat(i,:) >= FitMat(j,:)) && any(FitMat(i,:) > FitMat(j,:))
                    IsDominated(i) = 1;
                end
            else
                if ConMat(i,1) < ConMat(j,1)
                    IsDominated(j) = 1;
                end                
                if ConMat(i,1) > ConMat(j,1)
                    IsDominated(i) = 1;
                end
            end         
        end
        
    end
end

for i = 1 : PopSize
    Population(i).IsDominated = IsDominated(i);
end

EP = Population( [Population.IsDominated] == 0 );

end

