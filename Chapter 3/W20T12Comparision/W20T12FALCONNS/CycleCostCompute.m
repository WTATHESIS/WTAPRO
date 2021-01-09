function [ CostofCycle ] = CycleCostCompute( PathLabel , PathLabelofTree , PathLength , KillPro , SingleTargetFitness )
%CYCLECOST �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��

CostofCycle = 0;

for i =  1 : PathLength-1
    SurvivePro1 = 1 - KillPro( PathLabel(1,i) , PathLabelofTree(1,i+1) );
    SurvivePro2 = 1 - KillPro( PathLabel(1,i+1) , PathLabelofTree(1,i+1) );
    ArcCost = SingleTargetFitness(1,PathLabelofTree(1,i+1)) * ( SurvivePro1 / SurvivePro2 - 1 ); 
    CostofCycle = CostofCycle + ArcCost;
end

SurvivePro3 = 1 - KillPro( PathLabel(1,PathLength) , PathLabelofTree(1,1) );
SurvivePro4 = 1 - KillPro( PathLabel(1,1) , PathLabelofTree(1,1) );
ArcCost = SingleTargetFitness(1,PathLabelofTree(1,1)) * ( SurvivePro3 / SurvivePro4 - 1 );
CostofCycle = CostofCycle + ArcCost;

end

