function [totexcassval,sinexcassval,asssurpro] = target_asset_fitness(assval,asssta,tarkillpro,tardec)
%WEAPON_TARGET_FITNESS �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��

asssurpro = prod((1-tarkillpro).^ tardec).*asssta;

sinexcassval = assval .* asssurpro;

totexcassval = sum(sinexcassval);

end

