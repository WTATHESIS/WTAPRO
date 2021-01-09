function [population,elitePopulation] = ElitePopulationGenerate(population,elitePopulationSize)
%ELITEPOPULATIONGENERATE 此处显示有关此函数的摘要
%   此处显示详细说明

%% 父代种群排序
[~,populationFitnessOrder] = sort(population.fitness(1,1,:),3,'descend');
population.fitness = population.fitness(:,:,populationFitnessOrder);
population.ISensorCode = population.ISensorCode(:,:,populationFitnessOrder);
population.IPlatformCode = population.IPlatformCode(:,:,populationFitnessOrder);
population.IISensorCode = population.IISensorCode(:,:,populationFitnessOrder);
population.IIPlatformCode = population.IIPlatformCode(:,:,populationFitnessOrder);
population.IIIPlatformComplement = population.IIIPlatformComplement(:,:,populationFitnessOrder);
population.IIIPlatformCode = population.IIIPlatformCode(:,:,populationFitnessOrder);
population.IIIPlatformState = population.IIIPlatformState(:,:,populationFitnessOrder);
population.IIIPlatformKillProbability = population.IIIPlatformKillProbability(:,:,populationFitnessOrder);
population.IIISensorCode = population.IIISensorCode(:,:,populationFitnessOrder);

%% 精英种群生成
elitePopulation.ISensorCode = population.ISensorCode(:,:,1:elitePopulationSize);
elitePopulation.IPlatformCode = population.IPlatformCode(:,:,1:elitePopulationSize);
elitePopulation.IISensorCode = population.IISensorCode(:,:,1:elitePopulationSize);
elitePopulation.IIPlatformCode = population.IIPlatformCode(:,:,1:elitePopulationSize);
elitePopulation.IIIPlatformComplement = population.IIIPlatformComplement(:,:,1:elitePopulationSize);
elitePopulation.IIIPlatformCode = population.IIIPlatformCode(:,:,1:elitePopulationSize);
elitePopulation.IIIPlatformState = population.IIIPlatformState(:,:,1:elitePopulationSize);
elitePopulation.IIIPlatformKillProbability = population.IIIPlatformKillProbability(:,:,1:elitePopulationSize);
elitePopulation.IIISensorCode = population.IIISensorCode(:,:,1:elitePopulationSize);
elitePopulation.fitness = population.fitness(:,:,1:elitePopulationSize);

end

