function [targetPosition,thetaT,phiT] = TargetStateUpdate(targetNumber,targetState,targetPosition,thetaT,phiT,XT,ZT,YT,CIT,FAI)
%TARGETSTATEUPDATE �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
%% ����Ŀ��λ�á��Ƕ�
for targetIndex = 1 : targetNumber
    if targetState(1,targetIndex) == 1
        targetPosition(targetIndex,:) = [ XT{targetIndex,1}(1,end) YT{targetIndex,1}(1,end) ZT{targetIndex,1}(1,end) ];
        thetaT(targetIndex,:) = pi - CIT{targetIndex,1}(1,end);
        phiT(targetIndex,:) = FAI{targetIndex,1}(1,end);
    else
        targetPosition(targetIndex,:) = NaN;
        thetaT(targetIndex,:) = NaN;
        phiT(targetIndex,:) = NaN;
    end
end
end

