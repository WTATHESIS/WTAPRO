
load TargetWeight.mat
TargetValue = sum(TargetWeight);

for m = 1 : 10
    
    MOEASizeMeanFitness = zeros(6,100);
    MOEASizeMeanConstraint = zeros(6,100);
    MOEASizeCount = zeros(6,100);
    
    for i = 1 : 30
        FileName = ['MOEASizeFitnessRecord',num2str(m),num2str(i)];
        load(FileName);
        FileName = ['MOEASizeConstraintRecord',num2str(m),num2str(i)];
        load(FileName);
        for j = 1 : 100
            for k = 2 : 6
                if MOEASizeFitnessRecord(k,j) ~= TargetValue
                    MOEASizeCount(k,j) = MOEASizeCount(k,j) + 1;
                    MOEASizeMeanFitness(k,j) = MOEASizeMeanFitness(k,j) + MOEASizeFitnessRecord(k,j);
                    MOEASizeMeanConstraint(k,j) = MOEASizeMeanConstraint(k,j) + MOEASizeConstraintRecord(k,j);
                end
            end
        end
    end
    
    MOEASizeMeanFitness = MOEASizeMeanFitness./MOEASizeCount;
    MOEASizeMeanConstraint = MOEASizeMeanConstraint./MOEASizeCount;
    
    FileName = ['MOEASizeMeanFitness',num2str(m)];
    ValueName = ['MOEASizeMeanFitness'];
    save(FileName,ValueName);
    
    FileName = ['MOEASizeMeanConstraint',num2str(m)];
    ValueName = ['MOEASizeMeanConstraint'];
    save(FileName,ValueName);
    
end

C = linspecer(10);

for i = 2 : 6
    figure(i-1);
    StartGen = 30;
    RecHeight = [100,-100];
    XBias = 0.2;
    YBias = 0.04;
    
    for j = 1 : 10
        FileName = ['MOEASizeMeanFitness',num2str(j)];
        load(FileName);
        plot(MOEASizeMeanFitness(i,:),'LineWidth',1,'Color',C(j,:));
        hold on;
        
        tempMin = min(MOEASizeMeanFitness(i,StartGen:100));
        tempMax = max(MOEASizeMeanFitness(i,StartGen:100));
        if tempMin < RecHeight(1)
            RecHeight(1) = tempMin;
        end
        if tempMax > RecHeight(2)
            RecHeight(2) = tempMax;
        end  
    end
    
    tempStr = ['Fitness/f_2=',int2str(i)];
    ylabel(tempStr);
    xlabel('Generation');
    legend('10%','20%','30%','40%','50%','60%','70%','80%','90%','100%');
    
    RecPos = [StartGen+XBias, RecHeight(1)-YBias, 100-StartGen-2*XBias, RecHeight(2)-RecHeight(1)+2*YBias];
    rectangle('Position', RecPos, 'LineStyle', '--');
    LocalPos = [0.32,0.42,0.55,0.47];
    ArrowX = x_to_norm_v2(StartGen/2+50,LocalPos(1)+LocalPos(3)/2);
    ArrowY = y_to_norm_v2(RecHeight(2),LocalPos(2)-0.04);
    tempVar = [0.03 0.02 0.015 0.015 0.015];
    ArrowY(1) = ArrowY(1) + tempVar(i-1);
    annotation('arrow', ArrowX, ArrowY);
       
    axes('Position', LocalPos);
    for j = 1 : 10
        FileName = ['MOEASizeMeanFitness',num2str(j)];
        load(FileName);
        tempX = [StartGen:100];
        plot(tempX,MOEASizeMeanFitness(i,StartGen:100),'LineWidth',1,'Color',C(j,:));
        xlim([StartGen,100]);
        hold on
    end
    
    File = [pwd,'/SizePlot/SMF',num2str(i),'.eps'];
    print('-depsc',File);
    close
    
end

for i = 2 : 6
    figure(5+i-1);
    StartGen = 1;
    RecHeight = [100,-100];
    XBias = 0.2;
    YBias = 0.04;
    
    for j = 1 : 10
        FileName = ['MOEASizeMeanConstraint',num2str(j)];
        load(FileName);
        plot(MOEASizeMeanConstraint(i,:),'LineWidth',1,'Color',C(j,:));
        hold on;
        
        tempMin = min(MOEASizeMeanConstraint(i,StartGen:100));
        tempMax = max(MOEASizeMeanConstraint(i,StartGen:100));
        if tempMin < RecHeight(1)
            RecHeight(1) = tempMin;
        end
        if tempMax > RecHeight(2)
            RecHeight(2) = tempMax;
        end  
    end
    
    tempStr = ['Constraint Violation/f_2=',int2str(i)];
    ylabel(tempStr);
    xlabel('Generation');
    %legend('10%','20%','30%','40%','50%','60%','70%','80%','90%','100%');
    
    RecPos = [StartGen, RecHeight(1), 10-StartGen, RecHeight(2)-RecHeight(1)];
    rectangle('Position', RecPos, 'LineStyle', '--');
    LocalPos = [0.32,0.42,0.55,0.47];
    ArrowX = x_to_norm_v2(10,LocalPos(1)+LocalPos(3)/2);
    ArrowY = y_to_norm_v2(RecHeight(2)/10,LocalPos(2)-0.04);
    tempVar = [0.03 0.02 0.015 0.015 0.015];
    ArrowX(1) = ArrowX(1) + tempVar(4);
    annotation('arrow', ArrowX, ArrowY);
       
    axes('Position', LocalPos);
    for j = 1 : 10
        FileName = ['MOEASizeMeanConstraint',num2str(j)];
        load(FileName);
        tempX = [StartGen:10];
        plot(tempX,MOEASizeMeanConstraint(i,StartGen:10),'LineWidth',1,'Color',C(j,:));
        xlim([StartGen,10]);
        hold on
    end
    
    File = [pwd,'/SizePlot/SMCV',num2str(i),'.eps'];
    print('-depsc',File);
    close
    
end

