function [tareffkillpro,tarsurpro] = tareffkillpro_compute(tarsta,weakillpro,tarkillpro,weadec)
%TARASSEFF_GENERATE 此处显示有关此函数的摘要
%   此处显示详细说明

tarsurpro = prod((1-weakillpro).^ weadec) .* tarsta;

tareffkillpro = tarkillpro .* tarsurpro';

end

