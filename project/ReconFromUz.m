function [ I ] = ReconFromUz( z, U, patch_width, m, n )
% Reconstruct the image channel(Cb, Cr of wavelet coefficients) from
% U (Cluster-mean matrix) and z (label matrix)
%   Detailed explanation goes here

N = m;
if m < n
    N = n;
end

p = nextpow2(N);
N = pow2(p); 


disp(['Reconstructing image channel in wavelet domain of size: ', num2str(N), '*', num2str(N)]);
I = zeros(N, N);

pw = patch_width;
pl = pw*pw;
% U comes in sparse format. De-sparse it
U = full(U);

if size(U,1) ~= pl
    disp('Number of rows in matrix U does not match patch-width squared. Terminating...');
    return
end


idx = 1;
for row = 1:pw:m
    for col = 1:pw:n
        I(row:row + pw - 1, col:col + pw - 1) = reshape(U(1:pl, z(idx)), pw, pw);
        idx = idx + 1;
    end
end

end

