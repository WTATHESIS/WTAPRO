function [ CategoryCompeteFitness ] = CategoryCompete( InputVector , Weight , ChoiceParameter )
%UNTITLED4 �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��

CategoryCompeteFitness = norm( min( InputVector , Weight ) , 1 ) / ( ChoiceParameter + norm( Weight , 1 ) );             % F2��ڵ㾺��ѡ��ָ��

end

