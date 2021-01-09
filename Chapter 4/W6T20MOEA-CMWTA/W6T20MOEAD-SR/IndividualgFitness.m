function [ PopulationIndividualg ] = IndividualgFitness( SubProblemIndividualLambda , PopulationIndividualFitness , z )
%GFITNESS �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��

temp1 = abs( SubProblemIndividualLambda(1,1) .* (PopulationIndividualFitness(1,1)- z(1,1)) / (z(2,1) - z(1,1)) );
temp2 = abs( SubProblemIndividualLambda(1,2) .* (PopulationIndividualFitness(1,2)- z(1,2)) / (z(2,2) - z(1,2)) );

PopulationIndividualg = max( temp1,temp2 );

end

