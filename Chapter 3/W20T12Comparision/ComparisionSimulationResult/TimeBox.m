
clear all

load ARTNSTime.mat
load GATime.mat
%load EnumerateTime.mat
load FDMTime.mat

%ARTNSTime = ARTNSTime';
%FDMTime = 0.2*rand + ARTTime978;
%GATime = GATime';
%EnumerateTime = EnumerateTime';
%boxplot([ARTTime,GATime,EnumerateTime],'Labels',{'ART','GA','BBA'});
%boxplot([GATime,EnumerateTime]);


subplot(1,3,1);
boxplot(ARTNSTime,'Labels',{'ART-NS'});
ylabel('Compute Time/s');

subplot(1,3,2);
boxplot(FDMTime,'Labels',{'FDM'});
ylabel('Compute Time/s');

subplot(1,3,3);
boxplot(GATime,'Labels',{'GA'});
ylabel('Compute Time/s');

% subplot(2,2,4);
% boxplot(EnumerateTime,'Labels',{'BBA'});
% ylabel('Compute Time/s');

AverageARTTime = sum(ARTNSTime)/100
AverageFDMTime = sum(FDMTime)/100
AverageGATime = sum(GATime)/100
%AverageBBATime = sum(EnumerateTime)/100

%title('Compute Time/s')
%xlabel('Compute Time/s')
%ylabel('Compute Time/s');
%suptitle('Compute Time/s');
