function [maxtarind,maxassind] = target_attacked_define(tarnum,weatarsta,tarasseff)
%TARGET_ATTACKED_DEFINE 此处显示有关此函数的摘要
%   此处显示详细说明
temp = tarasseff;
for i = 1 : tarnum
    if all(weatarsta(:,i)==0)
        temp(i,:) = 0;
    end
end
[maxtarind,maxassind] = find(temp==max(max(temp)));    % 确定待攻击目标
end

