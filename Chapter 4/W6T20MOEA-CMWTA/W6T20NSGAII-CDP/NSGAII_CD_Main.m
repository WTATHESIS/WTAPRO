
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

%NSGA2_CD_NumPer = zeros(6,100);

for ST = 1 : 30
    
    NSGA2_CD_FitnessRecord = sum(TargetWeight) .* ones(WeaponNum,MaxGeneration);
    NSGA2_CD_Constraint = inf(WeaponNum,MaxGeneration);
    
    %% ��Ⱥ��ʼ��,������Ӧ�ȣ�����Լ��Υ���̶�
    [ Population ] = InitializePopulation( PopSize , WeaponNum , SafeNum , SafePosition , TargetNum , TargetPosition , TargetWeight , MaxScenario , KillRange , SurviveThreshold , EnforceMatrix );
    
    %% ����Population��Solution�ķֲ�ȼ���ӵ������?
    [ Population ] = DominateSort( Population , PopSize );
    
    for i = 1 : MaxGeneration
        
        [ MatingPool ] = TournamentSelection( PopSize , Population , MatingPoolSize , 2 );
        
        [ InterPopSize , InterPopulation ] = InterPopulationGenerate( MatingPoolSize , MatingPool , PopSize , Population , muc , mum , WeaponNum , SafeNum , SafePosition , TargetNum , TargetPosition , TargetWeight , MaxScenario , KillRange , SurviveThreshold , EnforceMatrix );
        
        [ NextPopulation ] = NextPopulationGenerate( InterPopSize , InterPopulation , PopSize , WeaponNum );
        
        NSGA2_CD_OptimalSolution = NextPopulation([NextPopulation.LevelRank]==1);
        [NSGA2_CD_OptimalSolution,NSGA2_CD_FitnessRecord,NSGA2_CD_Constraint] = NSGA2Output(NSGA2_CD_OptimalSolution,NSGA2_CD_FitnessRecord,NSGA2_CD_Constraint,i);
        
        Population = NextPopulation;
        
        fprintf('Time:%d  Generation:%d\n',ST,i);
        
    end
    
    %save NSGA2_CD_NumPer.mat NSGA2_CD_NumPer
    
    file_name1 = [ 'NSGA2_CD_FitnessRecord',  int2str(ST),  '.mat' ];
    value_name1 = [ 'NSGA2_CD_FitnessRecord' ];
    save( file_name1, value_name1);
    
    file_name2 = [ 'NSGA2_CD_OptimalSolution',  int2str(ST),  '.mat' ];
    value_name2 = [ 'NSGA2_CD_OptimalSolution' ];
    save( file_name2, value_name2);
    
    file_name3 = [ 'NSGA2_CD_Constraint',  int2str(ST),  '.mat' ];
    value_name3 = [ 'NSGA2_CD_Constraint' ];
    save( file_name3, value_name3);
    
end
