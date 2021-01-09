function [ r ] = RangeSort( r , TargetNum )
%UNTITLED2 此处显示有关此函数的摘要
%   此处显示详细说明
% 输入：TargetWeight：目标权值向量（未排序）
%       KillPro：目标杀伤概率（未排序）
%       TargetNum：目标数量
% 输出：TargetWeight：目标权值向量（升序）
%       KillPro：目标上上概率（对应升序后的目标权值）
for i = 1 : TargetNum-1
    for j = 1 : TargetNum-i
        if r(j) > r(j+1)
            tempr = r(j);
            r(j) = r(j+1);
            r(j+1) = tempr;
        end
    end
end

end

