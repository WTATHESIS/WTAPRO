function [weatarsta] = weapon_target_state_update(weanum,tarnum,weasta,tarsta,avahig,avalow,statim,maxtim)
%WEAPON_STATE_UPDATE 此处显示有关此函数的摘要
%   此处显示详细说明

% randmat = rand(weanum,tarnum);
% ratio = avalow + (avahig - avalow) * (statim-1)/(maxtim-1);
% weataratt = (sign(randmat-ratio)+1)/2;
% weatarsta = weataratt .* weasta' .* tarsta;

weatarsta = weasta' .* tarsta;

end

