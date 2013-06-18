function [ Z ] = SP_INT_TRANSFORM2D( A, levels)
%SP_INT_TRANSFORM2D Calculates multitresolution integer
% wavelet transform of a 2D array A. Dimensions of A must
% be a multiple of 2 ^ levels

% Adapted from the Paper: Reversible Image Compression Via Multiresolution 
% Representation and Predictive Coding (1993)
% By: Amir Said, William Pearlman

% Check class of input matrix
if isa(A,'uint8')
    disp('Use double or int16 for input A. uint8 is not a good idea.');
    return;
end

[r,c] = size(A);
p = 2 ^ levels;

if rem(r,p) ~= 0
    disp('Rows not padded to 2 ^ levels');
    return;
end

if rem(c,p) ~= 0
    disp('Cols not padded to 2 ^ levels');
    return;
end

[m,n] = size(A);

for level = 1:levels
    
    % Apply 1D Transformation on all rows
    for i = 1:m
        A(i,:) = SP_INT_TRANSFORM1D(A(i, :));
    end
    %disp('After applying transform on rows');
    %A
    
    % Follow up with Transform on all columns
    for i = 1:n
        C = SP_INT_TRANSFORM1D(A(:,i)');
        A(:,i) = C';
    end

    m = ceil(m / 2);
    n = ceil(n / 2);
    
end

Z = A;
end


