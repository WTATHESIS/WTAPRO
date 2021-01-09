function [ Population ] = CrowdingDistanceCompute( Population , FrontIndex , ObjectiveNum )
%CROWDINGDISTANCECOMPUTE �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��

FrontVolumn = length(FrontIndex);

Fitness = reshape([Population(FrontIndex).FitPen],[2 FrontVolumn])';

for ObjectiveIndex = 1 : ObjectiveNum
    
    %% ����ObjectiveIndex��Ŀ�꺯����Front�е�Solution��������
    [Fitness(:,ObjectiveIndex),I] = sort(Fitness(:,ObjectiveIndex));
    AscendIndex = FrontIndex(I);
     
    %% Front�е�ObjectiveIndex��Ŀ�꺯���������Сֵ
    ObjectiveMin = Fitness(1,ObjectiveIndex);
    ObjectiveMax = Fitness(FrontVolumn,ObjectiveIndex);
    
    %% �����Ե�����������
    Population(AscendIndex(1,1)).CrowdingDistance = inf;
    Population(AscendIndex(FrontVolumn,1)).CrowdingDistance = inf;
    
    for i = 2 : FrontVolumn-1
        Population(AscendIndex(i,1)).CrowdingDistance = Population(AscendIndex(i,1)).CrowdingDistance + ( Population(AscendIndex(i+1,1)).FitPen(ObjectiveIndex) - Population(AscendIndex(i-1,1)).FitPen(ObjectiveIndex) ) / ( ObjectiveMax - ObjectiveMin );

    end
    
end

end

