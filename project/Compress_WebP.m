function [ I_Comp ] = Compress_WebP( I )


% DEFINE various prediction modes
V_PRED = 0; H_PRED = 1; DC_PRED = 2; TM_PRED = 3;
mode = V_PRED;

I_Comp.S = size(I);

if length(I_Comp.S) > 2
    I = RGBToYCbCr(I);
    %I_Comp.Y = I(:,:,1);
    %figure('Name', 'Y channel of image'), imshow(I_Comp.Y);  
    I_Comp.size = size(I);
    Y = I(:,:,1);
    Cb = I(:,:,2); % WebP requires subsampling
    Cr = I(:,:,3); % WebP requires subsampling
    
    % Both Residue and Prediction buffer returned below have dimensions
    % divisible by the macroblock width (16 or 8)
    mb_width = 16; % Macroblock width
    [ResY, PredY] = ResidueAndPrediction(Y, mb_width, V_PRED);
    [ResCb, PredCb] = ResidueAndPrediction(Cb, mb_width, V_PRED); % Use mb_width = 8, if subsampling
    [ResCr, PredCr] = ResidueAndPrediction(Cr, mb_width, V_PRED); % Use mb_width = 8, if subsampling
    
    % Convert Residue matrix to wavelet coefficient matrix
    subblock_width = 4;
    ResCoeff_Y = ResToCoeff(ResY, subblock_width); % In WebP, coefficients are losslessly compressed insted of being ignored
    ResCoeff_Cb = keep(ResToCoeff(ResCb, subblock_width),1/200);
    ResCoeff_Cr = keep(ResToCoeff(ResCr, subblock_width),1/200);
    
    I_Comp.ResCoeff_Y = ResCoeff_Y;
    I_Comp.ResCoeff_Cb = ResCoeff_Cb;
    I_Comp.ResCoeff_Cr = ResCoeff_Cr;
    I_Comp.mb_width = mb_width;
    I_Comp.sb_width = subblock_width;
    I_Comp.mode = mode;
    
    Y_size = whos('Y');
    Cb_size = whos('Cb');
    Cr_size = whos('Cr');
    
    disp(['Size of Y channel :', ' ', num2str(Y_size.bytes)]);
    
    Comp_Y_size = whos('ResCoeff_Y');
    compressed_bytes = Comp_Y_size.bytes;
    disp(['Y compression using prediction and wavelet coeff; Original size: ', num2str(Y_size.bytes), '  Compressed size: ', num2str(compressed_bytes)]);
    
    Comp_Cb_size = whos('ResCoeff_Cb');
    
    compressed_bytes = Comp_Cb_size.bytes;
    disp(['Cb compression using prediction and wavelet coeff; Original size: ', num2str(Cb_size.bytes), '  Compressed size: ', num2str(compressed_bytes)]);
    
    Comp_Cr_size = whos('ResCoeff_Cr');
    compressed_bytes = Comp_Cr_size.bytes;
    disp(['Cr compression using prediction and wavelet coeff; Original size: ', num2str(Cr_size.bytes), '  Compressed size: ', num2str(compressed_bytes)]);
    
    
    
else
    I = CompressWavelet(I);
    I = keep(I, 1/25);
    I_Comp.I = sparse(I);
    
    
    % Comment following 2 lines in case using only wavelet compression
    %{
    [z, U, score] = ClusterPatchWaveletCoeff(I, 8, 100,1/25);
    I_Comp.z1 = z; I_Comp.U1 = U;
    %}  
    
    
    
end



end

