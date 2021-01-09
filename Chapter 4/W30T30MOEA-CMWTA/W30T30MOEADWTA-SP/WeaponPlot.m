function [ output_args ] = WeaponPlot( WeaponPosition , KillRange , WeaponNum )
%WEAPONPLOT �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��

theta=0:0.001*pi:2*pi;
for j = 1 : WeaponNum
    x=KillRange(1,j)*cos(theta);
    y=KillRange(1,j)*sin(theta);
    if WeaponPosition(j,:) ~= 0
        xw = WeaponPosition(j,1) + x;
        yw = WeaponPosition(j,2) + y;
        if j == 1
            plot(xw,yw,'k');
            str = '��';
            text(WeaponPosition(j,1)+0.3,WeaponPosition(j,2),str);
            hold on;
        elseif j == 2
            plot(xw,yw,'c');
            str = '��';
            text(WeaponPosition(j,1)+0.3,WeaponPosition(j,2),str);
            hold on;
        elseif j == 3
            plot(xw,yw,'b');
            str = '��';
            text(WeaponPosition(j,1)+0.3,WeaponPosition(j,2),str);
            hold on;
        elseif j == 4
            plot(xw,yw,'r');
            str = '��';
            text(WeaponPosition(j,1)+0.3,WeaponPosition(j,2),str);
            hold on;
        elseif j == 5
            plot(xw,yw,'m');
            str = '��';
            text(WeaponPosition(j,1)+0.3,WeaponPosition(j,2),str);
            hold on;
        else
            plot(xw,yw,'g');
            str = '��';
            text(WeaponPosition(j,1)+0.3,WeaponPosition(j,2),str);
            hold on;
        end
    end
end

end

