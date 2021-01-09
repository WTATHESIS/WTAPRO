function [] = IrradiatePlot(sensorNumber,optimalSolution,platformPosition,irradiatePosition)
%IRRADIATEPLOT 此处显示有关此函数的摘要
%   此处显示详细说明
%% 照射示意图

for sensorIndex = 1 : sensorNumber
    targetLabel = optimalSolution.IISensorCode(1,sensorIndex);
    if targetLabel ~= 0
        plot3( [platformPosition(sensorIndex,1) irradiatePosition(targetLabel,1)], [platformPosition(sensorIndex,2) irradiatePosition(targetLabel,2)],[platformPosition(sensorIndex,3) irradiatePosition(targetLabel,3)], 'g' );
        hold on
    end
end

end

