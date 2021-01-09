
clear all

%%%%% 载入样本输入和样本输出
load W20T12TrainDataInput.mat
load W20T12TrainDataOutput.mat
load W20T12rSim.mat

TrainDataSize = size( W20T12TrainDataInput );     % 样本输入集合的维数
TrainDataNum = TrainDataSize(1,1);      % 提取样本数量

WeaponNum = 20;     % 武器数量
TargetNum = 12;      % 目标数量
MaxKillPro = [ 0.57 : 0.02 : 0.95 ];        % 每个武器的最大杀伤概率
MaxKillRange = [ 50000 : -1000 : 31000 ];     % 每个武器的最大杀伤距离
BellWidth = 20000 .* ones(1,WeaponNum);       % Bell Width
RMax = 62000;       % 战场环境最大距离
RMin = 30000;       % 战场环境最小距离
ChoiceParameter = 0.00001;        % 选择参数
ResonanceThreshold = 0.98;      % 谐振门限值，即利用门限值
PathLength = 5;

%%%%% 仿真结果指标
rSimSize = size(W20T12rSim);
SimTimes = rSimSize(1);     % 仿真次数
ARTFitness = zeros( 1 , SimTimes );
ARTNSFitness = zeros( 1 , SimTimes );   % 决策解目标函数适应度
ARTNSTime = zeros(1,SimTimes);

for ST = 1 : SimTimes      % 仿真次数
    
    r = W20T12rSim(ST,:);     % 生成目标距离向量，即激励向量
    [ r ] = RangeSort( r , TargetNum );     % 将输入按照目标权值升序排列
    
    CategoryCompeteFitness = zeros(1,TrainDataNum);     % F2层中节点竞争适应度向量
    DecisionVector = zeros(1,WeaponNum);     % 输出向量，即目标分配决策向量
    
    [ TargetWeight, KillPro ] = WTAIntialization( MaxKillPro, MaxKillRange, BellWidth, RMax, r, TargetNum, WeaponNum );     % 生成目标权值向量和杀伤概率矩阵
    
    %%%%% 输入矩阵转为输入向量
    temp1 = [ TargetWeight ; KillPro ]';
    temp2 = temp1(:);
    InputVector = temp2';
    
    tic;
    %%%%% 计算F2层中的节点竞争适应度
    for i = 1 : TrainDataNum
        [ CategoryCompeteFitness( 1 , i ) ] = CategoryCompete( InputVector , W20T12TrainDataInput(i,:) , ChoiceParameter );     % F2层节点竞争适应度
    end
    
    for i = 1 : TrainDataNum
        [ CategoryCompeteMax , CategoryCompeteMaxIndex ] = max( CategoryCompeteFitness );   % 得到竞争获胜神经元
        [ ResonanceFitness ] = ResonanceMatch( InputVector , W20T12TrainDataInput(CategoryCompeteMaxIndex,:) );   % 计算谐振适应度
        if ResonanceFitness >= ResonanceThreshold
            DecisionVector = W20T12TrainDataOutput( CategoryCompeteMaxIndex , : );    % 利用策略输出决策向量
            [ SingleTargetFitness , ARTFitness( 1 , ST ) ] = FitnessCompute( DecisionVector , WeaponNum , TargetNum , TargetWeight , KillPro );     % 决策矩阵对应的目标函数值
            [ OptimalDecisionVector , OptimalShift , ShiftCost , OptimalCycle , OptimalCycleCost ] = ImproveGraphSearch( DecisionVector , SingleTargetFitness , PathLength , WeaponNum , TargetNum , KillPro );
            if ShiftCost + OptimalCycleCost < 0
                1
                ARTNSFitness( 1 , ST ) = ARTFitness( 1 , ST ) + ShiftCost + OptimalCycleCost;
                DecisionVector = OptimalDecisionVector;
                [ SingleTargetFitness , ARTFitness( 1 , ST ) ] = FitnessCompute( DecisionVector , WeaponNum , TargetNum , TargetWeight , KillPro );     % 决策矩阵对应的目标函数值
                [ OptimalDecisionVector , OptimalShift , ShiftCost , OptimalCycle , OptimalCycleCost ] = ImproveGraphSearch( DecisionVector , SingleTargetFitness , PathLength , WeaponNum , TargetNum , KillPro );
            end
            break;
        else
            CategoryCompeteFitness( 1 , CategoryCompeteMaxIndex ) = 0;      % Reset已遍历有效节点，使之失效
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

