function [ Coverage12, Coverage21 ] = CoverageCalculate( Set1, Set2 , TargetValue )
%COVERAGE 此处显示有关此函数的摘要
%   此处显示详细说明

Set1Num = sum(Set1~=TargetValue);
if Set1Num ~= 5
    
end
Set2Num = sum(Set2~=TargetValue);
if Set2Num ~= 5
    
end

Coverage12 = 0;
for i = 2 : 6
    if Set2(i,1) ~= TargetValue
        for j = 2 : 6
            if Set1(j,1) ~= TargetValue
                if Set2(i,1) >= Set1(j,1) && i >= j
                    Coverage12 = Coverage12 + 1;
                    break;
                end
            end
        end
    end
end
Coverage12 = Coverage12/Set2Num;

Coverage21 = 0;
for i = 2 : 6
    if Set1(i,1) ~= TargetValue
        for j = 2 : 6
            if Set2(j,1) ~= TargetValue
                if Set1(i,1) >= Set2(j,1) && i >= j
                    Coverage21 = Coverage21 + 1;
                    break;
                end
            end
        end
    end
end
Coverage21 = Coverage21/Set1Num;

end

