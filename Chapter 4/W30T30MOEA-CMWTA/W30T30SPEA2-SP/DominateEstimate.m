function [ DominateLogic ] = DominateEstimate( i , j , FitMat )
%DOMINATES �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��

if all(FitMat(i,:) <= FitMat(j,:)) && any(FitMat(i,:) < FitMat(j,:))
    DominateLogic = true;
else
    DominateLogic = false;
end

end

