
load TargetPosition.mat
load TargetWeight.mat
load SafePosition.mat
load KillRange.mat
load SurviveThreshold.mat
load EnforceMatrix.mat
[ EnforceWeaponIndex , EnforceTargetIndex ] = find(EnforceMatrix==1);

sTarget = size(TargetPosition);
TargetNum = sTarget(1);
sSafe = size(SafePosition);
SafeNum = sSafe(1);
WeaponNum = 6;
Generation = 100;

ColorSet = cell(1,6);
ColorSet{1} = [0.00,0.45,0.74]; %NSGA2_SP_
ColorSet{2} = [0.85,0.33,0.10]; %NSGA2
ColorSet{3} = [0.93,0.69,0.13]; %SPEA2
ColorSet{4} = [0.49,0.18,0.56]; %NSGA2_SP_D
ColorSet{5} = [0.47,0.67,0.19]; %NSGA2_SP_D
ColorSet{6} = [0.30,0.75,0.93]; %NSGA2_SP_D
Str = ["I","II","III","IV","V","VI"];

OptimalSolution = cell(1,6);
for i = 1 : 30
    
    FileName = ['NSGA2_SP_OptimalSolution',num2str(i)];
    load(FileName);
    SolNum = numel(NSGA2_SP_OptimalSolution);
    
    for j = 1 : SolNum
        k = NSGA2_SP_OptimalSolution(j).Fitness(1,2);
        if isempty(OptimalSolution{1,k})
            OptimalSolution{1,k} = NSGA2_SP_OptimalSolution(j,1);
        elseif all(OptimalSolution{1,k}.Fitness>=NSGA2_SP_OptimalSolution(j,1).Fitness) && OptimalSolution{1,k}.Constraint>=NSGA2_SP_OptimalSolution(j,1).Constraint
            OptimalSolution{1,k} = NSGA2_SP_OptimalSolution(j,1);
        end
    end
    
end

for i = 2 : WeaponNum
    
    PlanPlot(OptimalSolution,WeaponNum,KillRange,TargetNum,TargetWeight,TargetPosition,SafePosition,EnforceWeaponIndex,EnforceTargetIndex,Str , ColorSet,i)
    %File = ['/Users/zhangkai/Programs/Access Program/IEEEEProgram0729/FourAlgorithms/SketchMap/NSGA2W',num2str(i),'.png'];
    %saveas(gcf,File);
    %close;
    
end


