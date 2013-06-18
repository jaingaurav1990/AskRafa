function [ I ] = Pad( I, levels )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
[M,N] = size(I);
Mb = ceil(M/(2 ^ levels));
Nb = ceil(N/(2 ^ levels));

% PAD the channel I to be a multiple of (2 ^ levels)*Mb x (2 ^ levels)*Nb
M_pad = (2 ^ levels)*Mb;
N_pad = (2 ^ levels)*Nb;

if M_pad ~= M
    I(M + 1:M_pad,:) = 0;
end

if N_pad ~= N
    I(:,N + 1:N_pad) = 0;
end 

end

