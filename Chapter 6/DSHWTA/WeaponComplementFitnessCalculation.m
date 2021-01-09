function [population] = WeaponComplementFitnessCalculation(population, populationSize, platformNumber, platformUpper, sensorNumber, sensorUpper, weaponNumber ,weaponLaunchState, weaponKillProbability, sensorDetectProbability, targetNumber, targetValue, constraintWeight1, constraintWeight2)
%WEAPONCOMPLEMENTFITNESSCALCULATION 此处显示有关此函数的摘要
%   此处显示详细说明

%% 武器补码生成
for solutionIndex = 1 : populationSize
    for platformIndex = 1 : platformNumber
        sensorTargetLabel = population.IISensorCode(1,platformIndex,solutionIndex);
        if sensorTargetLabel ~= 0
            population.IIISensorCode(platformIndex,sensorTargetLabel,solutionIndex) = 1;
        end
    end
    
    temp = 1 - prod((1 - sensorDetectProbability(:,:)) .^ population.IIISensorCode(:,:,solutionIndex),1);
    for platformIndex = 1 : platformNumber
        targetLabel = population.IIPlatformCode(1,platformIndex,solutionIndex);
        if targetLabel ~= 0
            weaponKillEfficient = zeros(1,weaponNumber);
            for weaponIndex = 1 : weaponNumber
                if weaponLaunchState(platformIndex,targetLabel,weaponIndex) == 1
                    weaponKillEfficient(1,weaponIndex) = weaponKillProbability(platformIndex,targetLabel,weaponIndex) * temp(1,targetLabel);
                elseif weaponLaunchState(platformIndex,targetLabel,weaponIndex) == -1
                    weaponKillEfficient(1,weaponIndex) = weaponKillProbability(platformIndex,targetLabel,weaponIndex);
                end
            end
            [~,maxWeaponKillStateIndex] = max(weaponKillEfficient);
            population.IIIPlatformComplement(1,platformIndex,solutionIndex) = maxWeaponKillStateIndex;
        end
    end
    
end

%% 适应度计算
for solutionIndex = 1 : populationSize
    
    %% III型编码生成
    for platformIndex = 1 : platformNumber
        platformTargetLabel = population.IIPlatformCode(1,platformIndex,solutionIndex);
        if platformTargetLabel ~= 0
            population.IIIPlatformCode(platformIndex,platformTargetLabel,solutionIndex) = 1;
            population.IIIPlatformState(platformIndex,platformTargetLabel,solutionIndex) = weaponLaunchState(platformIndex,platformTargetLabel,population.IIIPlatformComplement(1,platformIndex,solutionIndex));
            population.IIIPlatformKillProbability(platformIndex,platformTargetLabel,solutionIndex) = weaponKillProbability(platformIndex,platformTargetLabel,population.IIIPlatformComplement(1,platformIndex,solutionIndex));
        end
    end
    
    for targetIndex = 1 : targetNumber
        %%  单个目标的武器上限修剪
        platformConsume = sum(population.IIIPlatformCode(:,targetIndex,solutionIndex));
        if platformConsume > platformUpper
            
            [killProbabilitySort,platformPurnIndex] = sort( population.IIIPlatformKillProbability(:,targetIndex,solutionIndex),'descend','MissingPlacement','last' );
            
            for surplusIndex = platformUpper+1 : platformNumber
                if killProbabilitySort(surplusIndex) > 0
                    platformLabel = platformPurnIndex(surplusIndex);
                    
                    population.IIIPlatformKillProbability(platformLabel,targetIndex,solutionIndex) = 0;
                    population.IIIPlatformState(platformLabel,targetIndex,solutionIndex) = 0;
                    population.IIIPlatformCode(platformLabel,targetIndex,solutionIndex) = 0;
                    population.IIIPlatformComplement(1,platformLabel,solutionIndex) = 0;
                    
                    population.IIPlatformCode(1,platformLabel,solutionIndex) = 0;
                    
                    [ICodePlatformPosition,ICodeTargetPosition] = ind2sub([platformNumber,targetNumber],find(population.IPlatformCode(:,:,solutionIndex)==platformLabel));
                    population.IPlatformCode(ICodePlatformPosition,ICodeTargetPosition,solutionIndex) = 0;
                else
                    break;
                end
            end
            
        end
        
        %% 单个目标的传感器上限修剪
        sensorConsume = sum(population.IIISensorCode(:,targetIndex,solutionIndex));
        if sensorConsume > sensorUpper
            [detecProbabilitySort,sensorPurnIndex] = sort( population.IIISensorCode(:,targetIndex,solutionIndex).*sensorDetectProbability,'descend','MissingPlacement','last' );
            
            for surplusIndex = sensorUpper+1 : sensorNumber
                if detecProbabilitySort(surplusIndex) > 0
                    sensorLabel = sensorPurnIndex(surplusIndex);
                    
                    population.IIISensorCode(sensorLabel,targetIndex,solutionIndex) = 0;
                    
                    population.IISensorCode(1,sensorLabel,solutionIndex)=0;
                    
                    [ICodeSensorPosition,ICodeTargetPosition] = ind2sub([platformNumber,targetNumber],find(population.ISensorCode(:,:,solutionIndex)==sensorLabel));
                    population.ISensorCode(ICodeSensorPosition,ICodeTargetPosition,solutionIndex) = 0;
                else
                    break;
                end
            end
            
        end
        
    end
    
    %% 适应度计算
    temp1 = prod((1 - sensorDetectProbability(:,:)) .^ population.IIISensorCode(:,:,solutionIndex),1);
    %         if any(temp1 == 0)
    %             print('afa require')
    %         end
    temp2 = max(population.IIIPlatformState(:,:,solutionIndex),0);
    temp3 = (1 - temp1) .^ temp2;
    temp4 = (1 - population.IIIPlatformKillProbability(:,:,solutionIndex) .* temp3) .^ population.IIIPlatformCode(:,:,solutionIndex);
    population.fitness(2,:,solutionIndex) = 1 - prod(temp4,1);
    for targetIndex = 1 : targetNumber
        if isnan(population.fitness(2,targetIndex,solutionIndex))
            population.fitness(5,1,solutionIndex) = population.fitness(5,1,solutionIndex) - 1;
            population.fitness(2,targetIndex,solutionIndex) = -1;
        end
    end
    %     population.fitness(2,:,solutionIndex) = targetValue .* temp5;
    %     population.fitness(2,:,solutionIndex) = sum(targetValue .* temp5,2);
    
    %% 攻击可行性约束惩罚函数
    temp6 = max(1-sum(abs(weaponLaunchState),3),0);
    %     temp7 = max(temp6,[],3);
    population.fitness(3,1,solutionIndex) = sum(population.IIIPlatformCode(:,:,solutionIndex) .* temp6,'all');
    
    %% 传感器-武器类型协同约束
    temp8 = population.IIIPlatformCode(:,:,solutionIndex) .* max(population.IIIPlatformState(:,:,solutionIndex),0);
    temp9 = max(temp8,[],1);
    for sensorIndex = 1 : sensorNumber
        temp10 = population.IISensorCode(1,sensorIndex,solutionIndex);
        if temp10 ~= 0
            population.fitness(4,1,solutionIndex) = 1 - temp9(1,temp10);
        end
    end
    
    population.fitness(1,1,solutionIndex) = constraintWeight1*population.fitness(3,1,solutionIndex) + constraintWeight2*population.fitness(4,1,solutionIndex);
    
    %% 目标存在性约束
    for targetIndex = 1 : targetNumber
        sensorWeaponCount = sum(population.ISensorCode(:,targetIndex,solutionIndex)>0) + sum(population.IPlatformCode(:,targetIndex,solutionIndex)>0);
        if ~isnan(targetValue(1,targetIndex))
            population.fitness(1,1,solutionIndex) = population.fitness(1,1,solutionIndex) + targetValue(1,targetIndex)*population.fitness(2,targetIndex,solutionIndex);
        elseif sensorWeaponCount > 0
            population.fitness(5,1,solutionIndex) = population.fitness(5,1,solutionIndex) + 1 * sensorWeaponCount;
            population.fitness(1,1,solutionIndex) = population.fitness(1,1,solutionIndex) - 1 * sensorWeaponCount;
        end
    end
    
end

end

