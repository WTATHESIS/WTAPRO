function [] = PlatformPlot(platformNumber,platformState,platformPosition,magnifyMultiple)
%INITIALPLATFORMPLOT 此处显示有关此函数的摘要
%   此处显示详细说明
platformText = {'I','II','III','IV','V','VI','VII','VIII'};
for platformIndex = 1 : platformNumber
    theta=0:pi/100:2*pi;
    z = platformPosition(platformIndex,3) * ones(1,length(theta));
    x = magnifyMultiple * cos(theta) + platformPosition(platformIndex,1);
    y = magnifyMultiple * sin(theta) + platformPosition(platformIndex,2);
    if platformState(platformIndex,1) == 1
        plot3(x,y,z,'-r');
        hold on
        fill(x,y,'r','EdgeColor','r');
        hold on
        text(platformPosition(platformIndex,1)+1000,platformPosition(platformIndex,2)-1000,platformPosition(platformIndex,3),platformText{platformIndex},'Color','red');
        hold on
    else
        plot3(x,y,z,'-k');
        hold on
        fill(x,y,'k','EdgeColor','k');
        hold on
        text(platformPosition(platformIndex,1)+1000,platformPosition(platformIndex,2)-1000,platformPosition(platformIndex,3),platformText{platformIndex},'Color','black');
        hold on
    end
end

end

