
%%  战场环境
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

%% 算法参数
PopSize = 1200;
MaxGeneration = 100;
rsep = [0.1:0.1:1];
muc = 5;
mum = 2;
SizeFitnessRecord = cell(MaxGeneration,WeaponNum);

%% 邻居索引
[ Neighbor ] = NeighborIndex( WeaponNum );

for DS = 1 : 10
    
    EffectSize = PopSize * rsep(DS);
    DS
    
    for ST = 1 : 30
        
        %% 种群初始化,计算适应度，计算约束违反程度
        [ Pop,PopNum ] = PopInitial( PopSize , WeaponNum , SafePosition , SafeNum , TargetPosition , TargetWeight , TargetNum , MaxScenario , KillRange , SurviveThreshold , EnforceMatrix );
        
        for i = 1 : MaxGeneration
            
            [ ElitePop , EliteNum ] = EffectPopInitial( WeaponNum , Pop , PopSize , PopNum , EffectSize );
            
            %fprintf('Time:%d  Generation:%d\n',ST,i);
            SizeFitnessRecord(i,:) = ElitePop(1,:);
            
            if i == MaxGeneration
                break;
            end
            
            [ ElitePop , EliteNum ] = NextPop( ElitePop , EliteNum , PopSize , Neighbor , muc , mum , WeaponNum , SafePosition , SafeNum , TargetPosition , TargetNum , TargetWeight , MaxScenario , KillRange , SurviveThreshold , EnforceMatrix);
            
            Pop = ElitePop;
            PopNum = EliteNum;
            
        end
        
        file_name1 = [ 'SizeFitnessRecord', int2str(DS), int2str(ST),  '.mat' ];
        value_name1 = [ 'SizeFitnessRecord' ];
        save( file_name1, value_name1);
        
    end
    
end
