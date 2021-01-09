function [totfit,curfit,postfit,tarsurpro,asssurpro] = fitness_compute(weasta,tarsta,asssta,weakillpro,tarkillpro,assval,weadec,tardec,curwei)
%FITNESS_COMPUTE 此处显示有关此函数的摘要
%   此处显示详细说明

%% 当前决策收益
[tareffkillpro,tarsurpro] = tareffkillpro_compute(tarsta,weakillpro,tarkillpro,weadec);
[totexcassval,~,asssurpro] = target_asset_fitness(assval,asssta,tareffkillpro,tardec);
% curfit = totexcassval;
curfit = totexcassval/sum(assval.*asssta);

%% 剩余武器对下阶段态势期望收益
if all(weasta==0)
    postfit = 0;
else
    temp1 = 1 - (1 - sum(weakillpro .* weasta')/sum(weasta)) .^ (sum(weasta)/sum(tarsta));
    temp2 = assval .* asssurpro .* tarsta' .* tarkillpro .* temp1';
    postfit = sum(temp2,'all')/sum(tarsta)/sum(assval .* asssta .* asssurpro);
    
%     temp2 = assval .* tarsta' .* tarkillpro .* temp1';
%     postfit = sum(temp2,'all')/sum(tarsta)/sum(assval.*asssta);
end

totfit = curwei * curfit + ( 1 - curwei ) * postfit;

end

