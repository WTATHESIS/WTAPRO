function [weatarsta] = weapon_target_state_update(weanum,tarnum,weasta,tarsta,avahig,avalow,statim,maxtim)
%WEAPON_STATE_UPDATE �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��

% randmat = rand(weanum,tarnum);
% ratio = avalow + (avahig - avalow) * (statim-1)/(maxtim-1);
% weataratt = (sign(randmat-ratio)+1)/2;
% weatarsta = weataratt .* weasta' .* tarsta;

weatarsta = weasta' .* tarsta;

end

