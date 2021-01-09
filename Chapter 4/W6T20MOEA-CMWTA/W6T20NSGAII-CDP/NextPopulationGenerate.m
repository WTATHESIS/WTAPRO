function [ NextPopulation ] = NextPopulationGenerate( InterPopSize , InterPopulation , PopSize , WeaponNum )
%NEXTPOPULATIONGENERATE 此处显示有关此函数的摘要
%   此处显示详细说明

for j = 1 : InterPopSize
    InterPopulation(j).DominatedNum = 0;
    InterPopulation(j).DominateSet = zeros(1,InterPopSize);
    InterPopulation(j).DominateNum = 0;
    InterPopulation(j).LevelRank = 0;
    InterPopulation(j).CrowdingDistance = 0;
end

[ InterPopulation ] = DominateSort( InterPopulation , InterPopSize );

Individual.Position = zeros(WeaponNum,2);
Individual.Fitness = zeros(1,2);
Individual.DominatedNum = 0;
Individual.DominateSet = zeros(1,PopSize);
Individual.DominateNum = 0;
Individual.LevelRank = 0;
Individual.CrowdingDistance = 0;
Individual.Constraint = 0;
NextPopulation = repmat(Individual,PopSize,1);

MaxInterPopRank = max([InterPopulation.LevelRank]);
SolutionNum = 0;
for j = 1 : MaxInterPopRank
    Front = InterPopulation([InterPopulation.LevelRank]==j);
    FrontNum = numel(Front);
    if SolutionNum+FrontNum < PopSize
        NextPopulation(SolutionNum+1:SolutionNum+FrontNum) = Front;
        SolutionNum = SolutionNum+FrontNum;
    else
        for m = 1 : FrontNum-1
            for n = m+1 : FrontNum
                if Front(m).CrowdingDistance < Front(n).CrowdingDistance
                    tempVar = Front(n);
                    Front(n) = Front(m);
                    Front(m) = tempVar;
                end
            end
        end
        DV =  PopSize - SolutionNum;
        NextPopulation(SolutionNum+1:PopSize) = Front(1:DV);
        break;
    end
end

end

