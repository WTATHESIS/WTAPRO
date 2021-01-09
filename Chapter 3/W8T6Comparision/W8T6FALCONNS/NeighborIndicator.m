function [ NeighborFitness ] = NeighborIndicator( InputVector , Weight , ChoiceParameter )
%UNTITLED 此处显示有关此函数的摘要
%   此处显示详细说明
[ CategoryCompeteFitness ] = CategoryCompete( InputVector , Weight , ChoiceParameter );
[ ResonanceFitness ] = ResonanceMatch( InputVector , Weight );

%NeighborFitness = abs(CategoryCompeteFitness-ResonanceFitness)/CategoryCompeteFitness;
NeighborFitness = abs(CategoryCompeteFitness-ResonanceFitness);

end

