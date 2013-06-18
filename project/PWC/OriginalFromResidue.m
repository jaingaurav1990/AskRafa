function [ I ] = OriginalFromResidue( ResCoeff, mb_width, subblock_width, m, n, mode )
%UNTITLED6 Summary of this function goes here
%   Detailed explanation goes here
V_PRED = 0; H_PRED = 1; DC_PRED = 2; TM_PRED = 3;


Residue = EntropyDecodeSPIHT(ResCoeff, 4);
[Residue_rows, Residue_cols] = size(Residue);
disp(['Dimensions after SPIHT decoding: ', num2str(Residue_rows), num2str(Residue_cols)]); 
%Residue = CDFDecompress(double(Residue), 4, 'cdf97');
Residue = mirt_idctn(Residue);
%}
[r,c] = size(Residue);
ROWS = r + mb_width;
COLS = c + 2*mb_width;
P = zeros(ROWS, COLS);
P(:, 1:mb_width) = 129;
P(1:mb_width, :) = 127;

%Residue = CoeffToRes(ResCoeff, subblock_width);

size(ResCoeff)
size(P)
switch mode
    case V_PRED
        for row = mb_width + 1:mb_width:ROWS
            p_row = P(row - 1,mb_width + 1:mb_width + c);
            P(row:row + mb_width - 1,mb_width + 1:mb_width + c) = repmat(p_row, mb_width, 1);
            P(row:row + mb_width - 1,mb_width + 1:mb_width + c) = P(row:row + mb_width - 1,mb_width + 1:mb_width + c) + Residue(row - mb_width:row - 1,:);
        end
        
    case H_PRED
        for col = mb_width + 1:mb_width:mb_width + c
            p_col = P(mb_width + 1:mb_width + r,col - 1);
            P(mb_width + 1:mb_width + r, col:col + mb_width - 1) = repmat(p_col,1,mb_width);
            P(mb_width + 1:mb_width + r, col:col + mb_width - 1) = P(mb_width + 1:mb_width + r, col:col + mb_width - 1) + Residue(:,col - mb_width:col - 1);
        end
        
    case TM_PRED 
        disp('Dimensions of P:');
        size(P)
        for row = mb_width:mb_width:ROWS - 1
            for col = mb_width:mb_width:COLS - mb_width - 1
                %disp(['row: ', num2str(row), ' col: ', num2str(col)]);
                A = P(row, col + 1:col + mb_width);
                L = P(row + 1:row + mb_width,col);
                Pixel = P(row,col);
                P(row + 1:row + mb_width, col + 1:col + mb_width) = repmat(A,mb_width, 1) + repmat(L, 1, mb_width) - Pixel;
                P(row + 1:row + mb_width, col + 1:col + mb_width) = P(row + 1:row + mb_width, col + 1:col + mb_width) + Residue(row + 1 - mb_width:row, col + 1 - mb_width:col);
            end
        end
end

I = P(mb_width + 1:mb_width + m, mb_width + 1:mb_width + n);
end

