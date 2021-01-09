
load TargetWeight.mat

for m = 1 : 10
    for i = 1 : 30
        
        MOEASizeFitnessRecord = ones(6,100)*sum(TargetWeight);
        MOEASizeConstraintRecord = ones(6,100)*100;
        FileName = ['SizeFitnessRecord',num2str(m),num2str(i)];
        load(FileName);
        
        for j = 2 : 6
            for k = 1 : 100
                MOEASizeFitnessRecord(j,k) = SizeFitnessRecord{k,j}.Fitness(1,1);
                MOEASizeConstraintRecord(j,k) = SizeFitnessRecord{k,j}.Constraint;
            end
        end
        
        FileName = ['MOEASizeFitnessRecord',num2str(m),int2str(i),'.mat'];
        ValueName = ['MOEASizeFitnessRecord'];
        save(FileName,ValueName);
        
        FileName = ['MOEASizeConstraintRecord',num2str(m),int2str(i),'.mat'];
        ValueName = ['MOEASizeConstraintRecord'];
        save(FileName,ValueName);
        
    end
end