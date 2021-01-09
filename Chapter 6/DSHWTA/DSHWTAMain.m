

rmdir('InterceptionFigures','s');
mkdir InterceptionFigures;

rmdir('Results','s');
mkdir Results;


% rng shuffle

% fprintf('Simulate %d\n',simulateIndex);

%% 平台、武器、目标数量
load platformNumber.mat
load sensorNumber.mat
load weaponNumber.mat
load targetNumber.mat

%% 武器-目标杀伤概率参数
probabilityPeak = [0.9,0.9,0.9];
probabilityWeight = [0.5,0.25,0.25];
sensorMaxRange = 150000;
sensorCoefficient = 1.23;

%% 异构武器射程
time = 0;   % 初始决策时刻
responseTime = 1.5;    % 系统反应时间
assessTime = 1.5;  % 毁伤评估时间

%% 算法参数
sensorUpper = 2;    % 单目标的传感器分配数量上限
platformUpper = 2;  % 单目标的平台分配数量上限
constraintWeight1 = -1;  % 目标状态-武器类型一致性系数
constraintWeight2 = -2;  % 武器类型-传感器一致性系数
populationSize = 200;   % 种群规模
elitePopulationSize = 100;   % 精英种群规模
offspringPopulationSize = 100;  % 子代种群规模
crossGeneNumber = ceil(sensorNumber/2);    % 传感器交叉基因位数量
maxGeneration = 100;    % 进化代数

%% 武器、目标配置
load platforPosition.mat
load thetaM.mat
load phiM.mat
velocityM = 300;  % 武器速度

load targetPosition.mat
load thetaT.mat
load phiT.mat
velocityT = 260;  % 目标速度

%% 异构武器配置：类型、射程、导引系数
shortWeaponRange = [500,30000]; % 近距武器杀伤范围
longWeaponRange = [500,90000];  % 中远距武器杀伤范围

load weaponState.mat

guidanceCoefficient = zeros(platformNumber,1,weaponNumber); % 武器导引系数
guidanceCoefficient(find(weaponState==1)) = 3;
guidanceCoefficient(find(weaponState==-1)) = 6;

%% 平台、武器、目标状态
platformState = ones(platformNumber,1); % % 1：可用  0：不可用
platformState( find( max(abs(weaponState),[],3)==0 ) ) = 0;
targetState = ones(1,targetNumber);    % 1：生存  0：被杀伤

stageIndex = 1; % 进化代数索引

victory = NaN;

fitnessRecord = [];
weaponStateRecord = [];
targetStateRecord = [];
decisionTimeRecord = [];
victoryRecord = [];
timeRecord = [];

fileName = [pwd,'/Results/InterceptionProcess.txt'];
delete(fileName);

h1 = figure(1);

InitialTargetPlot(targetNumber,targetPosition,phiT,thetaT);
grid on
axis equal
axis([0 80000 0 100000]);
xlabel('X');
ylabel('Y');
zlabel('Z');

while (1)
    
    %% 目标威胁评估
    [targetValue,heightThreat,velocityValue,shortCutThreat,flyTimeThreat] = TargetValueGenerate(platformPosition,targetPosition,targetNumber,targetState,thetaT,phiT,velocityT);
    
    %% 传感器探测概率,武器-目标攻击条件、杀伤概率
    [sensorDetectProbability,weaponLaunchState,weaponKillProbability,timeGo_tGo] = SensorWeaponStateProbabilityCalulate(platformPosition,platformState,platformNumber,sensorNumber,weaponNumber,targetPosition,targetNumber,thetaM,thetaT,velocityM,velocityT,weaponState,targetState,shortWeaponRange,longWeaponRange,probabilityPeak,probabilityWeight,sensorMaxRange,sensorCoefficient,guidanceCoefficient);
    
    %% 种群生成
    [population] = InitialPopulationGenerate(populationSize, platformUpper,platformNumber, weaponLaunchState, sensorUpper, sensorNumber, targetNumber);
    
    %% 武器补码生成、适应度计算
    [population] = WeaponComplementFitnessCalculation(population, populationSize, platformNumber, platformUpper, sensorNumber, sensorUpper, weaponNumber, weaponLaunchState, weaponKillProbability, sensorDetectProbability, targetNumber, targetValue, constraintWeight1, constraintWeight2);
    
    currentFitness = [];
    tic;
    for generationIndex = 1 : maxGeneration
        
        %% 种群排序、精英种群生成
        [population,elitePopulation] = ElitePopulationGenerate(population,elitePopulationSize);
        
        %% 子代种群生成
        [offspringPopulation] = OffspringPopulationGenerate(elitePopulation, elitePopulationSize, offspringPopulationSize, weaponState, platformState, platformNumber, sensorNumber, targetNumber, crossGeneNumber);
        
        %% 子代种群武器补码生成、适应度计算
        [offspringPopulation] = WeaponComplementFitnessCalculation(offspringPopulation, offspringPopulationSize, platformNumber, platformUpper, sensorNumber, sensorUpper, weaponNumber, weaponLaunchState, weaponKillProbability, sensorDetectProbability, targetNumber, targetValue, constraintWeight1, constraintWeight2);
        
        %% 新种群生成
        [population] = NextPopulationGenerate(population, populationSize, offspringPopulation);
        
        %% 最优解提取
        [optimalSolution] = OptimalSolutionGenerate(population,platformNumber,sensorNumber,targetNumber);
        
        currentFitness = cat(4,currentFitness,population.fitness);
        
    end
    consumeTime = toc;
    
    if all(optimalSolution.IIIPlatformCode==0,'all')
        
        %% 目标飞行,
        [XT,YT,ZT,CIT,FAI,TT,endTime,victory,terminalDistance] = TargetTrajectory(platformNumber,platformPosition,platformState,weaponNumber,weaponState,shortWeaponRange,longWeaponRange,targetNumber,targetPosition,targetState,thetaT,phiT,velocityT,time);
        
        %% 轨迹可视化
        figure(1);
        if victory == -1
            axis([-terminalDistance-1000 80000 0 100000]);
        end
        %% 目标轨迹
        TargetTrajectoryPlot(targetNumber,targetState,XT,YT,ZT,FAI,CIT,2000);
        savefig('tempFigure.fig');
        h2 = openfig('tempFigure.fig');
        %% 更新平台状态
        PlatformPlot(platformNumber,platformState,platformPosition,500);
        fileName = [pwd,'/InterceptionFigures/Stage',num2str(stageIndex),'Pend.eps'];
        print('-depsc',fileName);
        close(h2);
        
        if victory == -1
            close(h1);
            fileName = [pwd,'/Results/timeRecord.mat'];
            save(fileName, 'timeRecord');
            fileName = [pwd,'/Results/fitnessRecord.mat'];
            save(fileName, 'fitnessRecord');
            fileName = [pwd,'/Results/weaponStateRecord.mat'];
            save(fileName, 'weaponStateRecord');
            fileName = [pwd,'/Results/targetStateRecord.mat'];
            save(fileName ,'targetStateRecord');
            fileName = [pwd,'/Results/decisionTimeRecord.mat'];
            save(fileName ,'decisionTimeRecord');
            victory = -1
            victoryRecord = cat(3,victoryRecord,victory);
            fileName = [pwd,'/Results/victoryRecord.mat'];
            save(fileName, 'victoryRecord');
            stageCount = stageIndex-1;
            fileName = [pwd,'/Results/stageCount.mat'];
            save(fileName,'stageCount');
            break;
        end
        
        %% 更新目标位置、角度
        [targetPosition,thetaT,phiT] = TargetStateUpdate(targetNumber,targetState,targetPosition,thetaT,phiT,XT,ZT,YT,CIT,FAI);
        
        %% 决策时间更新
        time = endTime;
        
    else
        
        fprintf('Stage %d\n',stageIndex);
        
        %% 目标飞行模型，根据决策、反应、飞行时间获得目标位置、角度信息、目标状态
        [XT,YT,ZT,CIT,FAI,TT,XM,YM,ZM,CITM,FAIM,T,targetState,platformNull,irradiatePosition,endTime] = SensorWeaponTargetTrajectory(targetState,targetPosition,targetNumber,velocityT,thetaT,phiT,platformPosition,platformNumber,velocityM,thetaM,phiM,guidanceCoefficient,optimalSolution,time,responseTime,assessTime,stageIndex);
        
        %% 更新平台、武器类型状态
        [platformState,weaponState,thetaM,phiM] = PlatformStateUpdate(optimalSolution,platformNumber,platformPosition,platformState,weaponState,thetaM,phiM);
        
        %% 更新目标位置、角度
        [targetPosition,thetaT,phiT] = TargetStateUpdate(targetNumber,targetState,targetPosition,thetaT,phiT,XT,ZT,YT,CIT,FAI);
        
        timeRecord = cat(3,timeRecord,consumeTime);
        
        fitnessRecord = cat(5,fitnessRecord,currentFitness);
        
        weaponStateRecord = cat(2,weaponStateRecord,weaponState);
        
        targetStateRecord = cat(3,targetStateRecord,targetState);
        
        decisionTimeRecord = cat(3,decisionTimeRecord,time+responseTime);
        
        %% 决策时间更新
        time = endTime;
        
        %% 轨迹可视化
        figure(1);
        %% 照射示意图
        IrradiatePlot(sensorNumber,optimalSolution,platformPosition,irradiatePosition);
        %% 目标轨迹
        TargetTrajectoryPlot(targetNumber,targetState,XT,YT,ZT,FAI,CIT,2000);
        %% 武器轨迹
        WeaponTrajectoryPlot(optimalSolution,platformNumber,platformNull,XM,YM,ZM,FAIM,CITM,500);
        
        savefig('tempFigure.fig');
        h2 = openfig('tempFigure.fig');
        %% 更新平台状态
        PlatformPlot(platformNumber,platformState,platformPosition,500);
        fileName = [pwd,'/InterceptionFigures/Stage',num2str(stageIndex),'Attack.eps'];
        print('-depsc',fileName);
        close(h2);
        
        %% S/HWTA算法终止条件
        if all(targetState==0,'all')
            close(h1);
            fileName = [pwd,'/Results/timeRecord.mat'];
            save(fileName, 'timeRecord');
            fileName = [pwd,'/Results/fitnessRecord.mat'];
            save(fileName, 'fitnessRecord');
            fileName = [pwd,'/Results/weaponStateRecord.mat'];
            save(fileName, 'weaponStateRecord');
            fileName = [pwd,'/Results/targetStateRecord.mat'];
            save(fileName ,'targetStateRecord');
            fileName = [pwd,'/Results/decisionTimeRecord.mat'];
            save(fileName ,'decisionTimeRecord');
            victory = 1
            victoryRecord = cat(3,victoryRecord,victory);
            fileName = [pwd,'/Results/victoryRecord.mat'];
            save(fileName, 'victoryRecord');
            stageCount = stageIndex;
            fileName = [pwd,'/Results/stageCount.mat'];
            save(fileName,'stageCount');
            break;
        elseif all(platformState==0,'all')
            close(h1);
            fileName = [pwd,'/Results/timeRecord.mat'];
            save(fileName, 'timeRecord');
            fileName = [pwd,'/Results/fitnessRecord.mat'];
            save(fileName, 'fitnessRecord');
            fileName = [pwd,'/Results/weaponStateRecord.mat'];
            save(fileName, 'weaponStateRecord');
            fileName = [pwd,'/Results/targetStateRecord.mat'];
            save(fileName ,'targetStateRecord');
            fileName = [pwd,'/Results/decisionTimeRecord.mat'];
            save(fileName ,'decisionTimeRecord');
            victory = 0
            victoryRecord = cat(3,victoryRecord,victory);
            fileName = [pwd,'/Results/victoryRecord.mat'];
            save(fileName, 'victoryRecord');
            stageCount = stageIndex;
            fileName = [pwd,'/Results/stageCount.mat'];
            save(fileName,'stageCount');
            break;
        end
        
        stageIndex = stageIndex + 1;
        
    end
    
end


