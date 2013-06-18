function [ I ] = DeClusterPatchWaveletCoeff( z, U, patch_width, m, n)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

U = full(U);
rmndr = rem(m,patch_width);
def = patch_width - rmndr;
ROWS = m + def;

rmndr = rem(n, patch_width);
def = patch_width - rmndr;
COLS = n + def;
Img = zeros(ROWS, COLS);
pw = patch_width;
pl = pw*pw;
idx = 1;

H = haarTrans(pw);
for row = 1:pw:ROWS,
    for col = 1:pw:COLS,
        Tmp = reshape(U(1:pl, z(idx)), pw, pw);
        Img(row:row + pw - 1, col:col + pw - 1) = H'*Tmp*H;
        idx = idx + 1;
    end
end

I = Img(1:m,1:n);
end

