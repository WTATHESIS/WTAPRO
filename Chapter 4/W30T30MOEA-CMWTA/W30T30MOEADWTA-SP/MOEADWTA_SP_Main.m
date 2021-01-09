
%%  ս������
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
    
    MOEADWTA_SP_FitnessRecord = sum(TargetWeight) .* ones(WeaponNum,MaxGeneration);
    MOEADWTA_SP_Constraint = inf(WeaponNum,100);
    
    %% ��Ⱥ��ʼ��,������Ӧ�ȣ�����Լ��Υ���̶�
    [ Pop,PopNum ] = PopInitial( PopSize , WeaponNum , SafePosition , SafeNum , TargetPosition , TargetWeight , TargetNum , MaxScenario , KillRange , SurviveThreshold , EnforceMatrix );
    
    for i = 1 : MaxGeneration
        
        [ ElitePop , EliteNum ] = EffectPopInitial( WeaponNum , Pop , PopSize , PopNum , EffectSize );
        
        fprintf('Time:%d  Generation:%d\n',ST,i);
        [ MOEADWTA_SP_OptimalSolution, MOEADWTA_SP_FitnessRecord, MOEADWTA_SP_Constraint ] = MOEAOutput( ElitePop(1,:) , WeaponNum , MOEADWTA_SP_FitnessRecord , MOEADWTA_SP_Constraint , i );
        
        if i == MaxGeneration
            break;
        end
        
        [ ElitePop , EliteNum ] = NextPop( ElitePop , EliteNum , PopSize , Neighbor , muc , mum , WeaponNum , SafePosition , SafeNum , TargetPosition , TargetNum , TargetWeight , MaxScenario , KillRange , SurviveThreshold , EnforceMatrix);
        
        Pop = ElitePop;
        PopNum = EliteNum;
        
    end
    
    file_name1 = [ 'MOEADWTA_SP_OptimalSolution',  int2str(ST),  '.mat' ];
    value_name1 = [ 'MOEADWTA_SP_OptimalSolution' ];
    save( file_name1, value_name1);
    
    file_name1 = [ 'MOEADWTA_SP_FitnessRecord',  int2str(ST),  '.mat' ];
    value_name1 = [ 'MOEADWTA_SP_FitnessRecord' ];
    save( file_name1, value_name1);
    
    file_name1 = [ 'MOEADWTA_SP_Constraint',  int2str(ST),  '.mat' ];
    value_name1 = [ 'MOEADWTA_SP_Constraint' ];
    save( file_name1, value_name1);
    
end


