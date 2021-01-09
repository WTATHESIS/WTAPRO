function [ TargetWeight, KillPro ] = WTAIntialization( MaxKillPro, MaxKillRange, BellWidth, RMax, r, TargetNum, WeaponNum )
%UNTITLED �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��

TargetWeight = zeros( 1 , TargetNum );
KillPro = zeros( WeaponNum , TargetNum );
for t = 1 : TargetNum
    TargetWeight(1,t) = 1 - r(1,t)/RMax;     % target weight
    for w = 1 : WeaponNum
        KillPro(w,t) = MaxKillPro(w) * exp( - ( r(1,t) - MaxKillRange(w) ).^2 / ( BellWidth(w).^2 ) );     % kill probability matrix p
    end
end

end

