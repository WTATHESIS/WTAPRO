
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
ObjectNum = 2;
PopSize = 1200;
NeighborNum = 20;
MaxGeneration = 100;
muc = 10;
mum = 10;

for ST = 1 : 30
    
    MOEAD_EC_FitnessRecord = sum(TargetWeight) .* ones(WeaponNum,MaxGeneration);
    MOEAD_EC_Constraint = inf(WeaponNum,MaxGeneration);
    epsilon = zeros(1,MaxGeneration);
    
    %% ���������ⷽ����ھ�?
    SubProblem = SubProblemCreate( PopSize , NeighborNum );     % ��ʼ��lambda���ھ�����
    
    %% ��Ⱥ��ʼ��
    [ Population ] = InitializePopulation( WeaponNum , KillRange , TargetNum , TargetPosition , SurviveThreshold , EnforceMatrix , MaxScenario , PopSize );
    
    %% ������Ӧ��
    [ Population ] = FitnessCompute( WeaponNum ,  KillRange , SafeNum , SafePosition , TargetNum , TargetPosition , TargetWeight , SurviveThreshold , EnforceMatrix , PopSize , Population );
    
    %% ���������?
    [ z ] = PerferencePoint( ObjectNum , Population , PopSize );
    
    %% Ϊÿ������������ʼ��
    [ Population ] = SubProblemPopulation( SubProblem , Population , PopSize , z );
    
%     %% �������?gֵ
%     for i = 1 : PopSize
%         [ Population(i).g ] = IndividualgFitness( SubProblem(i).Lambda , Population(i).Fitness , z );
%     end
    
    %% EP
    epsilon = EpsilonGenerate( Population, PopSize , epsilon , 1 );
    [ Population , MOEAD_EC_OptimalSolution ] = NonDominatedCount( Population , PopSize , epsilon , 1);
    
    for i = 1 : MaxGeneration
        
        fprintf('Time:%d  Generation:%d\n',ST,i);
        
        epsilon = EpsilonGenerate( Population, PopSize , epsilon , i );
        
        [ MOEAD_EC_OptimalSolution , Population , z ] = GeneticOperator( WeaponNum , KillRange , TargetNum , TargetPosition , TargetWeight , SurviveThreshold , EnforceMatrix , SafeNum , SafePosition , MaxScenario , MOEAD_EC_OptimalSolution , SubProblem , Population , PopSize , NeighborNum , z , muc , mum , epsilon , i );
        
        [MOEAD_EC_OptimalSolution,MOEAD_EC_FitnessRecord,MOEAD_EC_Constraint] = MOEADOutput(MOEAD_EC_OptimalSolution,MOEAD_EC_FitnessRecord,MOEAD_EC_Constraint,i);
        
    end
    
    file_name1 = [ 'MOEAD_EC_FitnessRecord',  int2str(ST),  '.mat' ];
    value_name1 = [ 'MOEAD_EC_FitnessRecord' ];
    save( file_name1, value_name1);
    
    file_name2 = [ 'MOEAD_EC_OptimalSolution',  int2str(ST),  '.mat' ];
    value_name2 = [ 'MOEAD_EC_OptimalSolution' ];
    save( file_name2, value_name2);
    
    file_name3 = [ 'MOEAD_EC_Constraint',  int2str(ST),  '.mat' ];
    value_name3 = [ 'MOEAD_EC_Constraint' ];
    save( file_name3, value_name3);
    
end
