function [ Fitness , TargetSurvive ] = TargetKillProCompute( WeaponNum , TargetNum , TargetWeight , KillPro , DecisionMatrix )
%UNTITLED2 此处显示有关此函数的摘要
%   此处显示详细说明
%   函数功能：计算某个决策下WTA问题的目标函数值
%   输入：
%   DecisionMatrix：决策矩阵
%   WeaponNum: 武器数
%   TargetNum：目标数
%   TargetWeight：目标权值
%   KillPro：杀伤概率矩阵
%   输出：
%   ObjectiveFitness：目标函数值
TargetSurvive = ones(1,TargetNum);
Fitness = 0;
for i = 1 : TargetNum
    SingleTargetFitness = TargetWeight(1,i);
    for j = 1 : WeaponNum
        SingleTargetFitness = SingleTargetFitness * ( 1-KillPro(j,i) ) .^ DecisionMatrix(j,i) ;
    end
    TargetSurvive(1,i) = SingleTargetFitness / TargetWeight(1,i);
    Fitness = Fitness + SingleTargetFitness;
end

end

