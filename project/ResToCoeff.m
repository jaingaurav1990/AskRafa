function [ Coeff ] = ResToCoeff( Residue, subblock_width )
%ResCoeff Convert the matrix of Residual signal into a matrix of wavelet
%coefficients by applying DCT on each sub-block
%   Detailed explanation goes here

sb_width = subblock_width;
[m,n] = size(Residue);

for row = 1:sb_width:m
    for col = 1:sb_width:n
        subblock = Residue(row:row + sb_width - 1, col:col + sb_width - 1);
        % Replace residue subblock with DCT coefficients (WebP used
        % Walsh-Hadamard Transform in addition)
        Coeff(row:row + sb_width - 1, col:col + sb_width - 1) = mirt_dctn(subblock);
    end
end
end

