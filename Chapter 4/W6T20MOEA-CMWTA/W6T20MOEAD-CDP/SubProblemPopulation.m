function [ Population ] = SubProblemPopulation( SubProblem , Population , PopSize , z )
%SUBPROBLEMPOPULATION 此处显示有关此函数的摘要
%   此处显示详细说明

tempPop = Population;
jNum = PopSize;
for i = 1 : PopSize
    
    temp3 = zeros(jNum,1);
    j = 1;
    for j = 1 : jNum
        [ temp3(j,1) ] = IndividualgFitness( SubProblem(i).Lambda , tempPop(j).Fitness , z );
%         temp1 = abs( SubProblem(i).Lambda(1,1) .* (tempPop(j).Fitness(1,1)- z(1,1)) / (z(2,1) - z(1,1)) );
%         temp2 = abs( SubProblem(i).Lambda(1,2) .* (tempPop(j).Fitness(1,2)- z(1,2)) / (z(2,2) - z(1,2)) );
%         temp3(j,1) = max( temp1,temp2 );
    end
    [ MinValue , MinIndex ] = min(temp3);
    Population(i) = tempPop(MinIndex);
    Population(i).g = MinValue;
    tempPop(MinIndex) = [];
    jNum = jNum - 1;

end

end

