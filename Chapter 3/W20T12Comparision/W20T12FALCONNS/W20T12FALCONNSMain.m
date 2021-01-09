
clear all

%%%%% ��������������������
load W20T12TrainDataInput.mat
load W20T12TrainDataOutput.mat
load W20T12rSim.mat

TrainDataSize = size( W20T12TrainDataInput );     % �������뼯�ϵ�ά��
TrainDataNum = TrainDataSize(1,1);      % ��ȡ��������

WeaponNum = 20;     % ��������
TargetNum = 12;      % Ŀ������
MaxKillPro = [ 0.57 : 0.02 : 0.95 ];        % ÿ�����������ɱ�˸���
MaxKillRange = [ 50000 : -1000 : 31000 ];     % ÿ�����������ɱ�˾���
BellWidth = 20000 .* ones(1,WeaponNum);       % Bell Width
RMax = 62000;       % ս������������
RMin = 30000;       % ս��������С����
ChoiceParameter = 0.00001;        % ѡ�����
ResonanceThreshold = 0.98;      % г������ֵ������������ֵ
PathLength = 5;

%%%%% ������ָ��
rSimSize = size(W20T12rSim);
SimTimes = rSimSize(1);     % �������
ARTFitness = zeros( 1 , SimTimes );
ARTNSFitness = zeros( 1 , SimTimes );   % ���߽�Ŀ�꺯����Ӧ��
ARTNSTime = zeros(1,SimTimes);

for ST = 1 : SimTimes      % �������
    
    r = W20T12rSim(ST,:);     % ����Ŀ���������������������
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
        [ CategoryCompeteFitness( 1 , i ) ] = CategoryCompete( InputVector , W20T12TrainDataInput(i,:) , ChoiceParameter );     % F2��ڵ㾺����Ӧ��
    end
    
    for i = 1 : TrainDataNum
        [ CategoryCompeteMax , CategoryCompeteMaxIndex ] = max( CategoryCompeteFitness );   % �õ�������ʤ��Ԫ
        [ ResonanceFitness ] = ResonanceMatch( InputVector , W20T12TrainDataInput(CategoryCompeteMaxIndex,:) );   % ����г����Ӧ��
        if ResonanceFitness >= ResonanceThreshold
            DecisionVector = W20T12TrainDataOutput( CategoryCompeteMaxIndex , : );    % ���ò��������������
            [ SingleTargetFitness , ARTFitness( 1 , ST ) ] = FitnessCompute( DecisionVector , WeaponNum , TargetNum , TargetWeight , KillPro );     % ���߾����Ӧ��Ŀ�꺯��ֵ
            [ OptimalDecisionVector , OptimalShift , ShiftCost , OptimalCycle , OptimalCycleCost ] = ImproveGraphSearch( DecisionVector , SingleTargetFitness , PathLength , WeaponNum , TargetNum , KillPro );
            if ShiftCost + OptimalCycleCost < 0
                1
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
    ARTNSTime(1,ST) = toc;
    
end

save ARTNSFitness.mat ARTNSFitness
save ARTNSTime.mat ARTNSTime

