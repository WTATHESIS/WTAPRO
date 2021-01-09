function [ MatingPool ] = TournamentSelection(  PopSize , Population ,MatingPoolSize ,TournamentSize )
%TOURNAMENTSELECTION �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��

Individual.Position = zeros(6,2);
Individual.Fitness = zeros(1,2);
Individual.FitPen = zeros(1,2);
Individual.S = [];
Individual.R = [];
Individual.sigma = [];
Individual.sigmaK = [];
Individual.D = [];
Individual.F = [];
Individual.Constraint = 0;
Individual.subCon = zeros(1,3);
MatingPool = repmat(Individual,MatingPoolSize,1);

MatingPoolNum = 1;

SelectPool = [1:PopSize]';
SelectPoolNum = PopSize;
F = [Population.F]';

while MatingPoolNum <= MatingPoolSize
    
    %% ���ɽ�����Ⱥ��
    SelectedIndex = randperm(SelectPoolNum,TournamentSize)';
    
    %% �ų�������Ⱥ���з���С��֧���ĸ���
    SelectedF = F(SelectedIndex);
    MinF = min(SelectedF);
    SelectedIndex(SelectedF~=MinF) = [];
    
    %% �ų�������Ⱥ���з����ӵ������ĸ���,����MatingPool
    MatingPool(MatingPoolNum) = Population(SelectedIndex(1));
    SelectPoolNum = SelectPoolNum - 1;
    SelectPool(SelectedIndex(1)) = [];
    F(SelectedIndex(1)) = [];
    MatingPoolNum = MatingPoolNum + 1;
    
end

end

