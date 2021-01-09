
%%  战场环境
MaxScenario = 30;
WeaponNum = 30;
TargetNum = 30;
SafeNum = 3;
load TargetWeight.mat
load TargetPosition.mat
load SafePosition.mat
load SurviveThreshold.mat
load KillRange.mat;
load EnforceMatrix.mat

%% 算法参数
PopSize = 1200;
OffSpringSize = PopSize;
nArchive = 1200;
K=round(sqrt(PopSize+nArchive));  % KNN Parameter
MaxGeneration = 100;
MatingPoolSize = nArchive/2;
muc = 3;
mum = 3;

for ST = 1 : 30
    
    archive = [];
    SPEA2_SP_FitnessRecord = sum(TargetWeight) .* ones(WeaponNum,MaxGeneration);
    SPEA2_SP_Constraint = inf(WeaponNum,MaxGeneration);
    
    %% 种群初始化
    [ Population ] = InitializePopulation( WeaponNum , KillRange , TargetNum , TargetPosition , SurviveThreshold , EnforceMatrix , MaxScenario , PopSize );
    
    %% 计算适应度
    [ Population ] = FitnessCompute( WeaponNum ,  KillRange , SafeNum , SafePosition , TargetNum , TargetPosition , TargetWeight , SurviveThreshold , EnforceMatrix , PopSize , Population );
    
    for it = 1 : MaxGeneration
        
        fprintf('Time:%d  Generation:%d\n',ST,it);
        
        [archive] = NextArchiveGenerate(Population,archive,nArchive,K);
        
        [SPEA2_SP_OptimalSolution,SPEA2_SP_FitnessRecord,SPEA2_SP_Constraint] = SPEA2_SP_Output(archive,nArchive,SPEA2_SP_FitnessRecord,SPEA2_SP_Constraint,it);
        
        if it >= MaxGeneration
            break;
        end
        
        [ MatingPool ] = TournamentSelection( nArchive , archive , MatingPoolSize , 2 );
        
        [ OffSpring ] = GeneticOperator( PopSize , MatingPool , MatingPoolSize , WeaponNum , TargetPosition , TargetNum , KillRange , SurviveThreshold , EnforceMatrix , MaxScenario , muc , mum );
        
       [ OffSpring ] = FitnessCompute( WeaponNum ,  KillRange , SafeNum , SafePosition , TargetNum , TargetPosition , TargetWeight , SurviveThreshold , EnforceMatrix , OffSpringSize , OffSpring );
        
        Population = OffSpring;
        
    end
    
    file_name1 = [ 'SPEA2_SP_FitnessRecord',  int2str(ST),  '.mat' ];
    value_name1 = [ 'SPEA2_SP_FitnessRecord' ];
    save( file_name1, value_name1);
    
    file_name2 = [ 'SPEA2_SP_OptimalSolution',  int2str(ST),  '.mat' ];
    value_name2 = [ 'SPEA2_SP_OptimalSolution' ];
    save( file_name2, value_name2);
    
    file_name3 = [ 'SPEA2_SP_Constraint',  int2str(ST),  '.mat' ];
    value_name3 = [ 'SPEA2_SP_Constraint' ];
    save( file_name3, value_name3);
    
end