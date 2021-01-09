function [ DominateLogic ] = DominateEstimate( i , j , FitMat )
%DOMINATES 此处显示有关此函数的摘要
%   此处显示详细说明

if all(FitMat(i,:) <= FitMat(j,:)) && any(FitMat(i,:) < FitMat(j,:))
    DominateLogic = true;
else
    DominateLogic = false;
end

end

