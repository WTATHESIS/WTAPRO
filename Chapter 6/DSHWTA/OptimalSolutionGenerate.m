function [optimalSolution] = OptimalSolutionGenerate(population,platformNumber,sensorNumber,targetNumber)
%OPTIMALSOLUTIONGENERATE 此处显示有关此函数的摘要
%   此处显示详细说明
optimalSolution.ISensorCode = population.ISensorCode(:,:,1);
optimalSolution.IPlatformCode = population.IPlatformCode(:,:,1);
optimalSolution.IISensorCode = population.IISensorCode(:,:,1);
optimalSolution.IIPlatformCode = population.IIPlatformCode(:,:,1);
optimalSolution.IIISensorCode = population.IIISensorCode(:,:,1);
optimalSolution.IIIPlatformCode = population.IIIPlatformCode(:,:,1);
optimalSolution.IIIPlatformComplement = population.IIIPlatformComplement(:,:,1);
optimalSolution.IIIPlatformState = population.IIIPlatformState(:,:,1);
optimalSolution.IIIPlatformKillProbability = population.IIIPlatformKillProbability(:,:,1);
optimalSolution.fitness = population.fitness(:,:,1);
optimalSolution.targetSensorCode = cell(1,targetNumber);
optimalSolution.targetPlatformCode = cell(1,targetNumber);
for sensorIndex = 1 : sensorNumber
    targetLabel = population.IISensorCode(1,sensorIndex);
    if targetLabel ~= 0
        optimalSolution.targetSensorCode{1,targetLabel} = [optimalSolution.targetSensorCode{1,targetLabel},sensorIndex];
    end
end
for platformIndex = 1 : platformNumber
    targetLabel = population.IIPlatformCode(1,platformIndex);
    if targetLabel ~= 0
        optimalSolution.targetPlatformCode{1,targetLabel} = [optimalSolution.targetPlatformCode{1,targetLabel},platformIndex];
    end
end

end

