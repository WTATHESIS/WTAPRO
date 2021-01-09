function [ MatingPool ] = TournamentSelection(  PopSize , Population ,MatingPoolSize ,TournamentSize )
%TOURNAMENTSELECTION 此处显示有关此函数的摘要
%   此处显示详细说明

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
    
    %% 生成锦标赛群体
    SelectedIndex = randperm(SelectPoolNum,TournamentSize)';
    
    %% 排除锦标赛群体中非最小层支配层的个体
    SelectedF = F(SelectedIndex);
    MinF = min(SelectedF);
    SelectedIndex(SelectedF~=MinF) = [];
    
    %% 排除锦标赛群体中非最大拥挤距离的个体,加入MatingPool
    MatingPool(MatingPoolNum) = Population(SelectedIndex(1));
    SelectPoolNum = SelectPoolNum - 1;
    SelectPool(SelectedIndex(1)) = [];
    F(SelectedIndex(1)) = [];
    MatingPoolNum = MatingPoolNum + 1;
    
end

end

