
clear all

%%%%% ��������������������
load TrainDataInput.mat
load TrainDataOutput.mat
load rSim.mat

TrainDataSize = size( TrainDataInput );     % �������뼯�ϵ�ά��
TrainDataNum = TrainDataSize(1,1);      % ��ȡ��������

WeaponNum = 8;     % ��������
TargetNum = 6;      % Ŀ������
MaxKillPro = [ 0.75 ; 0.78 ; 0.81 ; 0.84 ; 0.87 ; 0.9 ; 0.93 ; 0.96 ];        % ÿ�����������ɱ�˸���
MaxKillRange = [ 48000 ; 46000 ; 44000; 42000 ; 40000 ; 38000 ; 36000 ; 34000 ];     % ÿ�����������ɱ�˾���
BellWidth = [ 20000 ; 20000 ; 20000 ; 20000 ; 20000 ; 20000 ; 20000 ; 20000 ];       % Bell Width
RMax = 62000;       % ս������������
RMin = 30000;       % ս��������С����
ChoiceParameter = 0.00001;        % ѡ�����
ResonanceThreshold = 0.98;      % г������ֵ������������ֵ
PathLength = 4;

%%%%% ������ָ��
rSimSize = size(rSim);
SimTimes = rSimSize(1);     % �������
ARTFitness = zeros( 1 , SimTimes );
ARTTime = zeros(1,SimTimes);
ARTNSFitness = zeros( 1 , SimTimes );   % ���߽�Ŀ�꺯����Ӧ��
ARTNSTime = zeros(1,SimTimes);

for ST = 1 : SimTimes      % �������
    
    r = rSim(ST,:);     % ����Ŀ���������������������
    [ r ] = RangeSort( r , TargetNum );     % �����밴��Ŀ��Ȩֵ��������
    
    CategoryCompeteFitness = zeros(1,TrainDataNum);     % F2���нڵ㾺����Ӧ������
    DecisionVector = zeros(1,WeaponNum);     % �����������Ŀ������������
    
    [ TargetWeight, KillPro ] = WTAIntialization( MaxKillPro, MaxKillRange, BellWidth, RMax, r, TargetNum, WeaponNum );     % ����Ŀ��Ȩֵ������ɱ�˸��ʾ���
    
    %%%%% �������תΪ��������
    temp1 = [ TargetWeight ; KillPro ]';
    temp2 = temp1(:);
    InputVector = temp2';
    
    tic;
    %%%%% ����F2���еĽڵ㾺����Ӧ��
    for i = 1 : TrainDataNum
        [ CategoryCompeteFitness( 1 , i ) ] = CategoryCompete( InputVector , TrainDataInput(i,:) , ChoiceParameter );     % F2��ڵ㾺����Ӧ��
    end
    
    for i = 1 : TrainDataNum
        [ CategoryCompeteMax , CategoryCompeteMaxIndex ] = max( CategoryCompeteFitness );   % �õ�������ʤ��Ԫ
        [ ResonanceFitness ] = ResonanceMatch( InputVector , TrainDataInput(CategoryCompeteMaxIndex,:) );   % ����г����Ӧ��
        if ResonanceFitness >= ResonanceThreshold
            DecisionVector = TrainDataOutput( CategoryCompeteMaxIndex , : );    % ���ò��������������
            [ SingleTargetFitness , ARTFitness( 1 , ST ) ] = FitnessCompute( DecisionVector , WeaponNum , TargetNum , TargetWeight , KillPro );     % ���߾����Ӧ��Ŀ�꺯��ֵ
            [ OptimalDecisionVector , OptimalShift , ShiftCost , OptimalCycle , OptimalCycleCost ] = ImproveGraphSearch( DecisionVector , SingleTargetFitness , PathLength , WeaponNum , TargetNum , KillPro );
            if ShiftCost + OptimalCycleCost < 0
                ARTNSFitness( 1 , ST ) = ARTFitness( 1 , ST ) + ShiftCost + OptimalCycleCost;
                DecisionVector = OptimalDecisionVector;
                [ SingleTargetFitness , ARTFitness( 1 , ST ) ] = FitnessCompute( DecisionVector , WeaponNum , TargetNum , TargetWeight , KillPro );     % ���߾����Ӧ��Ŀ�꺯��ֵ
                [ OptimalDecisionVector , OptimalShift , ShiftCost , OptimalCycle , OptimalCycleCost ] = ImproveGraphSearch( DecisionVector , SingleTargetFitness , PathLength , WeaponNum , TargetNum , KillPro );
            end
            break;
        else
            CategoryCompeteFitness( 1 , CategoryCompeteMaxIndex ) = 0;      % Reset�ѱ�����Ч�ڵ㣬ʹ֮ʧЧ
            if i == TrainDataNum
                fprintf('NO Node!\n');
            end
        end
    end
    
    toc;
    ARTTime(1,ST) = toc;
    
    %ST
    
end

save ARTFitness.mat ARTFitness
save ARTTime.mat ARTTime

