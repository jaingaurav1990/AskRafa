function I_Comp = Compress_ClustPatchesWaveletCoeff(I)

I_Comp.S = size(I);

if length(I_Comp.S) > 2
    I = RGBToYCbCr(I);
    %I_Comp.Y = I(:,:,1);
    %figure('Name', 'Y channel of image'), imshow(I_Comp.Y);  
    I_Comp.size = size(I);
    Y = I(:,:,1);
    Cb = I(:,:,2);
    Cr = I(:,:,3);
    
    Y_size = whos('Y');
    Cb_size = whos('Cb');
    Cr_size = whos('Cr');
    
    disp(['Size of Y channel :', ' ', num2str(Y_size.bytes)]);
    % Cluster Wavelet coefficients calculated over patches -------------
    [z,U,score] = ClusterPatchWaveletCoeff(Y, 8, 100, 1/10);
    disp('Following are the sizes of the label vector and the Cluster matrix');
    z_size = whos('z');
    U_size = whos('U');
    bytes_after_clust_patch = z_size.bytes + U_size.bytes;
    disp(['Y compression using clustering over patches of wavelet coeff; Original size: ', num2str(Cb_size.bytes), '  Compressed size: ', num2str(bytes_after_clust_patch)]);
    I_Comp.z3 = z;
    I_Comp.U3 = U;
    
    [z,U,score] = ClusterPatchWaveletCoeff(Cb, 8, 50, 1/25);
    disp('Following are the sizes of the label vector and the Cluster matrix');
    z_size = whos('z');
    U_size = whos('U');
    
    bytes_after_clust_patch = z_size.bytes + U_size.bytes;
    disp(['Cb compression using clustering over patches of wavelet coeff; Original size: ', num2str(Cb_size.bytes), '  Compressed size: ', num2str(bytes_after_clust_patch)]);
    I_Comp.z1 = z;
    I_Comp.U1 = U;
    
    [z,U,score] = ClusterPatchWaveletCoeff(Cr, 8, 50, 1/25);
    I_Comp.z2 = z;
    I_Comp.U2 = U;
    z_size = whos('z');
    U_size = whos('U');
    bytes_after_clust_patch = z_size.bytes + U_size.bytes;
    disp(['Cr compression using clustering over patches of wavelet coeff; Original size: ', num2str(Cr_size.bytes), '  Compressed size: ', num2str(bytes_after_clust_patch)]);
    
    
    
    % Cluster Wavelet coefficients calculated over patches ends --------
    
    % Performing k-means clustering on the complete matrix of wavelet coefficients
    %{
    [z, U, score] = ClusterWaveletCoeff(Cb, 8, 100, 1/200);
    disp('Following are the sizes of the label vector and the Cluster matrix');
    z_size = whos('z')
    U_size = whos('U')
    
    bytes_after_clust = z_size.bytes + U_size.bytes;
    disp(['compression wavelet coeff using clustering: ', num2str(Cb_size.bytes), ' ', num2str(bytes_after_clust)]);
    I_Comp.z1 = z;
    I_Comp.U1 = U;
    %}
    %{
    Cb = sparse(Cb);
    disp('Size of Cb after wavelet compression and using sparse representation');
    Cb_size_after = whos('Cb')
    
    disp(['compression CbCr: ', num2str(Cb_size.bytes), ' ', num2str(Cb_size_after.bytes)])
    %}
   
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



