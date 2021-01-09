function [ ] = WeaponPlot( WeaponPosition , KillRange , WeaponNum , Str , ColorSet )
%WEAPONPLOT 此处显示有关此函数的摘要
%   此处显示详细说明

theta=0:0.001*pi:2*pi;
for j = 1 : WeaponNum
    x=KillRange(1,j)*cos(theta);
    y=KillRange(1,j)*sin(theta);
    if WeaponPosition(j,:) ~= 0
        xw = WeaponPosition(j,1) + x;
        yw = WeaponPosition(j,2) + y;
        plot(xw,yw,'LineWidth',1,'Color',ColorSet{j});
        text(WeaponPosition(j,1)+0.3,WeaponPosition(j,2),Str{j});
        hold on;
    end
end

end

