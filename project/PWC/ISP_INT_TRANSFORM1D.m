function [ X ] = ISP_INT_TRANSFORM1D( z )
%ISP_INT_TRANSFORM1D Calculates inverse SP integer
% wavelet transform of a 1D array c. Dimensions of c must
% be a multiple of 2.

% Adapted from the Paper: Reversible Image Compression Via Multiresolution 
% Representation and Predictive Coding (1993)
% By: Amir Said, William Pearlman

n = numel(z);
if rem(n,2) ~= 0
    disp('z should have even number of elements');
    return;
end

mid = n/2;
l = z(1:mid);
hd = z(mid + 1:n);
hcap = zeros(1,mid);
h = zeros(1,mid);

delL = zeros(1,mid);
%numel(delL)
for i = 2:mid
    delL(i) = l(i - 1) - l(i);
end

hcap(1) = floor((delL(2) + delL(3))/4);
hcap(end) = floor((delL(mid - 1) + delL(mid))/4);
h(end) = hd(end) + hcap(end);
h(1) = hd(1) + hcap(1);

for i = mid-1:-1:2
    hcap(i) = floor((2*(delL(i) + delL(i + 1) - h(i + 1)) + delL(i + 1))/8);
    h(i) = hd(i) + hcap(i);
end

z(mid + 1:n) = h(1:end);
%disp('Applying inverse S-Transform on following');
%l
%h
X = IS_INT_TRANSFORM1D(z);

end
