function [ ConvergenceMetric ] = ConvergenceMetricCalculate( Fitness, MinMaxSet, TargetValue )
%CONVERGENCEMETRICCALCULATE 此处显示有关此函数的摘要
%   此处显示详细说明

ConvergenceMetric = 0;
for i = 2 : 6
    if Fitness(i,1) ~= TargetValue
        ConvergenceMetric = ConvergenceMetric + (Fitness(i,1) - MinMaxSet(i,1))/(MinMaxSet(i,2)-MinMaxSet(i,1));
    else
        ConvergenceMetric = ConvergenceMetric + 1;
    end
end
ConvergenceMetric = ConvergenceMetric/5;

end

