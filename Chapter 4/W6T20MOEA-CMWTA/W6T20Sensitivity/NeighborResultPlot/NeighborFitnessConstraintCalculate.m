
load TargetWeight.mat
TargetValue = sum(TargetWeight);

for m = 1 : 5
    
    MOEANeighborMeanFitness = zeros(6,100);
    MOEANeighborMeanConstraint = zeros(6,100);
    MOEANeighborCount = zeros(6,100);
    
    for i = 1 : 30      
        FileName = ['MOEANeighborFitnessRecord',num2str(m),num2str(i)];
        load(FileName);
        FileName = ['MOEANeighborConstraintRecord',num2str(m),num2str(i)];
        load(FileName);
        for j = 1 : 100
            for k = 2 : 6
                if MOEANeighborFitnessRecord(k,j) ~= TargetValue
                    MOEANeighborCount(k,j) = MOEANeighborCount(k,j) + 1;
                    MOEANeighborMeanFitness(k,j) = MOEANeighborMeanFitness(k,j) + MOEANeighborFitnessRecord(k,j);
                    MOEANeighborMeanConstraint(k,j) = MOEANeighborMeanConstraint(k,j) + MOEANeighborConstraintRecord(k,j);
                end
            end
        end
    end
    
    MOEANeighborMeanFitness = MOEANeighborMeanFitness./MOEANeighborCount;
    MOEANeighborMeanConstraint = MOEANeighborMeanConstraint./MOEANeighborCount;
    
    FileName = ['MOEANeighborMeanFitness',num2str(m)];
    ValueName = ['MOEANeighborMeanFitness'];
    save(FileName,ValueName);
    
    FileName = ['MOEANeighborMeanConstraint',num2str(m)];
    ValueName = ['MOEANeighborMeanConstraint'];
    save(FileName,ValueName);
    
end

 for i = 2 : 6
     figure(i-1);
     StartGen = 40;
     RecHeight = [100,-100];
     XBias = 0.2;
     YBias = 0.04;
     
     for j = 1 : 5
         FileName = ['MOEANeighborMeanFitness',num2str(j)];
         load(FileName);
         plot(MOEANeighborMeanFitness(i,:),'LineWidth',1);
         hold on;
         
         tempMin = min(MOEANeighborMeanFitness(i,StartGen:100));
         tempMax = max(MOEANeighborMeanFitness(i,StartGen:100));
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
     legend('1','2','3','4','5');
     
     RecPos = [StartGen+XBias, RecHeight(1)-YBias, 100-StartGen-2*XBias, RecHeight(2)-RecHeight(1)+2*YBias];
     rectangle('Position', RecPos, 'LineStyle', '--');
		 LocalPos = [0.32,0.42,0.55,0.47];
     ArrowX = x_to_norm_v2(StartGen/2+50,LocalPos(1)+LocalPos(3)/2);
     ArrowY = y_to_norm_v2(RecHeight(2),LocalPos(2)-0.04);
     tempVar = [0.03 0.02 0.015 0.015 0.015];
     ArrowY(1) = ArrowY(1) + tempVar(i-1);
     annotation('arrow', ArrowX, ArrowY);
        
     axes('Position', LocalPos);
     for j = 1 : 5
         FileName = ['MOEANeighborMeanFitness',num2str(j)];
         load(FileName);
         tempX = [StartGen:100];
         plot(tempX,MOEANeighborMeanFitness(i,StartGen:100),'LineWidth',1);
         xlim([StartGen,100]);
         hold on
     end
     
     File = [pwd,'/NeighborPlot/NMF',num2str(i),'.eps'];
     print('-depsc',File)
     close
     
 end

for i = 2 : 6
    figure(5+i-1);
    StartGen = 1;
    RecHeight = [100,-100];
    XBias = 0.2;
    YBias = 0.04;
    
    for j = 1 : 5
        FileName = ['MOEANeighborMeanConstraint',num2str(j)];
        load(FileName);
        plot(MOEANeighborMeanConstraint(i,:),'LineWidth',1);
        hold on;
        
        tempMin = min(MOEANeighborMeanConstraint(i,StartGen:100));
        tempMax = max(MOEANeighborMeanConstraint(i,StartGen:100));
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
    legend('1','2','3','4','5');
    
    RecPos = [StartGen, RecHeight(1), 10-StartGen, RecHeight(2)-RecHeight(1)];
    rectangle('Position', RecPos, 'LineStyle', '--');
		LocalPos = [0.32,0.42,0.55,0.47];
    ArrowX = x_to_norm_v2(10,LocalPos(1)+LocalPos(3)/2);
    ArrowY = y_to_norm_v2(RecHeight(2)/10,LocalPos(2)-0.04);
    tempVar = [0.03 0.02 0.015 0.015 0.015];
    ArrowX(1) = ArrowX(1) + tempVar(4);
    annotation('arrow', ArrowX, ArrowY);
       
    axes('Position', LocalPos);
    for j = 1 : 5
        FileName = ['MOEANeighborMeanConstraint',num2str(j)];
        load(FileName);
        tempX = [StartGen:10];
        plot(tempX,MOEANeighborMeanConstraint(i,StartGen:10),'LineWidth',1);
        xlim([StartGen,10]);
        hold on
    end
    
    File = [pwd,'/NeighborPlot/NMCV',num2str(i),'.eps'];
    print('-depsc',File)
    close
    
end

