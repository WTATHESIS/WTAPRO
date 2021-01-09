function [ output_args ] = WeaponPlot( WeaponPosition , KillRange , WeaponNum )
%WEAPONPLOT 此处显示有关此函数的摘要
%   此处显示详细说明

theta=0:0.001*pi:2*pi;
for j = 1 : WeaponNum
    x=KillRange(1,j)*cos(theta);
    y=KillRange(1,j)*sin(theta);
    if WeaponPosition(j,:) ~= 0
        xw = WeaponPosition(j,1) + x;
        yw = WeaponPosition(j,2) + y;
        if j == 1
            plot(xw,yw,'k');
            str = 'Ⅰ';
            text(WeaponPosition(j,1)+0.3,WeaponPosition(j,2),str);
            hold on;
        elseif j == 2
            plot(xw,yw,'c');
            str = 'Ⅱ';
            text(WeaponPosition(j,1)+0.3,WeaponPosition(j,2),str);
            hold on;
        elseif j == 3
            plot(xw,yw,'b');
            str = 'Ⅲ';
            text(WeaponPosition(j,1)+0.3,WeaponPosition(j,2),str);
            hold on;
        elseif j == 4
            plot(xw,yw,'r');
            str = 'Ⅳ';
            text(WeaponPosition(j,1)+0.3,WeaponPosition(j,2),str);
            hold on;
        elseif j == 5
            plot(xw,yw,'m');
            str = 'Ⅴ';
            text(WeaponPosition(j,1)+0.3,WeaponPosition(j,2),str);
            hold on;
        else
            plot(xw,yw,'g');
            str = 'Ⅵ';
            text(WeaponPosition(j,1)+0.3,WeaponPosition(j,2),str);
            hold on;
        end
    end
end

end

