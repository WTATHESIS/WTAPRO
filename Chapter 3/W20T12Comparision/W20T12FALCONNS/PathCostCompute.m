function [ CostofPath ] = PathCostCompute( PathLabel , PathLabelofTree , PathLength , KillPro , SingleTargetFitness )
%PATHCOST �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��

CostofPath = 0;

for i =  1 : PathLength-1
    SurvivePro1 = 1 - KillPro( PathLabel(1,i) , PathLabelofTree(1,i+1) );
    SurvivePro2 = 1 - KillPro( PathLabel(1,i+1) , PathLabelofTree(1,i+1) );
    ArcCost = SingleTargetFitness(1,PathLabelofTree(1,i+1)) * ( SurvivePro1 / SurvivePro2 - 1 );
    CostofPath = CostofPath + ArcCost;
end

end

