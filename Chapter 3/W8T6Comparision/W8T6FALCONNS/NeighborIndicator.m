function [ NeighborFitness ] = NeighborIndicator( InputVector , Weight , ChoiceParameter )
%UNTITLED �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
[ CategoryCompeteFitness ] = CategoryCompete( InputVector , Weight , ChoiceParameter );
[ ResonanceFitness ] = ResonanceMatch( InputVector , Weight );

%NeighborFitness = abs(CategoryCompeteFitness-ResonanceFitness)/CategoryCompeteFitness;
NeighborFitness = abs(CategoryCompeteFitness-ResonanceFitness);

end

