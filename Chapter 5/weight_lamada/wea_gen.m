function [weanum] = wea_gen(tarres,i)
%WEA_GEN 此处显示有关此函数的摘要
%   此处显示详细说明
filename= ['weares',int2str(i),'.mat'];
load(filename);

weanum = zeros();
weanum(1) = weares(1);

l = length(tarres);
for i = 2 : l-1
    weanum(i) = weanum(i-1) - round((tarres(i-1)-tarres(i))*(1+1*rand));
end
weanum(l) = weanum(l-1) - 2 * (tarres(l-1)-tarres(l));

end

