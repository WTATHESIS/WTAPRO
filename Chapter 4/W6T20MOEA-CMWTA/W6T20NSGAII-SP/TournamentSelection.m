function [ MatingPool ] = TournamentSelection(  PopSize , Population ,MatingPoolSize ,TournamentSize )
%TOURNAMENTSELECTION �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��

Individual.Position = zeros(6,2);
Individual.Fitness = zeros(1,2);
Individual.FitPen = zeros(1,2);
Individual.DominatedNum = 0;
Individual.DominateSet = [];
Individual.DominateNum = [];
Individual.LevelRank = 0;
Individual.CrowdingDistance = 0;
Individual.Constraint = 0;
Individual.subCon = zeros(1,3);
MatingPool = repmat(Individual,MatingPoolSize,1);

MatingPoolNum = 0;
SelectPool = [1:PopSize]';
SelectPoolNum = PopSize;
LevelRank = [Population.LevelRank]';
CrowdingDistance = [Population.CrowdingDistance]';

while MatingPoolNum < MatingPoolSize
    
    %% ���ɽ�����Ⱥ��
    SelectedIndex = randperm(SelectPoolNum,TournamentSize)';
    
    %% �ų�������Ⱥ���з���С��֧���ĸ���
    SelectedLevel = LevelRank(SelectedIndex);
    MinLevelRank = min(SelectedLevel);
    SelectedIndex(SelectedLevel~=MinLevelRank) = [];
    
    %% �ų�������Ⱥ���з����ӵ������ĸ���,����MatingPool
    if length(SelectedIndex) == 1
        MatingPoolNum = MatingPoolNum + 1;
        MatingPool(MatingPoolNum) = Population(SelectedIndex);
        SelectPoolNum = SelectPoolNum - 1;
        SelectPool(SelectedIndex) = [];
        LevelRank(SelectedIndex) = [];
        CrowdingDistance(SelectedIndex) = [];
    else
        SelectedDis = CrowdingDistance(SelectedIndex);
        SelectedMaxDistance = max(SelectedDis);
        SelectedIndex(SelectedDis~=SelectedMaxDistance) = [];
        
        MatingPoolNum = MatingPoolNum + 1;
        MatingPool(MatingPoolNum) = Population(SelectedIndex(1));
        SelectPoolNum = SelectPoolNum - 1;
        SelectPool(SelectedIndex(1)) = [];
        LevelRank(SelectedIndex(1)) = [];
        CrowdingDistance(SelectedIndex(1)) = [];
    end
    
end

end

