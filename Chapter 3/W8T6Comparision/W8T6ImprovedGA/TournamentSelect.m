function [ SelectIndividual ] = TournamentSelect( PopSet , PopFitness , PopSize , WeaponNum )
%UNTITLED �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��

SelectSize = 0.6 * PopSize;
SelectPopSet = zeros(SelectSize,WeaponNum);
SelectPopFitness = zeros(SelectSize,1);
for i = 1 : SelectSize
    SelectOperator = randi(PopSize);
    SelectPopSet(i,:) = PopSet(SelectOperator,:);
    SelectPopFitness(i,1) = PopFitness(SelectOperator,1);
end

[ ~ , SelectIndividualIndex ] = min( SelectPopFitness(:,1) );

SelectIndividual = SelectPopSet(SelectIndividualIndex,:);

end

