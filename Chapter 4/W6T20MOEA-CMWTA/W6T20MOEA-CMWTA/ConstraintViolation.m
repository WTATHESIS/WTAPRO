function [ Constraint ] = ConstraintViolation( WeaponNum , WeaponPosition , KillRange , SafeNum , SafePosition , TargetNum , TargetPosition , TargetSurvive , SurviveThreshold , EnforceMatrix )
%CONSTRAINTVIOLATION �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��

Constraint = 0;

SafeConstraint = 0;
%% ��ȫĿ��Լ��
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
% if SafeConstraint > 1
%     1
% end
Constraint = Constraint + SafeConstraint;

%% ����ֵԼ��
ThresholdConstraint = 0;
for j = 1 : TargetNum
    if TargetSurvive(1,j) > SurviveThreshold(1,j)
        ThresholdConstraint = ThresholdConstraint + ( TargetSurvive(1,j) - SurviveThreshold(1,j) )/( exp(-1) - SurviveThreshold(1,j) );
    end
end
% for j = 1 : TargetNum
%     if TargetSurvive(1,j) > SurviveThreshold(1,j)
%         ThresholdDis = zeros(WeaponNum,1);
%         for k = 1 : WeaponNum
%             ThresholdDis(k,1) = sqrt(( TargetPosition(j,1) - WeaponPosition(k,1) ).^2 + ( TargetPosition(j,2) - WeaponPosition(k,2) ).^2);
%         end
%         ThresholdDis = sort(ThresholdDis);
%         ThresholdConstraint = ThresholdConstraint + ThresholdDis(1,1) + ThresholdDis(2,1);
%     end
% end
% if ThresholdConstraint > 1
%     2
% end
Constraint = Constraint + ThresholdConstraint;

% ThresholdConstraint = - sum(min(SurviveThreshold - TargetSurvive));
% Constraint = Constraint + ThresholdConstraint;

%% ����ƫ��Լ��
PreferConstraint = 0;
[ EnforceWeaponIndex , EnforceTargetIndex ] = find(EnforceMatrix==1);
PreferDis = sqrt(( TargetPosition(EnforceTargetIndex,1) - WeaponPosition(EnforceWeaponIndex,1) ).^2 + ( TargetPosition(EnforceTargetIndex,2) - WeaponPosition(EnforceWeaponIndex,2) ).^2);
tempDisM = [ TargetPosition(EnforceTargetIndex,1) ; 20-TargetPosition(EnforceTargetIndex,1) ; TargetPosition(EnforceTargetIndex,2) ; 20-TargetPosition(EnforceTargetIndex,2) ];
DisM = max(tempDisM);
if PreferDis > KillRange(1,EnforceWeaponIndex)
    PreferConstraint = PreferConstraint + ( PreferDis - KillRange(1,EnforceWeaponIndex) ) / ( DisM - KillRange(1,EnforceWeaponIndex) );
end
% if PreferConstraint > 1
%     3
% end
Constraint = Constraint + PreferConstraint;

end

