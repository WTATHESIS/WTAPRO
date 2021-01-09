
load TargetWeight.mat
TargetValue = sum(TargetWeight);
figure(1);
axis equal

M6M1 = zeros(30,1);
M1M6 = zeros(30,1);
for i = 1 : 30
    
    FileName1 = ['MOEASizeFitnessRecord6',num2str(i),'.mat'];
    load(FileName1);
    temp1 = MOEASizeFitnessRecord;
    
    FileName2 = ['MOEASizeFitnessRecord1',num2str(i),'.mat'];
    load(FileName2);
    temp2 = MOEASizeFitnessRecord;
    
    [ M6M1(i,1), M1M6(i,1) ] = CoverageCalculate( temp1(:,100), temp2(:,100), TargetValue );
    
end
subplot(3,3,1);
boxplot([M6M1,M1M6],'Notch','on','Labels',{'I(M6,M1)','I(M1,M6)'});
%ylabel('Coverage');

M6M2 = zeros(30,1);
M2M6 = zeros(30,1);
for i = 1 : 30
    
    FileName1 = ['MOEASizeFitnessRecord6',num2str(i),'.mat'];
    load(FileName1);
    temp1 = MOEASizeFitnessRecord;
    
    FileName2 = ['MOEASizeFitnessRecord2',num2str(i),'.mat'];
    load(FileName2);
    temp2 = MOEASizeFitnessRecord;
    
    [ M6M2(i,1), M2M6(i,1) ] = CoverageCalculate( temp1(:,100), temp2(:,100), TargetValue );
    
end
subplot(3,3,2);
boxplot([M6M2,M2M6],'Notch','on','Labels',{'I(M6,M2)','I(M2,M6)'});
%ylabel('Coverage');

M6M3 = zeros(30,1);
M3M6 = zeros(30,1);
for i = 1 : 30
    
    FileName1 = ['MOEASizeFitnessRecord6',num2str(i),'.mat'];
    load(FileName1);
    temp1 = MOEASizeFitnessRecord;
    
    FileName2 = ['MOEASizeFitnessRecord3',num2str(i),'.mat'];
    load(FileName2);
    temp2 = MOEASizeFitnessRecord;
    
    [ M6M3(i,1), M3M6(i,1) ] = CoverageCalculate( temp1(:,100), temp2(:,100), TargetValue );
    
end
subplot(3,3,3);
boxplot([M6M3,M3M6],'Notch','on','Labels',{'I(M6,M3)','I(M3,M6)'});
%ylabel('Coverage');

M6M4 = zeros(30,1);
M4M6 = zeros(30,1);
for i = 1 : 30
    
    FileName1 = ['MOEASizeFitnessRecord6',num2str(i),'.mat'];
    load(FileName1);
    temp1 = MOEASizeFitnessRecord;
    
    FileName2 = ['MOEASizeFitnessRecord4',num2str(i),'.mat'];
    load(FileName2);
    temp2 = MOEASizeFitnessRecord;
    
    [ M6M4(i,1), M4M6(i,1) ] = CoverageCalculate( temp1(:,100), temp2(:,100), TargetValue );
    
end
subplot(3,3,4);
boxplot([M6M4,M4M6],'Notch','on','Labels',{'I(M6,M4)','I(M4,M6)'});
%ylabel('Coverage');

M6M5 = zeros(30,1);
M5M6 = zeros(30,1);
for i = 1 : 30
    
    FileName1 = ['MOEASizeFitnessRecord6',num2str(i),'.mat'];
    load(FileName1);
    temp1 = MOEASizeFitnessRecord;
    
    FileName2 = ['MOEASizeFitnessRecord5',num2str(i),'.mat'];
    load(FileName2);
    temp2 = MOEASizeFitnessRecord;
    
    [ M6M5(i,1), M5M6(i,1) ] = CoverageCalculate( temp1(:,100), temp2(:,100), TargetValue );
    
end
subplot(3,3,5);
boxplot([M6M5,M5M6],'Notch','on','Labels',{'I(M6,M5)','I(M5,M6)'});
%ylabel('Coverage');

M6M7 = zeros(30,1);
M7M6 = zeros(30,1);
for i = 1 : 30
    
    FileName1 = ['MOEASizeFitnessRecord6',num2str(i),'.mat'];
    load(FileName1);
    temp1 = MOEASizeFitnessRecord;
    
    FileName2 = ['MOEASizeFitnessRecord7',num2str(i),'.mat'];
    load(FileName2);
    temp2 = MOEASizeFitnessRecord;
    
    [ M6M7(i,1), M7M6(i,1) ] = CoverageCalculate( temp1(:,100), temp2(:,100), TargetValue );
    
end
subplot(3,3,6);
boxplot([M6M7,M7M6],'Notch','on','Labels',{'I(M6,M7)','I(M7,M6)'});
%ylabel('Coverage');

M6M8 = zeros(30,1);
M8M6 = zeros(30,1);
for i = 1 : 30
    
    FileName1 = ['MOEASizeFitnessRecord6',num2str(i),'.mat'];
    load(FileName1);
    temp1 = MOEASizeFitnessRecord;
    
    FileName2 = ['MOEASizeFitnessRecord8',num2str(i),'.mat'];
    load(FileName2);
    temp2 = MOEASizeFitnessRecord;
    
    [ M6M8(i,1), M8M6(i,1) ] = CoverageCalculate( temp1(:,100), temp2(:,100), TargetValue );
    
end
subplot(3,3,7);
boxplot([M6M8,M8M6],'Notch','on','Labels',{'I(M6,M8)','I(M8,M6)'});
%ylabel('Coverage');

M6M9 = zeros(30,1);
M9M6 = zeros(30,1);
for i = 1 : 30
    
    FileName1 = ['MOEASizeFitnessRecord6',num2str(i),'.mat'];
    load(FileName1);
    temp1 = MOEASizeFitnessRecord;
    
    FileName2 = ['MOEASizeFitnessRecord9',num2str(i),'.mat'];
    load(FileName2);
    temp2 = MOEASizeFitnessRecord;
    
    [ M6M9(i,1), M9M6(i,1) ] = CoverageCalculate( temp1(:,100), temp2(:,100), TargetValue );
    
end
subplot(3,3,8);
boxplot([M6M9,M9M6],'Notch','on','Labels',{'I(M6,M9)','I(M9,M6)'});
%ylabel('Coverage');

M6M10 = zeros(30,1);
M10M6 = zeros(30,1);
for i = 1 : 30
    
    FileName1 = ['MOEASizeFitnessRecord6',num2str(i),'.mat'];
    load(FileName1);
    temp1 = MOEASizeFitnessRecord;
    
    FileName2 = ['MOEASizeFitnessRecord10',num2str(i),'.mat'];
    load(FileName2);
    temp2 = MOEASizeFitnessRecord;
    
    [ M6M10(i,1), M10M6(i,1) ] = CoverageCalculate( temp1(:,100), temp2(:,100), TargetValue );
    
end
subplot(3,3,9);
boxplot([M6M10,M10M6],'Notch','on','Labels',{'I(M6,M10)','I(M10,M6)'});
%ylabel('Coverage');
File = [pwd,'/SizePlot/SCBP','.eps'];
print('-depsc',File);
