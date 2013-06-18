function [ Bitstream, zr_run, metadata ] = RLREncode( A )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here



[m,n] = size(A);
z = zeros(m,n); % Significance flag vector
%disp('Significance flag vector');
%z
if ~isa(A, 'int16')
    disp('Not expecting a class other than int16');
    return;
end

% metadata to help decoding
metadata(1) = m; metadata(2) = n;

% Extract the sign bits of all numbers
sign = bitget(A, 16);

A = abs(A);
mxm = max(A(:));

mst_sig_plane = ceil(log2(double(mxm)));
%disp(['log2 of maximum ', num2str(mst_sig_plane)]);
if floor(log2(double(mxm))) == log2(double(mxm))
    disp('maximum is a power of 2');
    mst_sig_plane = mst_sig_plane + 1;
end

metadata(3) = mst_sig_plane;
k = 6;
metadata(4) = k;  % Be pessimistic to start with a low k
md_idx = 5;

disp(['Starting from most significant plane ', num2str(mst_sig_plane)]);
Bitstream = [];
zr_run = [];
pl_comp_bits_last = 0;
for bitplane_num = mst_sig_plane:-1:1
    BitPlane = bitget(A, bitplane_num);
    Bs_idx = find(z == 0);
    Bs = BitPlane(Bs_idx);
    Br = BitPlane(find(z ~= 0));
    Bs_pass = Bs; 
    if m > 1
        Bs_pass = Bs';
    end
    %disp(['Number of bits that would be coded (Bs): ', num2str(numel(Bs))]);
    % Append RLR coded bits from Bs
    [Out, zerorun, z] = RLR(Bs_pass, Bs_idx, sign, z, k);
    Bitstream = horzcat(Bitstream, Out );
    % Mark end of Bs bits of this plane in metadata
    metadata(md_idx) = numel(Bitstream); md_idx = md_idx + 1;
    
    % Append bits in set Br as it is.
    Bitstream = horzcat(Bitstream, Br(:)');
    
    % Mark end of this plane's emitted code
    metadata(md_idx) = numel(Bitstream); md_idx = md_idx + 1;
    
    % Append bits for zero run length
    zr_run = horzcat(zr_run, zerorun);
    
    %disp(['Bitstream and zr_run after encoding plane ', num2str(bitplane_num)]);
    %Bitstream
    %zr_run
    
    pl_comp_bits_total = numel(Bitstream) + numel(zr_run);
    pl_comp_bits_cur = pl_comp_bits_total - pl_comp_bits_last;
    disp(['Compression for plane ', num2str(bitplane_num), ' is: ', num2str(m*n), ' ', num2str(pl_comp_bits_cur/8), ' Total bytes:', num2str(pl_comp_bits_total/8), ' CompRatio: ', num2str(pl_comp_bits_total/(8*m*n))]);
    pl_comp_bits_last = pl_comp_bits_total;
end

Bitstream_sz = whos('Bitstream');
zr_run_sz = whos('zr_run');
disp(['Size of bitstream in bytes :', num2str(Bitstream_sz.bytes)]);
disp(['Size of zr_run in bytes :', num2str(zr_run_sz.bytes)]);
bits = numel(Bitstream) + numel(zr_run);
disp(['Total bits and bytes:', num2str(bits), ' ', num2str(bits/8)]);

end
















