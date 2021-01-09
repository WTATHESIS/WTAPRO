
load ARTNSFitness.mat
load GAFitness.mat
load EnumerateFitness.mat
load FDMFitness.mat

ARTMSE = sqrt(sum((ARTNSFitness - EnumerateFitness).^2)/100)
GAMSE = sqrt(sum((GAFitness - EnumerateFitness).^2)/100)
FDMMSE = sqrt(sum((FDMFitness - EnumerateFitness).^2)/100)


