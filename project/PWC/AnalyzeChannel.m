function [  ] = AnalyzeChannel( I )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

[m,n] = size(I);
N = m;
if m < n
    N = n;
end

p = nextpow2(N);
N = pow2(p);      

Img = zeros(N,N);
Img(1:m,1:n) = I;
disp(['Dimensions of image:', num2str(N)]);
H = haarTrans(N);
Z = Img*H';
figure('Name', 'Haar Transform on rows'), imshow(Z);
Z = H*Z;
figure('Name', 'Haar Transform on rows and cols'), imshow(Z);
%{
for i = 1:8
    B = bitget(I,i);
    bool_ones = numel(nonzeros(B));
    bool_zeros = numel(B) - bool_ones;
    disp(['Number of 1 bit: ', num2str(numel(nonzeros(B)))]);
    disp(['Number of 1 bit (as a ratio):', num2str(numel(nonzeros(B))/numel(B))]);
    B = B + 1; % For arithmetic encoding
    counts = [bool_zeros bool_ones];
    B = B';
    encoded = arithenco(B(:), counts);
    whos('encoded')
end
%}
end

