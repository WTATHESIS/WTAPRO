function [ Neighbor ] = NeighborIndex( WeaponNum, NeighborNum )
%NEIGHBORINDEX �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��

Neighbor = cell(1,WeaponNum);
for i = 1 : WeaponNum
    
    if i-ceil(NeighborNum/2)<=0
        Neighbor{1,i} = [1:1:NeighborNum+1];
    elseif i+floor(NeighborNum/2)>WeaponNum
        Neighbor{1,i} = [WeaponNum-NeighborNum:1:WeaponNum];
    else
        Neighbor{1,i} = [i-ceil(NeighborNum/2):1:i+floor(NeighborNum/2)];
    end
    
end

end

