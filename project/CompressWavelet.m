function I_Comp = CompressWavelet(I)

% Feature Extraction
% Convert the M*N*3 image into 3*(M*N) 2-D array OR 1*(M*N) 1-D array for a
% gray-scale image
[m,n,channels] = size(I);
N = m;
if m < n
    N = n;
end

p = nextpow2(N);
N = pow2(p);      

Img = zeros(N,N);

H = haarTrans(N);
%Z = cell(size(I,3),1);

for chan=1:channels
      Img(1:m,1:n) = double(I(:,:,chan));

      z = H*Img*H';
      
         %hist(reshape(z,1,[]),100);figure(gcf);
        %  plot(sort(reshape(z,1,[])));figure(gcf);
        %  quantile((reshape(z,1,[])), 10)
    %sqrt(2*log(length(reshape(z,1,[]))))    
    %thselect(reshape(z,1,[]),'rigrsure')
    %thselect(reshape(z,1,[]),'heursure')
    %thselect(reshape(z,1,[]),'sqtwolog')
    %thselect(reshape(z,1,[]),'minimaxi')
   % thresholdFactor*thselect(reshape(z,1,[]),'rigrsure')
   %   size(find(abs(z) < thresholdFactor*thselect(reshape(z,1,[]),'rigrsure')))

   %   z(abs(z) < thresholdFactor*thselect(reshape(z,1,[]),'rigrsure')) = 0;
    
   %   Z{chan} = sparse(z);
    Z(:,:,chan) = z;
end

I_Comp = Z;
%I_Comp.S = [m,n,channels,N];
