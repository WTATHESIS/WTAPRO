
clear all

load ARTNSFitness.mat
load EnumerateFitness.mat
load FDMFitness.mat
load GAFitness.mat

ARTOptimalGap = sum(ARTNSFitness-EnumerateFitness)/100
FDMOptimalGap = sum(FDMFitness-EnumerateFitness)/100
GAOptimalGap = sum(GAFitness-EnumerateFitness)/100


