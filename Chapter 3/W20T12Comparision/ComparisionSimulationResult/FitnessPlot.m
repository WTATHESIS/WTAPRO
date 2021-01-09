clear all
i = [1:1:100];
load ARTNSFitness.mat
load GAFitness.mat
load FDMFitness.mat
scatter(i,ARTNSFitness,'o');
hold on;
scatter(i,FDMFitness,'d');
hold on;
scatter(i,GAFitness,'+');
legend('ART-NS','FDM','GA');
xlabel('Examples'); 
ylabel('Best Fitness');

