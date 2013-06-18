function [ z, U, score ] = ClusterPatchWaveletCoeff( I, patch_width, nClusters, keep_ratio  )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here


[m,n,channels] = size(I);
rmndr = rem(m,patch_width);
def = patch_width - rmndr;
ROWS = m + def;

rmndr = rem(n, patch_width);
def = patch_width - rmndr;
COLS = n + def;

pw = patch_width;

pl = pw*pw;
idx = 1;
Img = zeros(ROWS,COLS);
Img(1:m, 1:n) = I;

H = haarTrans(pw);
wc_vectors = zeros(pl, 1);
      
for row = 1:pw:ROWS,
    for col = 1:pw:COLS,
        Patch = Img(row:row + pw - 1, col:col + pw - 1);
        Z = H*Patch*H';
        %Z = keep(Z, keep_ratio);
        %Z(abs(Z) < 0.1) = 0;
        %imshow(Z)
        wc_vectors(1:pl,idx) = reshape(Z, pl, 1); % Sparse wavelet coefficient vector stored as a column
        idx = idx + 1;
     end
end
     
%figure, imshow(Img);
[z, U, score] = k_means(wc_vectors, nClusters);
z = int32(z);
U = keep(U, keep_ratio);

%disp('U after conversion to single precision');

U = sparse(U);

end

