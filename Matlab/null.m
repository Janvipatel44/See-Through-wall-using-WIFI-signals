\

load 'h_201.mat'

h1 = avg_h;

load 'h_209.mat'

h2 = avg_h;
 
h11 = repmat(h1,64,1);
h12 = repmat(h2,64,1);

x = randn(64,40);

p = (-1)*(h11./h12);

y = h11*x + (p.*h12)*x;

save ('p.mat','p');
