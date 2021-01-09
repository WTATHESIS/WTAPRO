function [population] = NextPopulationGenerate(population, populationSize, offspringPopulation)
%NEXTPOPULATIONGENERATE 此处显示有关此函数的摘要
%   此处显示详细说明
offspringPopulation.ISensorCode = cat(3,offspringPopulation.ISensorCode,population.ISensorCode);
offspringPopulation.IPlatformCode = cat(3,offspringPopulation.IPlatformCode,population.IPlatformCode);
offspringPopulation.IISensorCode = cat(3,offspringPopulation.IISensorCode,population.IISensorCode);
offspringPopulation.IIPlatformCode = cat(3,offspringPopulation.IIPlatformCode,population.IIPlatformCode);
offspringPopulation.IIIPlatformComplement = cat(3,offspringPopulation.IIIPlatformComplement,population.IIIPlatformComplement);
offspringPopulation.IIIPlatformCode = cat(3,offspringPopulation.IIIPlatformCode,population.IIIPlatformCode);
offspringPopulation.IIIPlatformState = cat(3,offspringPopulation.IIIPlatformState,population.IIIPlatformState);
offspringPopulation.IIIPlatformKillProbability = cat(3,offspringPopulation.IIIPlatformKillProbability,population.IIIPlatformKillProbability);
offspringPopulation.IIISensorCode = cat(3,offspringPopulation.IIISensorCode,population.IIISensorCode);
offspringPopulation.fitness = cat(3,offspringPopulation.fitness,population.fitness);

[~,population] = ElitePopulationGenerate(offspringPopulation,populationSize);

end

