

rmdir('InterceptionFigures','s');
mkdir InterceptionFigures;

rmdir('Results','s');
mkdir Results;


% rng shuffle

% fprintf('Simulate %d\n',simulateIndex);

%% ƽ̨��������Ŀ������
load platformNumber.mat
load sensorNumber.mat
load weaponNumber.mat
load targetNumber.mat

%% ����-Ŀ��ɱ�˸��ʲ���
probabilityPeak = [0.9,0.9,0.9];
probabilityWeight = [0.5,0.25,0.25];
sensorMaxRange = 150000;
sensorCoefficient = 1.23;

%% �칹�������
time = 0;   % ��ʼ����ʱ��
responseTime = 1.5;    % ϵͳ��Ӧʱ��
assessTime = 1.5;  % ��������ʱ��

%% �㷨����
sensorUpper = 2;    % ��Ŀ��Ĵ�����������������
platformUpper = 2;  % ��Ŀ���ƽ̨������������
constraintWeight1 = -1;  % Ŀ��״̬-��������һ����ϵ��
constraintWeight2 = -2;  % ��������-������һ����ϵ��
populationSize = 200;   % ��Ⱥ��ģ
elitePopulationSize = 100;   % ��Ӣ��Ⱥ��ģ
offspringPopulationSize = 100;  % �Ӵ���Ⱥ��ģ
crossGeneNumber = ceil(sensorNumber/2);    % �������������λ����
maxGeneration = 100;    % ��������

%% ������Ŀ������
load platforPosition.mat
load thetaM.mat
load phiM.mat
velocityM = 300;  % �����ٶ�

load targetPosition.mat
load thetaT.mat
load phiT.mat
velocityT = 260;  % Ŀ���ٶ�

%% �칹�������ã����͡���̡�����ϵ��
shortWeaponRange = [500,30000]; % ��������ɱ�˷�Χ
longWeaponRange = [500,90000];  % ��Զ������ɱ�˷�Χ

load weaponState.mat

guidanceCoefficient = zeros(platformNumber,1,weaponNumber); % ��������ϵ��
guidanceCoefficient(find(weaponState==1)) = 3;
guidanceCoefficient(find(weaponState==-1)) = 6;

%% ƽ̨��������Ŀ��״̬
platformState = ones(platformNumber,1); % % 1������  0��������
platformState( find( max(abs(weaponState),[],3)==0 ) ) = 0;
targetState = ones(1,targetNumber);    % 1������  0����ɱ��

stageIndex = 1; % ������������

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
    
    %% Ŀ����в����
    [targetValue,heightThreat,velocityValue,shortCutThreat,flyTimeThreat] = TargetValueGenerate(platformPosition,targetPosition,targetNumber,targetState,thetaT,phiT,velocityT);
    
    %% ������̽�����,����-Ŀ�깥��������ɱ�˸���
    [sensorDetectProbability,weaponLaunchState,weaponKillProbability,timeGo_tGo] = SensorWeaponStateProbabilityCalulate(platformPosition,platformState,platformNumber,sensorNumber,weaponNumber,targetPosition,targetNumber,thetaM,thetaT,velocityM,velocityT,weaponState,targetState,shortWeaponRange,longWeaponRange,probabilityPeak,probabilityWeight,sensorMaxRange,sensorCoefficient,guidanceCoefficient);
    
    %% ��Ⱥ����
    [population] = InitialPopulationGenerate(populationSize, platformUpper,platformNumber, weaponLaunchState, sensorUpper, sensorNumber, targetNumber);
    
    %% �����������ɡ���Ӧ�ȼ���
    [population] = WeaponComplementFitnessCalculation(population, populationSize, platformNumber, platformUpper, sensorNumber, sensorUpper, weaponNumber, weaponLaunchState, weaponKillProbability, sensorDetectProbability, targetNumber, targetValue, constraintWeight1, constraintWeight2);
    
    currentFitness = [];
    tic;
    for generationIndex = 1 : maxGeneration
        
        %% ��Ⱥ���򡢾�Ӣ��Ⱥ����
        [population,elitePopulation] = ElitePopulationGenerate(population,elitePopulationSize);
        
        %% �Ӵ���Ⱥ����
        [offspringPopulation] = OffspringPopulationGenerate(elitePopulation, elitePopulationSize, offspringPopulationSize, weaponState, platformState, platformNumber, sensorNumber, targetNumber, crossGeneNumber);
        
        %% �Ӵ���Ⱥ�����������ɡ���Ӧ�ȼ���
        [offspringPopulation] = WeaponComplementFitnessCalculation(offspringPopulation, offspringPopulationSize, platformNumber, platformUpper, sensorNumber, sensorUpper, weaponNumber, weaponLaunchState, weaponKillProbability, sensorDetectProbability, targetNumber, targetValue, constraintWeight1, constraintWeight2);
        
        %% ����Ⱥ����
        [population] = NextPopulationGenerate(population, populationSize, offspringPopulation);
        
        %% ���Ž���ȡ
        [optimalSolution] = OptimalSolutionGenerate(population,platformNumber,sensorNumber,targetNumber);
        
        currentFitness = cat(4,currentFitness,population.fitness);
        
    end
    consumeTime = toc;
    
    if all(optimalSolution.IIIPlatformCode==0,'all')
        
        %% Ŀ�����,
        [XT,YT,ZT,CIT,FAI,TT,endTime,victory,terminalDistance] = TargetTrajectory(platformNumber,platformPosition,platformState,weaponNumber,weaponState,shortWeaponRange,longWeaponRange,targetNumber,targetPosition,targetState,thetaT,phiT,velocityT,time);
        
        %% �켣���ӻ�
        figure(1);
        if victory == -1
            axis([-terminalDistance-1000 80000 0 100000]);
        end
        %% Ŀ��켣
        TargetTrajectoryPlot(targetNumber,targetState,XT,YT,ZT,FAI,CIT,2000);
        savefig('tempFigure.fig');
        h2 = openfig('tempFigure.fig');
        %% ����ƽ̨״̬
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
        
        %% ����Ŀ��λ�á��Ƕ�
        [targetPosition,thetaT,phiT] = TargetStateUpdate(targetNumber,targetState,targetPosition,thetaT,phiT,XT,ZT,YT,CIT,FAI);
        
        %% ����ʱ�����
        time = endTime;
        
    else
        
        fprintf('Stage %d\n',stageIndex);
        
        %% Ŀ�����ģ�ͣ����ݾ��ߡ���Ӧ������ʱ����Ŀ��λ�á��Ƕ���Ϣ��Ŀ��״̬
        [XT,YT,ZT,CIT,FAI,TT,XM,YM,ZM,CITM,FAIM,T,targetState,platformNull,irradiatePosition,endTime] = SensorWeaponTargetTrajectory(targetState,targetPosition,targetNumber,velocityT,thetaT,phiT,platformPosition,platformNumber,velocityM,thetaM,phiM,guidanceCoefficient,optimalSolution,time,responseTime,assessTime,stageIndex);
        
        %% ����ƽ̨����������״̬
        [platformState,weaponState,thetaM,phiM] = PlatformStateUpdate(optimalSolution,platformNumber,platformPosition,platformState,weaponState,thetaM,phiM);
        
        %% ����Ŀ��λ�á��Ƕ�
        [targetPosition,thetaT,phiT] = TargetStateUpdate(targetNumber,targetState,targetPosition,thetaT,phiT,XT,ZT,YT,CIT,FAI);
        
        timeRecord = cat(3,timeRecord,consumeTime);
        
        fitnessRecord = cat(5,fitnessRecord,currentFitness);
        
        weaponStateRecord = cat(2,weaponStateRecord,weaponState);
        
        targetStateRecord = cat(3,targetStateRecord,targetState);
        
        decisionTimeRecord = cat(3,decisionTimeRecord,time+responseTime);
        
        %% ����ʱ�����
        time = endTime;
        
        %% �켣���ӻ�
        figure(1);
        %% ����ʾ��ͼ
        IrradiatePlot(sensorNumber,optimalSolution,platformPosition,irradiatePosition);
        %% Ŀ��켣
        TargetTrajectoryPlot(targetNumber,targetState,XT,YT,ZT,FAI,CIT,2000);
        %% �����켣
        WeaponTrajectoryPlot(optimalSolution,platformNumber,platformNull,XM,YM,ZM,FAIM,CITM,500);
        
        savefig('tempFigure.fig');
        h2 = openfig('tempFigure.fig');
        %% ����ƽ̨״̬
        PlatformPlot(platformNumber,platformState,platformPosition,500);
        fileName = [pwd,'/InterceptionFigures/Stage',num2str(stageIndex),'Attack.eps'];
        print('-depsc',fileName);
        close(h2);
        
        %% S/HWTA�㷨��ֹ����
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


