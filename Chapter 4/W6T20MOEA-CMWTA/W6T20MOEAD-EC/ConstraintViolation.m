function [ Constraint ] = ConstraintViolation( WeaponNum , WeaponPosition , KillRange , SafeNum , SafePosition , TargetNum , TargetPosition , TargetSurvive , SurviveThreshold , EnforceMatrix )
%CONSTRAINTVIOLATION 此处显示有关此函数的摘要
%   此处显示详细说明

Constraint = 0;

SafeConstraint = 0;
%% 安全目标约束
for j =  1 : SafeNum
    for k = 1 : WeaponNum
        if any(WeaponPosition(k,:)~=0)
            SafeDis = sqrt(( SafePosition(j,1) - WeaponPosition(k,1) ).^2 + ( SafePosition(j,2) - WeaponPosition(k,2) ).^2);
            if SafeDis < KillRange(1,k)
                SafeConstraint = SafeConstraint + ( KillRange(1,k) - SafeDis )/KillRange(1,k);
            end
        end
    end
end
Constraint = Constraint + SafeConstraint;

%% 门限值约束
ThresholdConstraint = 0;
for j = 1 : TargetNum
    if TargetSurvive(1,j) > SurviveThreshold(1,j)
        ThresholdConstraint = ThresholdConstraint + ( TargetSurvive(1,j) - SurviveThreshold(1,j) )/( exp(-1) - SurviveThreshold(1,j) );
    end
end
Constraint = Constraint + ThresholdConstraint;

%% 分配偏好约束
PreferConstraint = 0;
[ EnforceWeaponIndex , EnforceTargetIndex ] = find(EnforceMatrix==1);
PreferDis = sqrt(( TargetPosition(EnforceTargetIndex,1) - WeaponPosition(EnforceWeaponIndex,1) ).^2 + ( TargetPosition(EnforceTargetIndex,2) - WeaponPosition(EnforceWeaponIndex,2) ).^2);
tempDisM = [ TargetPosition(EnforceTargetIndex,1) ; 20-TargetPosition(EnforceTargetIndex,1) ; TargetPosition(EnforceTargetIndex,2) ; 20-TargetPosition(EnforceTargetIndex,2) ];
DisM = max(tempDisM);
if PreferDis > KillRange(1,EnforceWeaponIndex)
    PreferConstraint = PreferConstraint + ( PreferDis - KillRange(1,EnforceWeaponIndex) ) / ( DisM - KillRange(1,EnforceWeaponIndex) );
end
Constraint = Constraint + PreferConstraint;

end

