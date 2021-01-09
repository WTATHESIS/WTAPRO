function [] = WeaponTrajectoryPlot(optimalSolution,platformNumber,platformNull,XM,YM,ZM,FAIM,CITM,magnifyMultiple)
%UNTITLED 此处显示有关此函数的摘要
%   此处显示详细说明
%% 武器轨迹

for platformIndex = 1 : platformNumber
    if ~isempty(XM{platformIndex,1})
        plot3(XM{platformIndex,1},YM{platformIndex,1},ZM{platformIndex,1},'r');
        hold on
        if platformNull(1,platformIndex) == 1
            WeaponPlot(magnifyMultiple,XM{platformIndex,1}(1,end),YM{platformIndex,1}(1,end),ZM{platformIndex,1}(1,end),FAIM{platformIndex,1}(1,end),CITM{platformIndex,1}(1,end),0,'black');
            weaponLabel = optimalSolution.IIIPlatformComplement(1,platformIndex);
            text(XM{platformIndex,1}(1,end)+1000,YM{platformIndex,1}(1,end)-1000,ZM{platformIndex,1}(1,end),num2str(weaponLabel),'Color','black');
            hold on
        else
            WeaponPlot(magnifyMultiple,XM{platformIndex,1}(1,end),YM{platformIndex,1}(1,end),ZM{platformIndex,1}(1,end),FAIM{platformIndex,1}(1,end),CITM{platformIndex,1}(1,end),0,'red');
            weaponLabel = optimalSolution.IIIPlatformComplement(1,platformIndex);
            text(XM{platformIndex,1}(1,end)+1000,YM{platformIndex,1}(1,end)-1000,ZM{platformIndex,1}(1,end),num2str(weaponLabel),'Color','red');
            hold on
        end
    end
end

end

