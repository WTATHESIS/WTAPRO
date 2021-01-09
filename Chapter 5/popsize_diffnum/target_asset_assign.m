function [tarassdecmat] = target_asset_assign(tarnum,assnum,tarkillpro,assval,tarasssta,effthr)
%WEAPON_ASSIGN 此处显示有关此函数的摘要
%   此处显示详细说明

tarasseff = assval .* tarkillpro .* tarasssta;
tarassdecmat = zeros(tarnum,assnum);
tempassval = assval;
for i = 1 : tarnum
    [maxpro,maxassind]= max(tarasseff(i,:));
    tarvardif = tempassval(1,maxassind) * maxpro;
    if tarvardif > effthr * assval(1,maxassind)
        tarassdecmat(i,maxassind) = 1;
        tarasssta(i,:) = 0;
        tempassval(1,maxassind) = tempassval(1,maxassind) * (1-maxpro);
        tarasseff = ones(tarnum,1) * tempassval .* tarkillpro .* tarasssta; 
    else
        tarasseff(i,maxassind) = 0;
        i = i - 1;
    end
end

end
