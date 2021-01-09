function [population] = InitialPopulationGenerate(populationSize,platformUpper,platformNumber,weaponLaunchState,sensorUpper,sensorNumber,targetNumber)
%POPULATIONINITIAL 此处显示有关此函数的摘要
%   此处显示详细说明

population.IPlatformCode = zeros(platformNumber,targetNumber,populationSize);
population.ISensorNecessary = zeros(1,targetNumber,populationSize);
population.ISensorCode = zeros(sensorNumber,targetNumber,populationSize);
population.IISensorCode = zeros(1,sensorNumber,populationSize);
population.IIPlatformCode = zeros(1,platformNumber,populationSize);
population.IIIPlatformComplement = zeros(1,platformNumber,populationSize);
population.IIIPlatformCode = zeros(platformNumber,targetNumber,populationSize);
population.IIIPlatformState = zeros(platformNumber,targetNumber,populationSize);
population.IIIPlatformKillProbability = zeros(platformNumber,targetNumber,populationSize);
population.IIISensorCode = zeros(platformNumber,targetNumber,populationSize);
population.fitness = zeros(5,targetNumber,populationSize);

platformLaunchState = max(abs(weaponLaunchState),[],3);

for solutionIndex = 1 : populationSize
    
    %% 个体武器编码初始化
    platformAvailableState = platformLaunchState;
    
    for platformUpperIndex = 1 : platformUpper
        for targetIndex = 1 : targetNumber
            
            platformAvailableNumber = sum(platformAvailableState,1);
            
            if rand > 1/(platformAvailableNumber(targetIndex) + 1)
               
                temp3 = find(platformAvailableState(:,targetIndex) == 1);
                platformLabel = temp3(randi(platformAvailableNumber(targetIndex)),1);
                population.IPlatformCode(platformUpperIndex,targetIndex,solutionIndex) = platformLabel;
                population.IIPlatformCode(1,platformLabel,solutionIndex) = targetIndex;
                
                platformAvailableState(platformLabel,:) = 0;
                
                population.ISensorNecessary(1,targetIndex,solutionIndex) = max(population.ISensorNecessary(1,targetIndex,solutionIndex),max(weaponLaunchState(platformLabel,targetIndex,:)));
                if population.ISensorNecessary(1,targetIndex,solutionIndex) == -1
                    population.ISensorNecessary(1,targetIndex,solutionIndex) = 0;
                end
            end
            
        end
    end
    
    %% 个体传感器编码生成
    sensorAvailableState = ones(sensorNumber,1);
    
    for sensorUpperIndex = 1 : sensorUpper
        for targetIndex = 1 : targetNumber
            
            sensorAvailableNumber = sum(sensorAvailableState,1);
            
            if population.ISensorNecessary(1,targetIndex,solutionIndex) == 1 && sensorAvailableNumber > 0
                if rand > 1/(sensorAvailableNumber + 1)
                    availableSensorLabels = find(sensorAvailableState == 1);                   
                    sensorLabel = availableSensorLabels(randi(sensorAvailableNumber),1);
                    population.ISensorCode(sensorUpperIndex,targetIndex,solutionIndex) = sensorLabel;
                    population.IISensorCode(1,sensorLabel,solutionIndex) = targetIndex;
                    
                    sensorAvailableState(sensorLabel,1) = 0;
                end
            end
            
        end
    end
    
end

end

