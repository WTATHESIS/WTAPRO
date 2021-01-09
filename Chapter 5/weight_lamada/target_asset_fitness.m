function [totexcassval,sinexcassval,asssurpro] = target_asset_fitness(assval,asssta,tarkillpro,tardec)
%WEAPON_TARGET_FITNESS 此处显示有关此函数的摘要
%   此处显示详细说明

asssurpro = prod((1-tarkillpro).^ tardec).*asssta;

sinexcassval = assval .* asssurpro;

totexcassval = sum(sinexcassval);

end

