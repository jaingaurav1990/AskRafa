function [ cI ] = IS_INT_TRANSFORM1D( c )
%IS_INT_TRANSFORM1D Calculates Inverse Sequential Integer
% transform of a 1D array c. length of c must
% be a multiple of 2.

% Adapted from the Paper: Reversible Image Compression Via Multiresolution 
% Representation and Predictive Coding (1993)
% By: Amir Said, William Pearlman


n = numel(c);
if rem(n,2) ~= 0
    disp('Input argument to inverse S Transform must have even number of elements');
    return
end

mid = n/2;

l = c(1:mid);
h = c(mid + 1:end);
cI = zeros(1,n);
for i = 1:mid
    cI(2*i - 1) = l(i) + floor((h(i) + 1)/2);
    cI(2*i) = cI(2*i - 1) - h(i);
end


end

