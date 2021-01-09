
clear all

load ARTNSFitness.mat
load FDMFitness.mat
load GAFitness.mat

ARTNSOptimalCount = 0;
GAOptimalCount = 0;
FDMOptimalCount = 0;

for i = 1:100
    
    if ARTNSFitness(1,i) <= FDMFitness(1,i) && ARTNSFitness(1,i) <= GAFitness(1,i)
        ARTNSOptimalCount = ARTNSOptimalCount + 1;
    end
    if GAFitness(1,i) <= ARTNSFitness(1,i) && GAFitness(1,i) <= FDMFitness(1,i)
        GAOptimalCount = GAOptimalCount + 1;
    end
    if FDMFitness(1,i) <= ARTNSFitness(1,i) && FDMFitness(1,i) <= GAFitness(1,i)
        FDMOptimalCount = FDMOptimalCount + 1;
    end
    
end

ARTNSOptimalCount
GAOptimalCount
FDMOptimalCount
