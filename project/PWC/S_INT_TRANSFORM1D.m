function [ cS, l, h ] = S_INT_TRANSFORM1D( c )
%S_INT_TRANSFORM1D Calculates Sequential Integer
% transform of a 1D array c. length of c must
% be a multiple of 2.

% Adapted from the Paper: Reversible Image Compression Via Multiresolution 
% Representation and Predictive Coding (1993)
% By: Amir Said, William Pearlman


n = numel(c);
if rem(n,2) ~= 0
    disp('length of input argument must be divisible by 2');
    return;
end

mid = n/2;
l = zeros(1,mid);
h = zeros(1,mid);

for i = 1:mid
    l(i) = floor((c(2*i - 1) + c(2*i))/2);
    h(i) = c(2*i - 1) - c(2*i);
end
cS(1:mid) = l(1:end);
cS(mid + 1:n) = h(1:end);

end

