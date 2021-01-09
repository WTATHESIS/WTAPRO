function [ ResonanceFitness ] = ResonanceMatch( InputVector , Weight )
%UNTITLED5 此处显示有关此函数的摘要
%   此处显示详细说明

ResonanceFitness = norm( min( InputVector , Weight ),1 ) / norm( InputVector , 1 );                          % 判断是否发生谐振

end

