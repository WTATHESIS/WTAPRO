function [nondomind] = nondominated_index(weanum,weaeff,weaeffstd,sollen)
%NONDOMINATED_INDEX 此处显示有关此函数的摘要
%   此处显示详细说明

nondomflag = ones(weanum,1);
for i = 1 : weanum-1
    for j = i+1 : weanum
        if weaeff(i,1)<weaeff(j,1) && weaeffstd(i,1)<weaeffstd(j,1)
            nondomflag(i,1) = 0;
        elseif weaeff(i,1)>weaeff(j,1) && weaeffstd(i,1)>weaeffstd(j,1)
            nondomflag(j,1) = 0;
        end
    end
end

nondomind = find(nondomflag(:,1)==1);
nondomsum = sum(nondomflag);
if nondomsum > 1
    [~,temp] = sort(weaeff(nondomind),'descend');
    nondomind = nondomind(temp);
    %nondomkill = weakill(nondomind);
    if nondomsum > sollen
        nondomind = nondomind(1:sollen,1);
    end
end






