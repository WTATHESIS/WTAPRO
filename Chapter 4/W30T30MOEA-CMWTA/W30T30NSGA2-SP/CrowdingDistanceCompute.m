function [ Population ] = CrowdingDistanceCompute( Population , FrontIndex , ObjectiveNum )
%CROWDINGDISTANCECOMPUTE 此处显示有关此函数的摘要
%   此处显示详细说明

FrontVolumn = length(FrontIndex);

Fitness = reshape([Population(FrontIndex).FitPen],[2 FrontVolumn])';

for ObjectiveIndex = 1 : ObjectiveNum
    
    %% 按第ObjectiveIndex个目标函数对Front中的Solution升序排序
    [Fitness(:,ObjectiveIndex),I] = sort(Fitness(:,ObjectiveIndex));
    AscendIndex = FrontIndex(I);
     
    %% Front中第ObjectiveIndex个目标函数的最大最小值
    ObjectiveMin = Fitness(1,ObjectiveIndex);
    ObjectiveMax = Fitness(FrontVolumn,ObjectiveIndex);
    
    %% 给予边缘个体大数优势
    Population(AscendIndex(1,1)).CrowdingDistance = inf;
    Population(AscendIndex(FrontVolumn,1)).CrowdingDistance = inf;
    
    for i = 2 : FrontVolumn-1
        Population(AscendIndex(i,1)).CrowdingDistance = Population(AscendIndex(i,1)).CrowdingDistance + ( Population(AscendIndex(i+1,1)).FitPen(ObjectiveIndex) - Population(AscendIndex(i-1,1)).FitPen(ObjectiveIndex) ) / ( ObjectiveMax - ObjectiveMin );

    end
    
end

end

