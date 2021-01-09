function loss = wta_loss(x,v,p)
[n m] = size(p);
x = reshape(x,n,m);
p_hat = ones(n,m) - p;
% compute survive rate of targets
s = zeros(m,1);
for i = 1:m
    s_t = 1;
    for j = 1:n
        s_t = s_t*p_hat(j,i)^x(j,i);
    end
    s(i) = s_t;
end
loss = v*s;