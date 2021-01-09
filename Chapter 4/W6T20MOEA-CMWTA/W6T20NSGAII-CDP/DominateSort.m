function [Population] = DominateSort(Population,PopSize)
%NEWDOMINATESORT 此处显示有关此函数的摘要
%   此处显示详细说明

FitMat = reshape([Population.Fitness],[2 PopSize])';
ConMat = [Population.Constraint]';

DominateNum = zeros(PopSize,1);
DominateSet = zeros(PopSize);
DominatedNum = zeros(PopSize,1);
LevelRank = zeros(PopSize,1);

for i = 1 : PopSize-1
    for j = i+1 : PopSize
        
        if ConMat(i,1) == ConMat(j,1)
            if all(FitMat(i,:) <= FitMat(j,:)) && any(FitMat(i,:) < FitMat(j,:))
                DominateNum(i,1) = DominateNum(i,1) + 1;
                DominateSet(i,DominateNum(i,1)) = j;
                DominatedNum(j,1) = DominatedNum(j,1) + 1;
            end
            if all(FitMat(i,:) >= FitMat(j,:)) && any(FitMat(i,:) > FitMat(j,:))
                DominateNum(j,1) = DominateNum(j,1) + 1;
                DominateSet(j,DominateNum(j,1)) = i;
                DominatedNum(i,1) = DominatedNum(i,1) + 1;
            end
        end
        
        if ConMat(i,1) < ConMat(j,1)
            DominateNum(i,1) = DominateNum(i,1) + 1;
            DominateSet(i,DominateNum(i,1)) = j;
            DominatedNum(j,1) = DominatedNum(j,1) + 1;
        end
        
        if ConMat(i,1) > ConMat(j,1)
            DominateNum(j,1) = DominateNum(j,1) + 1;
            DominateSet(j,DominateNum(j,1)) = i;
            DominatedNum(i,1) = DominatedNum(i,1) + 1;
        end
        
    end
end

for i = 1 : PopSize
    Population(i).DominateNum = DominateNum(i,1);
    if DominateNum(i,1) ~= 0
        Population(i).DominateSet = DominateSet(i,1:DominateNum(i,1));
    end
    Population(i).DominatedNum = DominatedNum(i,1);
    if DominatedNum(i,1) == 0
        LevelRank(i,1) = 1;
        Population(i).LevelRank = 1;
    end
end

PreFrontIndex = find(LevelRank==1);

LevelCount = 1;
while any(DominatedNum~=0)
    
    PreFrontNum = length(PreFrontIndex);
    for i = 1 : PreFrontNum
        FrontSolIndex = PreFrontIndex(i,1);
        FrontSolDominateNum = DominateNum(FrontSolIndex,1);
        for j = 1 : FrontSolDominateNum
            DominatedIndex = DominateSet(FrontSolIndex,j);
            DominatedNum(DominatedIndex,1) = DominatedNum(DominatedIndex,1) - 1;
            if DominatedNum(DominatedIndex,1) == 0
                LevelRank(DominatedIndex,1) = LevelCount + 1;
                Population(DominatedIndex).LevelRank = LevelCount + 1;
            end
        end
    end
    PreFrontIndex = find(LevelRank==LevelCount + 1);
    LevelCount = LevelCount + 1;
    
end

MaxLevelRank = max(LevelRank);
for i = 1 : MaxLevelRank
    
    FrontIndex = find(LevelRank==i);
    [ Population ] = CrowdingDistanceCompute( Population , FrontIndex , 2 );
    
end

end

