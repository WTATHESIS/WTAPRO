function [ PopSet ] = PopInitialize( PopSize , WeaponNum , TargetNum )
%UNTITLED4 此处显示有关此函数的摘要
%   此处显示详细说明
%   函数功能：种群初始化
%   输出：
%   PopSize：种群大小
%   WeaponNum：武器数量
%   TargetNum：目标数量
%   输出：
%   PopSet：种群集合

PopSet = zeros( PopSize , WeaponNum );
for i =1 : PopSize
    for j = 1 : WeaponNum
        PopSet( i , j ) = randi( TargetNum );
    end
end

end

