
load TargetWeight.mat

for m = 1 : 5
    for i = 1 : 30
        
        MOEANeighborFitnessRecord = ones(6,100)*sum(TargetWeight);
        MOEANeighborConstraintRecord = ones(6,100)*100;
        FileName = ['NeighborFitnessRecord',num2str(m),num2str(i)];
        load(FileName);
        
        for j = 2 : 6
            for k = 1 : 100
                MOEANeighborFitnessRecord(j,k) = NeighborFitnessRecord{k,j}.Fitness(1,1);
                MOEANeighborConstraintRecord(j,k) = NeighborFitnessRecord{k,j}.Constraint;
            end
        end
        
        FileName = ['MOEANeighborFitnessRecord',num2str(m),int2str(i),'.mat'];
        ValueName = ['MOEANeighborFitnessRecord'];
        save(FileName,ValueName);
        
        FileName = ['MOEANeighborConstraintRecord',num2str(m),int2str(i),'.mat'];
        ValueName = ['MOEANeighborConstraintRecord'];
        save(FileName,ValueName);
        
    end
end