function [ Recon_Plane ] = RLRDecode( Bitstream, zr_run, metadata )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

% Decoding metadata
M = metadata(1);
N = metadata(2);
mst_sig_plane = metadata(3);
k_start = metadata(4);
md_el = numel(metadata);
n_ends = (md_el - 4)/2;


bs_ends(1:n_ends) = metadata(5:2:md_el - 1);
plane_ends(1:n_ends) = metadata(6:2:md_el);

n = numel(Bitstream);

zr_run_idx = 1;
BitPlanes = zeros(M,N,mst_sig_plane);
Bitplane_dims = M*N;
sign_plane = zeros(M,N);
z = zeros(M,N); % Significance flags
pl_begin = 1;

for i = 1:mst_sig_plane % Just for the sake of proper indexing of the vector plane_ends
    pl_last = plane_ends(i); 
    Bs_last = bs_ends(i);
   
    
    k = k_start;
    pl_bits = []; % Bit-plane for the current plane
    j = pl_begin;
    
    neg_vec = zeros(1, numel(find(z == 0)));
    
    while j <= Bs_last 
        bit = Bitstream(j);
        if bit == 0 % Only 0 bit is consumed
            num_zeroes = 2 ^ k;
            pl_bits = horzcat(pl_bits, zeros(1, num_zeroes));
            k = k + 1;
        else % Every time a 1 bit is encountered, following bit (that tells sign) is also consumed
            num_zeroes = bin2dec(zr_run(1,zr_run_idx:zr_run_idx + k - 1));
            pl_bits = horzcat(pl_bits, zeros(1, num_zeroes));
            zr_run_idx = zr_run_idx + k;
            % Put a 1 in pl_bits stream
            pl_bits = horzcat(pl_bits, [1]);
            %disp(['zr_run_idx now pointing at', num2str(zr_run_idx)]);
            % Consume next bit (tells sign)
            j = j + 1;
            bit = Bitstream(j);
            if bit == 1
                neg_id = numel(pl_bits);
                neg_vec(neg_id) = 1;
            end
            if k > 1 % You always need at least 1 bit to encode zero run length
                k = k - 1;
            end
        end
        
        j = j + 1;    
    end
     
    
    % Append bits from the Br set (Refinement bits). But before that,
    % check if the total number of bits equals the dimensions of bit
    % plane. If not, fill in with zeroes in between -- These trailing
    % zeroes were not emitted in coding process
    n_Br_bits = pl_last - Bs_last;
    so_far = numel(pl_bits);
    if (so_far + n_Br_bits) ~= Bitplane_dims
        deficit = Bitplane_dims - (so_far + n_Br_bits);
        pl_bits = horzcat(pl_bits, zeros(1, deficit));
    end
    
    B = BitPlanes(:,:,i);
    Bs_bits = pl_bits(1:end);
    %disp(['Iteration: ', num2str(i)]);
    %disp(['Number of elements in set Bs: ', num2str(numel(Bs_bits))]);
    %find(z == 0)
    if so_far ~= 0
        B(find(z == 0)) = Bs_bits(1:end);
        sign_plane(find(z == 0)) = neg_vec(1:end);
    end
    
    %disp('B after setting Bs bits');
    %B
    %find(B == 1)
    % Append bits from Br set
    Br_bits = zeros(1, n_Br_bits);
    if n_Br_bits ~= 0
        Br_bits = Bitstream(1, Bs_last + 1: pl_last);
        pl_bits = horzcat(pl_bits, Br_bits);
    end
     
    % Save Bit-plane
    
    if n_Br_bits ~= 0
        B(find(z == 1)) = Br_bits(1:end);
    end
    %disp(['B for this iteration bit plane']);
    %B
    %find(B == 1)
    z(find(B == 1)) = 1; % Update significance flags
    BitPlanes(:,:,i) = B;
    
    % Update pl_begin  for next iter
    pl_begin = pl_last + 1;
end
   
% Checks to ensure the entire Bitstream and zr_run was consumed
%zr_run_idx
assert(zr_run_idx == (numel(zr_run) + 1));
assert(pl_begin == (numel(Bitstream) + 1));

% Construct the original plane (with all bits)
Recon_Plane = zeros(M,N);
for i = 1:mst_sig_plane
    weight = 2 ^ (mst_sig_plane - i);
    BitPlanes(:,:,i) = weight * BitPlanes(:,:,i);
    Recon_Plane = Recon_Plane + BitPlanes(:,:,i);
end

sign_plane = (-1)*sign_plane;
sign_plane(find(sign_plane == 0)) = 1;
Recon_Plane = sign_plane .* Recon_Plane;

end    


