
load TargetWeight.mat
TargetValue = sum(TargetWeight);

temp = ones(6,2);
seed = [100,100;
    0,-200];
MinMaxSet = temp * seed;

for m = 1 : 10
    for i = 1 : 30
        FileName = ['MOEASizeFitnessRecord',num2str(m),num2str(i)];
        load(FileName);
        for j = 2 : 6
            temp = MOEASizeFitnessRecord(j,100);
            if temp ~= TargetValue
                if temp < MinMaxSet(j,1)
                    MinMaxSet(j,1) = temp;
                end
                if temp > MinMaxSet(j,2)
                    MinMaxSet(j,2) = temp;
                end
            end
        end
    end
end

SizeCM = zeros(30,10);
for m = 1 : 10
    for i = 1 : 30
        
        FileName = ['MOEASizeFitnessRecord',num2str(m),num2str(i)];
        load(FileName);
        SizeCM(i,m) = ConvergenceMetricCalculate( MOEASizeFitnessRecord(:,100), MinMaxSet, TargetValue );
        
    end
end
figure(1);
boxplot(SizeCM,'Notch','on','Labels',{'10%','20%','30%','40%','50%','60%','70%','80%','90%','100%'});
ylabel('Convergence metric');

FP = [pwd,'/SizePlot/SCMBP','.eps'];
print('-depsc',FP)

SizeMeanCM = zeros(10,100);
for m = 1 : 10
    for i = 1 : 30
        
        FileName = ['MOEASizeFitnessRecord',num2str(m),num2str(i)];
        load(FileName);
        for j = 1 : 100
            SizeMeanCM(m,j) = SizeMeanCM(m,j) + ConvergenceMetricCalculate( MOEASizeFitnessRecord(:,j), MinMaxSet, TargetValue );
        end
        
    end
end
SizeMeanCM = SizeMeanCM/30;

C = linspecer(10);
figure(2);

StartGen = 40;
RecHeight = [100,-100];
XBias = 0.2;
YBias = 0.04;

for i = 1 : 10
    
    plot(SizeMeanCM(i,:),'LineWidth',1,'Color',C(i,:));
    hold on
    
    tempMin = min(SizeMeanCM(i,StartGen:100));
    tempMax = max(SizeMeanCM(i,StartGen:100));
    if tempMin < RecHeight(1)
        RecHeight(1) = tempMin;
    end
    if tempMax > RecHeight(2)
        RecHeight(2) = tempMax;
    end
    
end
xlabel('Generation');
ylabel('Convergence metric');
legend('10%','20%','30%','40%','50%','60%','70%','80%','90%','100%');

RecPos = [StartGen+XBias, RecHeight(1)-YBias, 100-StartGen-2*XBias, RecHeight(2)-RecHeight(1)+2*YBias];
rectangle('Position', RecPos, 'LineStyle', '--');
LocalPos = [0.28,0.42,0.45,0.48];
ArrowX = x_to_norm_v2(StartGen/2+50,LocalPos(1)+LocalPos(3)/2);
ArrowY = y_to_norm_v2(RecHeight(2),LocalPos(2)-0.04);
tempVar = [0.03 0.02 0.015 0.015 0.015];
ArrowY(1) = ArrowY(1) + tempVar(4);
annotation('arrow', ArrowX, ArrowY);

axes('Position', LocalPos);
for i = 1 : 10
%     FileName = ['MOEASizeMeanFitness',num2str(j)];
%     load(FileName);
    tempX = [StartGen:100];
    plot(tempX,SizeMeanCM(i,StartGen:100),'LineWidth',1,'Color',C(i,:));
    xlim([StartGen,100]);
    hold on
end

FP = [pwd,'/SizePlot/SMCM','.eps'];
print('-depsc',FP)
