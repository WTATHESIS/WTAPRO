
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
EffectSize = PopSize/2;
muc = 10;
mum = 10;
FitnessRecord = cell(MaxGeneration,WeaponNum);

%% �ھ�����
[ Neighbor ] = NeighborIndex( WeaponNum );

for ST = 1 : 30
    
    MOEAFitnessRecord = sum(TargetWeight) .* ones(WeaponNum,MaxGeneration);
    MOEAConstraint = inf(6,100);
    
    %% ��Ⱥ��ʼ��,������Ӧ�ȣ�����Լ��Υ���̶�
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


