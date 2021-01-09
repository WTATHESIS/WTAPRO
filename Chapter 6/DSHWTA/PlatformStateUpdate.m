function [platformState,weaponState,thetaM,phiM] = PlatformStateUpdate(optimalSolution,platformNumber,platformPosition,platformState,weaponState,thetaM,phiM)
%PLATFORMUPDATE �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��

%% ����ƽ̨����������״̬
for platformIndex = 1 : platformNumber
    targetLabel = optimalSolution.IIPlatformCode(1,platformIndex);
    weaponLabel = optimalSolution.IIIPlatformComplement(1,platformIndex);
    if targetLabel ~= 0 && weaponLabel ~= 0
        weaponState(platformIndex,1,weaponLabel) = 0;
        thetaM(platformIndex,1,weaponLabel) = NaN;
        phiM(platformIndex,1,weaponLabel) = NaN;
    end
    temp = abs(weaponState);
    if all(temp(platformIndex,1,:)==0,'all')
%         platformPosition(platformIndex,:) = 0;
        platformState(platformIndex,:) = 0;
    end
end

end

