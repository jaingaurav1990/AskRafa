function [ Q ] = Quantize( C, thresh )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

Q = sign(C).*(floor((abs(C)/thresh)));

end

