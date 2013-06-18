function [ I ] = OriginalFromResidue( ResCoeff, mb_width, subblock_width, m, n, mode )
%UNTITLED6 Summary of this function goes here
%   Detailed explanation goes here
V_PRED = 0; H_PRED = 1; DC_PRED = 2; TM_PRED = 3;

[r,c] = size(ResCoeff);
ROWS = r + mb_width;
COLS = c + 2*mb_width;
P = zeros(ROWS, COLS);
P(:, 1:mb_width) = 129;
P(1:mb_width, :) = 127;

Residue = CoeffToRes(ResCoeff, subblock_width);

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
end

I = P(mb_width + 1:mb_width + m, mb_width + 1:mb_width + n);
end

