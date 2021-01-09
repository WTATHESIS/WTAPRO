function [ DecisionMatrix ] = DecisionVector2Matrix( DecisionVector , WeaponNum , TargetNum )
%UNTITLED5 此处显示有关此函数的摘要
%   此处显示详细说明
%   函数功能：将决策向量转化为决策矩阵
%   输入：
%   DecisionVector：决策向量
%   WeaponNum：武器数量
%   TargetNum：目标数量
%   输出：
%   DecisionMatrix：决策矩阵

DecisionMatrix = zeros( WeaponNum , TargetNum );
for i = 1 : WeaponNum
        DecisionMatrix( i , DecisionVector(i) ) = 1; 
end

end

