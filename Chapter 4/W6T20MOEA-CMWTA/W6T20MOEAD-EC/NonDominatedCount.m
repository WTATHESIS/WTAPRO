function [ Population , EP ] = NonDominatedCount( Population , PopSize , epsilon , GenCount )
%NONDOMINATED 此处显示有关此函数的摘要
%   此处显示详细说明

FitMat = reshape([Population.Fitness],[2 PopSize])';
ConMat = [Population.Constraint]';

ConMat = ConMat - epsilon(1,GenCount);
ConMat(ConMat<0) = 0;

IsDominated = [Population.IsDominated]';

for i = 1 : PopSize-1
    for j = i+1 : PopSize

        if ConMat(i,1) == ConMat(j,1)
            if all(FitMat(i,:) <= FitMat(j,:)) && any(FitMat(i,:) < FitMat(j,:))
                IsDominated(j) = 1;
            end
            if all(FitMat(i,:) >= FitMat(j,:)) && any(FitMat(i,:) > FitMat(j,:))
                IsDominated(i) = 1;
            end
        end

        if ConMat(i,1) < ConMat(j,1)
            IsDominated(j) = 1;
        end
        
        if ConMat(i,1) > ConMat(j,1)
            IsDominated(i) = 1;
        end
        
    end
end

for i = 1 : PopSize
    Population(i).IsDominated = IsDominated(i);
end

EP = Population( [Population.IsDominated] == 0 );

end

