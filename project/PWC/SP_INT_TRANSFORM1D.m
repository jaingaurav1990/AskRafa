function [ Z ] = SP_INT_TRANSFORM1D( c )
%SP_INT_TRANSFORM1D Calculates SP integer
% wavelet transform of a 1D array c. Dimensions of c must
% be a multiple of 2.

% Adapted from the Paper: Reversible Image Compression Via Multiresolution 
% Representation and Predictive Coding (1993)
% By: Amir Said, William Pearlman

n = size(c,2);
if rem(n,2) ~= 0
    disp('length of input array must be a multiple of 2');
    return;
end

if n <= 4
    disp('Keep the length of input vector greater than 4 to avoid index out of bound errors');
    return;
end

[cS,l,h] = S_INT_TRANSFORM1D(c);
%{
disp('After S-Transform');
l 
h
%}
mid = n/2;

% Apply Prediction step
delL = zeros(1,mid);
%numel(delL)
for i = 2:mid
    delL(i) = l(i - 1) - l(i);
end

% Generate estimates
hcap = zeros(1,mid);

% Static step
hcap(1) = floor((delL(2) + delL(3))/4);
hcap(end) = floor((delL(end) + delL(end - 1))/4);

for i = 2:mid - 1
    hcap(i) = floor((2*(delL(i) + delL(i + 1) - h(i + 1)) + delL(i + 1))/8);
end

h(1:end) = h(1:end) - hcap(1:end);

Z(1:mid) = l(1:end);
Z(mid + 1:n) = h(1:end);
    


end

