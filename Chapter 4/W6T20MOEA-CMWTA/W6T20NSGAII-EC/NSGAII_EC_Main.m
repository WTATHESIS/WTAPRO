
%%  ս������
MaxScenario = 20;
WeaponNum = 6;
TargetNum = 20;
SafeNum = 2;
load TargetWeight.mat
load TargetPosition.mat
load SafePosition.mat
load SurviveThreshold.mat
load KillRange.mat
load EnforceMatrix.mat

%% �㷨����
PopSize = 1200;
MaxGeneration = 100;
MatingPoolSize = PopSize/2;
muc = 10;
mum = 10;

%NSGA2_EC_NumPer = zeros(6,100);

for ST = 1 : 30
    
    NSGA2_EC_FitnessRecord = sum(TargetWeight) .* ones(WeaponNum,MaxGeneration);
    NSGA2_EC_Constraint = inf(WeaponNum,MaxGeneration);
    epsilon = zeros(1,MaxGeneration);
    
    %% ��Ⱥ��ʼ��,������Ӧ�ȣ�����Լ��Υ���̶�
    [ Population ] = InitializePopulation( PopSize , WeaponNum , SafeNum , SafePosition , TargetNum , TargetPosition , TargetWeight , MaxScenario , KillRange , SurviveThreshold , EnforceMatrix );
    
    epsilon = EpsilonGenerate( Population, PopSize , epsilon , 1 );
    
    %% ����Population��Solution�ķֲ�ȼ���ӵ������?
    [ Population ] = DominateSort( Population , PopSize , epsilon , 1 );
    
    for i = 1 : MaxGeneration
        
        epsilon = EpsilonGenerate( Population, PopSize , epsilon , i );
        
        [ MatingPool ] = TournamentSelection( PopSize , Population , MatingPoolSize , 2 );
        
        [ InterPopSize , InterPopulation ] = InterPopulationGenerate( MatingPoolSize , MatingPool , PopSize , Population , muc , mum , WeaponNum , SafeNum , SafePosition , TargetNum , TargetPosition , TargetWeight , MaxScenario , KillRange , SurviveThreshold , EnforceMatrix );
        
        [ NextPopulation ] = NextPopulationGenerate( InterPopSize , InterPopulation , PopSize , WeaponNum , epsilon , i );
        
        NSGA2_EC_OptimalSolution = NextPopulation([NextPopulation.LevelRank]==1);
        [NSGA2_EC_OptimalSolution,NSGA2_EC_FitnessRecord,NSGA2_EC_Constraint] = NSGA2Output(NSGA2_EC_OptimalSolution,NSGA2_EC_FitnessRecord,NSGA2_EC_Constraint,i);
        
        Population = NextPopulation;
        
        fprintf('Time:%d  Generation:%d\n',ST,i);
        
    end
    
    %save NSGA2_EC_NumPer.mat NSGA2_EC_NumPer
    
    file_name1 = [ 'NSGA2_EC_FitnessRecord',  int2str(ST),  '.mat' ];
    value_name1 = [ 'NSGA2_EC_FitnessRecord' ];
    save( file_name1, value_name1);
    
    file_name2 = [ 'NSGA2_EC_OptimalSolution',  int2str(ST),  '.mat' ];
    value_name2 = [ 'NSGA2_EC_OptimalSolution' ];
    save( file_name2, value_name2);
    
    file_name3 = [ 'NSGA2_EC_Constraint',  int2str(ST),  '.mat' ];
    value_name3 = [ 'NSGA2_EC_Constraint' ];
    save( file_name3, value_name3);
    
end
