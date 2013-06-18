function [ A ] = ISP_INT_TRANSFORM2D( Z, levels )
%ISP_INT_TRANSFORM2D Calculates inverse multitresolution integer
% wavelet transform of a 2D array A. Dimensions of Z must
% be a multiple of 2 ^ levels

% Adapted from the Paper: Reversible Image Compression Via Multiresolution 
% Representation and Predictive Coding (1993)
% By: Amir Said, William Pearlman

[r,c ] = size(Z);
[m,n] = size(Z);

p = 2 ^ levels;

if rem(r,p) ~= 0
    disp('Rows not padded to 2 ^ levels');
    return;
end

if rem(c,p) ~= 0
    disp('Cols not padded to 2 ^ levels');
    return;
end

A = Z;

for level = levels:-1:1
    
    m = r; n = c;
    
    for l = level - 1:-1:1
        m = ceil(m/2);
        n = ceil(n/2);
    end
    
    disp(['m and n at level: ', num2str(m), ' ', num2str(n), ' ', num2str(level)]);
    % Apply inverse tranform on cols
    for i = 1:n
        A(:,i) = (ISP_INT_TRANSFORM1D(A(:,i)'))';
    end
    %disp('After applying inverse transform on cols');
    %A
    % Apply inverse transform on rows
    for i = 1:m
        A(i,:) = ISP_INT_TRANSFORM1D(A(i,:));
    end
end

end

