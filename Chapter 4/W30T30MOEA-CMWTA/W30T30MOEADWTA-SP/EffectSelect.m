function [ tempPop , tempPopNum ] = EffectSelect( WeaponNum , Pop , PopSize , EffectSize )
%RESIZE 此处显示有关此函数的摘要
%   此处显示详细说明

tempPop = cell(PopSize,WeaponNum);
tempPopSize = 0;
SubIndex = ones(1,WeaponNum);

while (tempPopSize<EffectSize)
    
    tempF = cell(1,WeaponNum);
    for k = 1 : WeaponNum
        tempF{1,k} = Pop{SubIndex(1,k),k};
    end
    
    for i = WeaponNum : -1 : 1
        
        if isempty(tempF{1,i})
            continue;
        end
       
        tempPop{SubIndex(1,i),i} = tempF{1,i};
        SubIndex(1,i) = SubIndex(1,i) + 1;
        tempPopSize = tempPopSize + 1;
        if tempPopSize == EffectSize
            break;
        end
        
    end
    
end

%Pop = tempPop;
tempPopNum = SubIndex - ones(1,WeaponNum);

end

