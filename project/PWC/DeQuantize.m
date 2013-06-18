function [ W ] = DeQuantize( C, thresh )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

W = C;
gt_zero = find(C > 0);
W(gt_zero) = thresh*(C(gt_zero) + 0.5);

lt_zero = find(C < 0);
W(lt_zero) = thresh*(C(lt_zero) - 0.5);

end

