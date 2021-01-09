function [ Population  ] = FitnessCompute( WeaponNum , KillRange , SafeNum , SafePosition , TargetNum , TargetPosition , TargetWeight , SurviveThreshold , EnforceMatrix , PopSize , Population )
%FITNESSCOMPUTE 此处显示有关此函数的摘要
%   此处显示详细说明

for i = 1 : PopSize
    
    [ DecisionMatrix , KillPro ] = WTAMatrixGenerate( WeaponNum , Population(i).Position , KillRange , TargetNum , TargetPosition );
    
    [ Population(i).Fitness(1) , TargetSurvive ] = TargetKillProCompute( WeaponNum , TargetNum , TargetWeight , KillPro , DecisionMatrix );
    
    for j = 1 : WeaponNum
        if any(Population(i).Position(j,:)~=0)
            Population(i).Fitness(2) = Population(i).Fitness(2) + 1;
        end
    end
    
    [ Population(i).subCon ] = ConstraintViolation( WeaponNum , Population(i).Position , KillRange , SafeNum , SafePosition , TargetNum , TargetPosition , TargetSurvive , SurviveThreshold , EnforceMatrix );
    Population(i).Constraint = sum(Population(i).subCon);
    
end

end

