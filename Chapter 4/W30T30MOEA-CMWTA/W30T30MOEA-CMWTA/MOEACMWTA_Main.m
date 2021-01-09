
%%  战场环境
MaxScenario = 30;
WeaponNum = 30;
TargetNum = 30;
SafeNum = 3;
load TargetWeight.mat
load TargetPosition.mat
load SafePosition.mat
load SurviveThreshold.mat
load KillRange.mat
load EnforceMatrix.mat

%% 算法参数
PopSize = 1200;
MaxGeneration = 100;
EffectSize = PopSize/2;
muc = 3;
mum = 3;
FitnessRecord = cell(MaxGeneration,WeaponNum);

%% 邻居索引
[ Neighbor ] = NeighborIndex( WeaponNum );

for ST = 1 : 30
    
    MOEAFitnessRecord = sum(TargetWeight) .* ones(WeaponNum,MaxGeneration);
    MOEAConstraint = inf(WeaponNum,100);
    
    %% 种群初始化,计算适应度，计算约束违反程度
    [ Pop,PopNum ] = PopInitial( PopSize , WeaponNum , SafePosition , SafeNum , TargetPosition , TargetWeight , TargetNum , MaxScenario , KillRange , SurviveThreshold , EnforceMatrix );
    
    for i = 1 : MaxGeneration
        
        [ ElitePop , EliteNum ] = EffectPopInitial( WeaponNum , Pop , PopSize , PopNum , EffectSize );
        
        fprintf('Time:%d  Generation:%d\n',ST,i);
        [ MOEAOptimalSolution, MOEAFitnessRecord, MOEAConstraint ] = MOEAOutput( ElitePop(1,:) , WeaponNum , MOEAFitnessRecord , MOEAConstraint , i );
        
        if i == MaxGeneration
            break;
        end
        
        [ ElitePop , EliteNum ] = NextPop( ElitePop , EliteNum , PopSize , Neighbor , muc , mum , WeaponNum , SafePosition , SafeNum , TargetPosition , TargetNum , TargetWeight , MaxScenario , KillRange , SurviveThreshold , EnforceMatrix);
        
        Pop = ElitePop;
        PopNum = EliteNum;
        
    end
    
    file_name1 = [ 'MOEAOptimalSolution',  int2str(ST),  '.mat' ];
    value_name1 = [ 'MOEAOptimalSolution' ];
    save( file_name1, value_name1);
    
    file_name1 = [ 'MOEAFitnessRecord',  int2str(ST),  '.mat' ];
    value_name1 = [ 'MOEAFitnessRecord' ];
    save( file_name1, value_name1);
    
    file_name1 = [ 'MOEAConstraint',  int2str(ST),  '.mat' ];
    value_name1 = [ 'MOEAConstraint' ];
    save( file_name1, value_name1);
    
end


