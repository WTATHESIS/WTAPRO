
load TargetWeight.mat
TargetValue = sum(TargetWeight);

temp = ones(6,2);
seed = [100,100;
    0,-200];
MinMaxSet = temp * seed;

for m = 1 : 5
    for i = 1 : 30
        FileName = ['MOEANeighborFitnessRecord',num2str(m),num2str(i)];
        load(FileName);
        for j = 2 : 6
            temp = MOEANeighborFitnessRecord(j,100);
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

NeighborCM = zeros(30,5);
for m = 1 : 5
    for i = 1 : 30
        
        FileName = ['MOEANeighborFitnessRecord',num2str(m),num2str(i)];
        load(FileName);
        NeighborCM(i,m) = ConvergenceMetricCalculate( MOEANeighborFitnessRecord(:,100), MinMaxSet, TargetValue );
        
    end
end
figure(1);
boxplot(NeighborCM,'Notch','on','Labels',{'1','2','3','4','5'});
ylabel('Convergence metric');
File=[pwd,'/NeighborPlot/NCMBP.eps'];
print('-depsc',File)


NeighborMeanCM = zeros(5,100);
for m = 1 : 5
    for i = 1 : 30
        
        FileName = ['MOEANeighborFitnessRecord',num2str(m),num2str(i)];
        load(FileName);
        for j = 1 : 100
            NeighborMeanCM(m,j) = NeighborMeanCM(m,j) + ConvergenceMetricCalculate( MOEANeighborFitnessRecord(:,j), MinMaxSet, TargetValue );
        end
        
    end
end
NeighborMeanCM = NeighborMeanCM/30;

figure(2);

StartGen = 40;
RecHeight = [100,-100];
XBias = 0.2;
YBias = 0.1;

for i = 1 : 5
    
    plot(NeighborMeanCM(i,:),'LineWidth',1);
    hold on
    
    tempMin = min(NeighborMeanCM(i,StartGen:100));
    tempMax = max(NeighborMeanCM(i,StartGen:100));
    if tempMin < RecHeight(1)
        RecHeight(1) = tempMin;
    end
    if tempMax > RecHeight(2)
        RecHeight(2) = tempMax;
    end
    
end
xlabel('Generation');
ylabel('Convergence metric');
legend('1','2','3','4','5');

RecPos = [StartGen+XBias, RecHeight(1)-YBias, 100-StartGen-2*XBias, RecHeight(2)-RecHeight(1)+2*YBias];
rectangle('Position', RecPos, 'LineStyle', '--');
LocalPos = [0.27,0.42,0.5,0.48];
ArrowX = x_to_norm_v2(StartGen/2+50,LocalPos(1)+LocalPos(3)/2);
ArrowY = y_to_norm_v2(RecHeight(2),LocalPos(2)-0.04);
tempVar = [0.03 0.02 0.015 0.015 0.015];
ArrowY(1) = ArrowY(1) + tempVar(4);
annotation('arrow', ArrowX, ArrowY);

axes('Position', LocalPos);
for i = 1 : 5
%     FileName = ['MOEASizeMeanFitness',num2str(j)];
%     load(FileName);
    tempX = [StartGen:100];
    plot(tempX,NeighborMeanCM(i,StartGen:100),'LineWidth',1);
    xlim([StartGen,100]);
    hold on
end

File=[pwd,'/NeighborPlot/NMCM.eps'];
print('-depsc',File)



