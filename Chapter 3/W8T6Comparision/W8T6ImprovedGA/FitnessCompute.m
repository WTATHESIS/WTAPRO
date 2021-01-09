function [ ObjectiveFitness ] = FitnessCompute( DecisionVector , WeaponNum , TargetNum , TargetWeight , KillPro )
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

DecisionMatrix = DecisionVector2Matrix( DecisionVector , WeaponNum , TargetNum );
ObjectiveFitness = 0;
for i = 1 : TargetNum
    SingleTargetFitness = TargetWeight(1,i);
    for j = 1 : WeaponNum
        SingleTargetFitness = SingleTargetFitness * ( 1-KillPro(j,i) ) .^ DecisionMatrix(j,i) ;
    end
    ObjectiveFitness = ObjectiveFitness + SingleTargetFitness;
end

end

