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
    
    I = RGBToYCbCr(I);
    Cb = I(:,:,2);
    Cr = I(:,:,3);
end

for chan=1:channels
    
      Img(:,:) = 0;
      if chan == 1
        Img(1:m,1:n) = I_red;
      elseif chan == 2
          Img(1:m,1:n) = I_green;
      else 
          Img(1:m,1:n) = I_blue;
      end
      
      pw = 4;
      pl = pw*pw;
      idx = 1;
      ROWS = N;
      COLS = N;
      H = haarTrans(pw);
      wc_vectors = zeros(pl, 1);
      
      for row = 1:pw:ROWS,
           for col = 1:pw:COLS,
               Patch = Img(row:row + pw - 1, col:col + pw - 1);
               Z = H*Patch*H';
               Z = keep(Z, 1/25);
               %Z(abs(Z) < 0.1) = 0;
               imshow(Z)
               wc_vectors(1:pl,idx) = reshape(Z, pl, 1); % Sparse wavelet coefficient vector stored as a column
               
               idx = idx + 1;
           end
      end
     
      %figure, imshow(Img);
      [z, U, score] = k_means(wc_vectors, 100);
      
      
      if (chan == 1)
        I_comp.red_trans.z = z;
        I_comp.red_trans.U = sparse(U);
      elseif (chan == 2)
          I_comp.green_trans.z = z;
          I_comp.green_trans.U = sparse(U);
      else
          I_comp.blue_trans.z = z;
          I_comp.blue_trans.U = sparse(U);
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
