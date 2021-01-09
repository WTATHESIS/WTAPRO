function [ EP ] = EPUpdate( EP , Individual , epsilon , GenCount )
%EPUPDATE �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��

EPNum = numel(EP);
DominatedFlag = 0;

i = 1;
while i <= EPNum
    if EP(i).Constraint <= epsilon(GenCount) && Individual.Constraint <= epsilon(GenCount)
        if all( EP(i).Fitness <= Individual.Fitness ) && any( EP(i).Fitness < Individual.Fitness )
            DominatedFlag = 1;
        elseif all( EP(i).Fitness >= Individual.Fitness )
            EP(i) = [];
            EPNum = EPNum - 1;
        end
    elseif EP(i).Constraint == Individual.Constraint
        if all( EP(i).Fitness <= Individual.Fitness ) && any( EP(i).Fitness < Individual.Fitness )
            DominatedFlag = 1;
        elseif all( EP(i).Fitness >= Individual.Fitness )
            EP(i) = [];
            EPNum = EPNum - 1;
        end
    elseif EP(i).Constraint < Individual.Constraint
        DominatedFlag = 1;
    elseif EP(i).Constraint > Individual.Constraint
        EP(i) = [];
        EPNum = EPNum - 1;
    end
    
    i = i + 1;
end

if DominatedFlag == 0
    EP = [ EP ; Individual ];
end

end

