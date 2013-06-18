function I_rec = Decompress(I_Comp)



if length(I_Comp.S) > 2
    
    %Y = double(I_Comp.Y);
    % Handling clustered wavelet coefficients ---------
    %Cb = ReconFromUz(I_Comp.z1, I_Comp.U1, 8, I_Comp.S(1), I_Comp.S(2));
    %Cr = ReconFromUz(I_Comp.z2, I_Comp.U2, 8, I_Comp.S(1), I_Comp.S(2));
    % Handling clusterd wavelet coefficients ends -----
    
    
    
    
    I(:,:,1) = DeClusterPatchWaveletCoeff(I_Comp.z3, I_Comp.U3, 8, I_Comp.S(1), I_Comp.S(2));
    I(:,:,2) = DeClusterPatchWaveletCoeff(I_Comp.z1, I_Comp.U1, 8, I_Comp.S(1), I_Comp.S(2));
    I(:,:,3) = DeClusterPatchWaveletCoeff(I_Comp.z2, I_Comp.U2, 8, I_Comp.S(1), I_Comp.S(2));
    
    I = YCbCrToRGB(I);
    figure('Name', 'Reconstructed Image'), imshow(I)
else
   I = full(I_Comp.I);
   
   I = DeClusterPatchWaveletCoeff(I_Comp.z1, I_Comp.U1, 8, I_Comp.S(1), I_Comp.S(2));
   
   % Clustering over wavelet coefficient matrix ----------------------
   %I = ReconFromUz(I_Comp.z1, I_Comp.U1, 8, I_Comp.S(1), I_Comp.S(2));
   %I = DecompressWavelet(I, I_Comp.S(1), I_Comp.S(2));
   % Clustering over wavelet coefficient matrix ends -----------------
   figure('Name', 'BW image reconstructed'), imshow(I)
end


I_rec = I;
%DecompressDownsampling(I_Comp);