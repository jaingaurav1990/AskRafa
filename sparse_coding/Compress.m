function I_comp = Compress(I);
figure, imshow(I);
% Your compression code goes here

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

I_red = I(:,:,1);

if (channels > 1)
I_green = I(:,:,2);
I_blue = I(:,:,3);
end

for chan=1:channels
    
      channels
      size(Img)

      Img(:,:) = 0;
      if chan == 1
        Img(1:m,1:n) = I_red;
      elseif chan == 2
          Img(1:m,1:n) = I_green;
      else 
          Img(1:m,1:n) = I_blue;
      end
      
      %figure, imshow(Img);
      H = haarTrans(N);
      Z = H*Img*H';
      
      if (chan == 1)
          I_red_trans = Z;
      elseif (chan == 2)
          I_green_trans = Z;
      else
          I_blue_trans = Z;
      end
      %figure, imshow(Z);
      %{
      Z = reshape(Z, N*N, 1);
      [Z, idx] = sort(Z, 'descend');
      Img(1:m, 1:n) = 0;
      compress_ratio = 0.9;
      max = floor(compress_ratio*N*N);
      %max = N*N;
      idx = idx(1:max);
      %I_onedim = zeros(N*N, 1);
      %I_onedim(idx) = Z(1:max);
      Img(idx) = Z(1:max);
      %}

      Z(abs(Z) < 0.25) = 0;
      
      if (chan == 1)
        I_comp.red_trans = sparse(Z);
      elseif (chan == 2)
          I_comp.green_trans = sparse(Z);
      else
          I_comp.blue_trans = sparse(Z);
      end
end

%I_comp.I = sparse(I_compressed


I_comp.S = [m,n,channels,N];
%{
rg = (I_red - I_green)
rb = (I_red - I_blue)
gb = (I_green - I_blue)
figure, imshow(I_red_trans);
figure, imshow(I_green_trans);
figure, imshow(I_blue_trans);
rgt = (I_red_trans - I_green_trans)
rbt = (I_red_trans - I_blue_trans)
gbt = (I_green_trans - I_blue_trans)
%}
%I_comp.I = I; % this is just a stump to make the evaluation script run, replace it with your code!
