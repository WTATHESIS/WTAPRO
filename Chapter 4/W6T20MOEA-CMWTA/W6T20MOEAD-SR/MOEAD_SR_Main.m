
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
pf = 0.45;

for ST = 1 : 30
    
    MOEAD_SR_FitnessRecord = sum(TargetWeight) .* ones(WeaponNum,MaxGeneration);
    MOEAD_SR_Constraint = inf(WeaponNum,MaxGeneration);
    
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
    
    %% EP
    [ Population , MOEAD_SR_OptimalSolution ] = NonDominatedCount( Population , PopSize , pf );
    
    for i = 1 : MaxGeneration
        
        fprintf('Time:%d  Generation:%d\n',ST,i);
        
        %epsilon = EpsilonGenerate( Population, PopSize , epsilon , i );
        
        [ MOEAD_SR_OptimalSolution , Population , z ] = GeneticOperator( WeaponNum , KillRange , TargetNum , TargetPosition , TargetWeight , SurviveThreshold , EnforceMatrix , SafeNum , SafePosition , MaxScenario , MOEAD_SR_OptimalSolution , SubProblem , Population , PopSize , NeighborNum , z , muc , mum , pf );
        
        OptimalSolutionNum = numel(MOEAD_SR_OptimalSolution);
        for j = 1 : OptimalSolutionNum
            MOEAD_SR_FitnessRecord(MOEAD_SR_OptimalSolution(j).Fitness(1,2),i) = MOEAD_SR_OptimalSolution(j).Fitness(1,1);
            MOEAD_SR_Constraint(MOEAD_SR_OptimalSolution(j).Fitness(1,2),i) = MOEAD_SR_OptimalSolution(j).Constraint;
        end
        
    end
    
    file_name1 = [ 'MOEAD_SR_FitnessRecord',  int2str(ST),  '.mat' ];
    value_name1 = [ 'MOEAD_SR_FitnessRecord' ];
    save( file_name1, value_name1);
    
    file_name2 = [ 'MOEAD_SR_OptimalSolution',  int2str(ST),  '.mat' ];
    value_name2 = [ 'MOEAD_SR_OptimalSolution' ];
    save( file_name2, value_name2);
    
    file_name3 = [ 'MOEAD_SR_Constraint',  int2str(ST),  '.mat' ];
    value_name3 = [ 'MOEAD_SR_Constraint' ];
    save( file_name3, value_name3);
    
end
