function [ I_rec ] = DeCompress_WebP( I_Comp )

if length(I_Comp.S) > 2
        
    I(:,:,1) = OriginalFromResidue(I_Comp.ResCoeff_Y, I_Comp.mb_width, I_Comp.sb_width, I_Comp.S(1), I_Comp.S(2), I_Comp.mode);
    I(:,:,2) = OriginalFromResidue(I_Comp.ResCoeff_Cb, I_Comp.mb_width, I_Comp.sb_width, I_Comp.S(1), I_Comp.S(2), I_Comp.mode);
    I(:,:,3) = OriginalFromResidue(I_Comp.ResCoeff_Cr, I_Comp.mb_width, I_Comp.sb_width, I_Comp.S(1), I_Comp.S(2), I_Comp.mode);
   
    % Additionally perform loop-filtering to remove blocking artifacts
    I = YCbCrToRGB(I);
    figure('Name', 'Reconstructed Image'), imshow(I)
else
   I = full(I_Comp.I);
   
   I = DeCompressWavelet(I_Comp);
   figure('Name', 'BW image reconstructed'), imshow(I)
end


I_rec = I;

end