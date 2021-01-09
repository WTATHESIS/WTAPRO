function [offspringPopulation] = OffspringPopulationGenerate(elitePopulation, elitePopulationSize, offspringPopulationSize, weaponState, platformState, platformNumber, sensorNumber, targetNumber, crossGeneNumber)
%OFFSPRINGPOPULATIONGENERATE �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��

%% �Ӵ���Ⱥ��ʼ��
offspringPopulation.IPlatformCode = zeros(platformNumber,targetNumber,offspringPopulationSize);
offspringPopulation.ISensorCode = zeros(sensorNumber,targetNumber,offspringPopulationSize);
offspringPopulation.IISensorCode = zeros(1,sensorNumber,offspringPopulationSize);
offspringPopulation.IIPlatformCode = zeros(1,platformNumber,offspringPopulationSize);
offspringPopulation.IIIPlatformComplement = zeros(1,platformNumber,offspringPopulationSize);
offspringPopulation.IIIPlatformCode = zeros(platformNumber,targetNumber,offspringPopulationSize);
offspringPopulation.IIIPlatformState = zeros(platformNumber,targetNumber,offspringPopulationSize);
offspringPopulation.IIIPlatformKillProbability = zeros(platformNumber,targetNumber,offspringPopulationSize);
offspringPopulation.IIISensorCode = zeros(platformNumber,targetNumber,offspringPopulationSize);
offspringPopulation.fitness = zeros(5,targetNumber,offspringPopulationSize);

platformStyle = max(weaponState,[],3); % ������������ƽ̨���ͣ��Ƿ���н�������

%% ���桢�������
offspringSolutionIndex = 0;
while(1)
    
    %% �������
    if rand < 0.8
        
        crossSolutionIndex = randperm(elitePopulationSize,2);
        %% �������������
        parent1Sensor = elitePopulation.IISensorCode(:,:,crossSolutionIndex(1));
        parent2Sensor = elitePopulation.IISensorCode(:,:,crossSolutionIndex(2));
        tempParent2Sensor = parent2Sensor;
        
        parent1CrossPosition = randperm(sensorNumber,crossGeneNumber);
        parent1CrossGene = parent1Sensor(parent1CrossPosition);
        
        parent1SensorState = zeros(1,sensorNumber);
        parent2SensorState = zeros(1,sensorNumber);
        
        for crossGeneIndex = 1 : crossGeneNumber
            parent2CrossPosition = find(tempParent2Sensor == parent1CrossGene(crossGeneIndex));
            parent2CrossSize = size(parent2CrossPosition,2);
            if parent2CrossSize == 1
                parent1SensorState(1,parent1CrossPosition(1,crossGeneIndex)) = 1;
                
                parent2SensorState(1,parent2CrossPosition) = 1;
                tempParent2Sensor(1,parent2CrossPosition) = -1;
            elseif parent2CrossSize > 1
                parent1SensorState(1,parent1CrossPosition(1,crossGeneIndex)) = 1;
                
                parent2CrossPosition = parent2CrossPosition(randi(parent2CrossSize));
                parent2SensorState(1,parent2CrossPosition) = 1;
                tempParent2Sensor(1,parent2CrossPosition) = -1;
            end
        end
        offspring1Sensor = zeros(1,sensorNumber);
        offspring2Sensor = zeros(1,sensorNumber);
        offspring1Sensor(parent1SensorState == 1) = parent1Sensor(parent1SensorState == 1);
        offspring2Sensor(parent2SensorState == 1) = parent2Sensor(parent2SensorState == 1);
        offspring1Sensor(parent1SensorState == 0) = parent2Sensor(parent2SensorState == 0);
        offspring2Sensor(parent2SensorState == 0) = parent1Sensor(parent1SensorState == 0);
        
        %% ����ƽ̨�������
        parent1Platform = elitePopulation.IIPlatformCode(:,:,crossSolutionIndex(1));
        parent2Platform = elitePopulation.IIPlatformCode(:,:,crossSolutionIndex(2));
        tempParent2Platform = parent2Platform;
        
        shortPlatformPosition = find(platformStyle == -1);
        shortPlatformNumber = size(shortPlatformPosition,1);
        
        if shortPlatformNumber >= 1 && shortPlatformNumber <= platformNumber - 1
            
            parent1ShortCrossGeneNumber = ceil(shortPlatformNumber/2);
            parent1ShortCrossGenePosition = shortPlatformPosition(randperm(shortPlatformNumber,parent1ShortCrossGeneNumber));
            parent1ShortCrossGene = parent1Platform(parent1ShortCrossGenePosition);
            
            parent1PlatformState = -1 * ones(1,platformNumber);
            parent1PlatformState(shortPlatformPosition) = 0;
            parent2PlatformState = -1 * ones(1,platformNumber);
            parent2PlatformState(shortPlatformPosition) = 0;
            
            for parent1ShortCrossGeneIndex = 1 : parent1ShortCrossGeneNumber
                parent2SingleShortCrossPosition = find(tempParent2Platform == parent1ShortCrossGene(parent1ShortCrossGeneIndex));
                parent2ShortCrossSize = size(parent2SingleShortCrossPosition,2);
                if parent2ShortCrossSize == 1
                    parent1PlatformState(1,parent1ShortCrossGenePosition(1,parent1ShortCrossGeneIndex)) = 1;
                    
                    parent2PlatformState(1,parent2SingleShortCrossPosition) = 1;
                    tempParent2Platform(1,parent2SingleShortCrossPosition) = -1;
                    if ~any(shortPlatformPosition == parent2SingleShortCrossPosition)
                        parent1PlatformState(1,parent2SingleShortCrossPosition) = 0;
                    end
                elseif parent2ShortCrossSize > 1
                    parent1PlatformState(1,parent1ShortCrossGenePosition(1,parent1ShortCrossGeneIndex)) = 1;
                    
                    parent2SingleShortCrossPosition = parent2SingleShortCrossPosition(randi(parent2ShortCrossSize));
                    parent2PlatformState(1,parent2SingleShortCrossPosition) = 1;
                    tempParent2Platform(1,parent2SingleShortCrossPosition) = -1;
                    if ~any(shortPlatformPosition == parent2SingleShortCrossPosition)
                        parent1PlatformState(1,parent2SingleShortCrossPosition) = 0;
                    end
                end
            end
            
            %             shortCrossPosition = find(parent2PlatformState >= 0);
            
            offspring1Platform = zeros(1,platformNumber);
            offspring2Platform = zeros(1,platformNumber);
            
            offspring1Platform(parent1PlatformState == 1) = parent1Platform(parent1PlatformState == 1);
            offspring2Platform(parent2PlatformState == 1) = parent2Platform(parent2PlatformState == 1);
            offspring1Platform(parent1PlatformState == 0) = parent2Platform(parent2PlatformState == 0);
            offspring2Platform(parent2PlatformState == 0) = parent1Platform(parent1PlatformState == 0);
            
            shortCrossPosition = find(parent2PlatformState >= 0);
            tempParent2Platform(shortCrossPosition) = -1;
            longPlatformPosition = find(parent2PlatformState.*platformState' < 0);
            longPlatformNumber = size(longPlatformPosition,2);
            
            parent1LongCrossGeneNumber = ceil(longPlatformNumber/2);
            parent1LongCrossGenePosition = longPlatformPosition(randperm(longPlatformNumber,parent1LongCrossGeneNumber));
            parent1LongCrossGene = parent1Platform(parent1LongCrossGenePosition);
            
            for parent1LongCrossGeneIndex = 1 : parent1LongCrossGeneNumber
                parent2SingleLongCrossPosition = find(tempParent2Platform == parent1LongCrossGene(parent1LongCrossGeneIndex));
                parent2LongCrossSize = size(parent2SingleLongCrossPosition,2);
                if parent2LongCrossSize == 1
                    parent1PlatformState(1,parent1LongCrossGenePosition(1,parent1LongCrossGeneIndex)) = -2;
                    
                    parent2PlatformState(1,parent2SingleLongCrossPosition) = -2;
                    tempParent2Platform(1,parent2SingleLongCrossPosition) = -1;
                    %                     if ~any(shortPlatformPosition == parent2SingleShortCrossPosition)
                    %                         parent1PlatformState(1,parent2SingleShortCrossPosition) = 0;
                    %                     end
                elseif parent2LongCrossSize > 1
                    parent1PlatformState(1,parent1LongCrossGenePosition(1,parent1LongCrossGeneIndex)) = -2;
                    
                    parent2SingleLongCrossPosition = parent2SingleLongCrossPosition(randi(parent2LongCrossSize));
                    parent2PlatformState(1,parent2SingleLongCrossPosition) = -2;
                    tempParent2Platform(1,parent2SingleLongCrossPosition) = -1;
                    %                     if ~any(shortPlatformPosition == parent2SingleShortCrossPosition)
                    %                         parent1PlatformState(1,parent2SingleShortCrossPosition) = 0;
                    %                     end
                end
            end
            
            offspring1Platform(parent1PlatformState == -2) = parent1Platform(parent1PlatformState == -2);
            offspring2Platform(parent2PlatformState == -2) = parent2Platform(parent2PlatformState == -2);
            offspring1Platform(parent1PlatformState == -1) = parent2Platform(parent2PlatformState == -1);
            offspring2Platform(parent2PlatformState == -1) = parent1Platform(parent1PlatformState == -1);
            
        else
            
            parent1CrossPosition = randperm(platformNumber,crossGeneNumber);
            parent1CrossGene = parent1Platform(parent1CrossPosition);
            
            parent1PlatformState = zeros(1,platformNumber);
            parent2PlatformState = zeros(1,platformNumber);
            
            for crossGeneIndex = 1 : crossGeneNumber
                parent2CrossPosition = find(tempParent2Platform == parent1CrossGene(crossGeneIndex));
                parent2CrossSize = size(parent2CrossPosition,2);
                if parent2CrossSize == 1
                    parent1PlatformState(1,parent1CrossPosition(1,crossGeneIndex)) = 1;
                    
                    parent2PlatformState(1,parent2CrossPosition) = 1;
                    tempParent2Platform(1,parent2CrossPosition) = -1;
                elseif parent2CrossSize > 1
                    parent1PlatformState(1,parent1CrossPosition(1,crossGeneIndex)) = 1;
                    
                    parent2CrossPosition = parent2CrossPosition(randi(parent2CrossSize));
                    parent2PlatformState(1,parent2CrossPosition) = 1;
                    tempParent2Platform(1,parent2CrossPosition) = -1;                
                end
            end
            
            offspring1Platform = zeros(1,platformNumber);
            offspring2Platform = zeros(1,platformNumber);
            
            offspring1Platform(parent1PlatformState == 1) = parent1Platform(parent1PlatformState == 1);
            offspring2Platform(parent2PlatformState == 1) = parent2Platform(parent2PlatformState == 1);
            offspring1Platform(parent1PlatformState == 0) = parent2Platform(parent2PlatformState == 0);
            offspring2Platform(parent2PlatformState == 0) = parent1Platform(parent1PlatformState == 0);
            
        end
        
        offspringSolutionIndex = offspringSolutionIndex + 1;
        if offspringSolutionIndex <= offspringPopulationSize
            offspringPopulation.IISensorCode(:,:,offspringSolutionIndex) = offspring1Sensor;
            offspringPopulation.IIPlatformCode(:,:,offspringSolutionIndex) = offspring1Platform;
        else
            break;
        end
        offspringSolutionIndex = offspringSolutionIndex + 1;
        if offspringSolutionIndex <= offspringPopulationSize
            offspringPopulation.IISensorCode(:,:,offspringSolutionIndex) = offspring2Sensor;
            offspringPopulation.IIPlatformCode(:,:,offspringSolutionIndex) = offspring2Platform;
        else
            break;
        end
        
        %% �������
    else
        %% �������������
        mutationSolutionIndex = randi(elitePopulationSize);
        mutationSensorPosition = randi(sensorNumber);
        parentSensor = elitePopulation.IISensorCode(:,:,mutationSolutionIndex(1));
        offspringSensor = parentSensor;
        offspringSensor(1,mutationSensorPosition) = randi(targetNumber);
        
        %% ����ƽ̨�������
        mutationPlatformPosition = randi(platformNumber);
        parentPlatform = elitePopulation.IIPlatformCode(:,:,mutationSolutionIndex(1));
        offspringPlatform = parentPlatform;
        offspringPlatform(1,mutationPlatformPosition) = randi(targetNumber);
        
        offspringSolutionIndex = offspringSolutionIndex + 1;
        if offspringSolutionIndex <= offspringPopulationSize
            offspringPopulation.IISensorCode(:,:,offspringSolutionIndex) = offspringSensor;
            offspringPopulation.IIPlatformCode(:,:,offspringSolutionIndex) = offspringPlatform;
        else
            break;
        end
        
    end
    
end

%% I�ͱ�������
for offspringPopulationIndex = 1 : offspringPopulationSize
    
    sensorNumberList = zeros(1,targetNumber);
    for sensorIndex = 1 : sensorNumber
        targetLabel = offspringPopulation.IISensorCode(1,sensorIndex,offspringPopulationIndex);
        if targetLabel ~= 0
            sensorNumberList(1,targetLabel) = sensorNumberList(1,targetLabel) + 1;
            offspringPopulation.ISensorCode(sensorNumberList(1,targetLabel),targetLabel,offspringPopulationIndex) = sensorIndex;
        end
    end
    
    platformNumberList = zeros(1,targetNumber);
    for platformIndex = 1 : platformNumber
        targetLabel = offspringPopulation.IIPlatformCode(1,platformIndex,offspringPopulationIndex);
        if targetLabel ~= 0
            platformNumberList(1,targetLabel) = platformNumberList(1,targetLabel) + 1;
            offspringPopulation.IPlatformCode(platformNumberList(1,targetLabel),targetLabel,offspringPopulationIndex) = platformIndex;
        end
    end
    
end

end

