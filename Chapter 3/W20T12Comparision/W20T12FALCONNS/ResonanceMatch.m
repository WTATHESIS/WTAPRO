function [ ResonanceFitness ] = ResonanceMatch( InputVector , Weight )
%UNTITLED5 �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��

ResonanceFitness = norm( min( InputVector , Weight ),1 ) / norm( InputVector , 1 );                          % �ж��Ƿ���г��

end

