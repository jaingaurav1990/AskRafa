function [ Residue ] = CoeffToRes( ResCoeff, subblock_width )
%UNTITLED7 Summary of this function goes here
%   Detailed explanation goes here

sb_width = subblock_width;
[m,n] = size(ResCoeff);

for row = 1:sb_width:m
    for col = 1:sb_width:n
        subblock = ResCoeff(row:row + sb_width - 1, col:col + sb_width - 1);
        % Replace residue subblock with DCT coefficients (WebP used
        % Walsh-Hadamard Transform in addition)
        Residue(row:row + sb_width - 1, col:col + sb_width - 1) = mirt_idctn(subblock);

end

end

