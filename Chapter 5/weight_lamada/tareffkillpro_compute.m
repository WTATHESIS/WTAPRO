function [tareffkillpro,tarsurpro] = tareffkillpro_compute(tarsta,weakillpro,tarkillpro,weadec)
%TARASSEFF_GENERATE �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��

tarsurpro = prod((1-weakillpro).^ weadec) .* tarsta;

tareffkillpro = tarkillpro .* tarsurpro';

end

