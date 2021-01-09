function [ NewOldIndividual ] = EugenicsOperator( OldIndividual , TargetWeight , KillPro , WeaponNum , TargetNum )
%EUGEN 此处显示有关此函数的摘要
%   此处显示详细说明

while(1)
    
    DecisionMatrix = DecisionVector2Matrix( OldIndividual , WeaponNum , TargetNum );
    
    TargetAssignedList = zeros(WeaponNum,TargetNum);
    AssignIndex = sum(DecisionMatrix);
    
    if prod(AssignIndex) ~= 0
        break;
    end
    
    for i = 1 : TargetNum
        if AssignIndex(1,i) == 0
            TargetAssignedList(:,i) = TargetWeight(1,i) .* KillPro(:,i);
        end
    end
    
    while(1)
        [MaxRow,MaxCol]=find(TargetAssignedList==max(TargetAssignedList(:)));
        if AssignIndex(1,OldIndividual(1,MaxRow)) > 1
            OldIndividual(1,MaxRow) = MaxCol;
            break;
        else
            TargetAssignedList(MaxRow,MaxCol) = 0;
        end
    end
    
end

NewOldIndividual = OldIndividual;

end
