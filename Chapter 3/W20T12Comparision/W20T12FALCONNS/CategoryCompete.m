function [ CategoryCompeteFitness ] = CategoryCompete( InputVector , Weight , ChoiceParameter )
%UNTITLED4 此处显示有关此函数的摘要
%   此处显示详细说明

CategoryCompeteFitness = norm( min( InputVector , Weight ) , 1 ) / ( ChoiceParameter + norm( Weight , 1 ) );             % F2层节点竞争选择指标

end

