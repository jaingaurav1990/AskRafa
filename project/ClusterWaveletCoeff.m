function [ z, U, score ] = ClusterWaveletCoeff( Wc, patch_width, nClusters, keep_ratio )
%ClusterWaveletCoeff: Used to perform clustering over the wavelet
%coefficients matrix
%   Detailed explanation goes here

[N,M] = size(Wc);

pw = patch_width;
pl = pw*pw;
idx = 1;
ROWS = N;
COLS = M;

if (N ~= M)
    disp('Rows and Cols different for the Wavelet coefficient matrix. Terminating...');
    return
end

wc_vectors = zeros(pl, 1);
      
for row = 1:pw:ROWS,
    for col = 1:pw:COLS,
        
        Patch = Wc(row:row + pw - 1, col:col + pw - 1);
        wc_vectors(1:pl,idx) = reshape(Patch, pl, 1); % Sparse wavelet coefficient vector stored as a column
               
        idx = idx + 1;
          
     end
end

[z, U, score] = k_means(wc_vectors, nClusters);
% Convert z to a signed-integer matrix to save space
% Right now, it is a 'double' matrix
%z = int32(z);
disp(['Number of nonzero elements in U matrix before calling keep: ', num2str(length(nonzeros(U)))]);
U
%figure('Name','U before calling keep'),imshow(U);
%U = keep(U, keep_ratio);
%disp(['Number of nonzero elements in U matrix after calling keep: ', num2str(length(nonzeros(U)))]);
%nonzeros(U)
%figure('Name','U after calling keep'),imshow(U, []);
U = sparse(U);
