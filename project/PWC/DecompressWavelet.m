function I_rec = DecompressWavelet(I_Comp, m, n)

%m = I_Comp.S(1);
%n = I_Comp.S(2);
channels = size(I_Comp,3);
%N = I_Comp.S(4);
I_rec = zeros(m,n,size(I_Comp, 3));

N = m;
if m < n
    N = n;
end

p = nextpow2(N);
N = pow2(p); 

H = haarTrans(N);

for chan=1:channels

    Z = full(I_Comp(:,:,chan));
    size(Z);
    
    Img = H'*Z*H;
    I_rec(:,:,chan) = Img(1:m,1:n);    
end
