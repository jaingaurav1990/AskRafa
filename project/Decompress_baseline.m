function I_rec = Decompress_baseline(I_Comp)



if length(I_Comp.S) > 2
    
    Y = double(I_Comp.Y);
    Cb = full(I_Comp.Cb);
    Cr = full(I_Comp.Cr);
    
    I(:,:,1) = Y;
    I(:,:,2) = DecompressWavelet(Cb, I_Comp.S(1), I_Comp.S(2));
    I(:,:,3) = DecompressWavelet(Cr, I_Comp.S(1), I_Comp.S(2));
    %I(:,:,2) = waveletcdf97(Cb, -5);
    %I(:,:,3) = waveletcdf97(Cr, -5);
    %Y = I_Comp.Y;
    %CbCr = I_Comp.CbCr;
    
    %Y = round(DecompressPCA(Y)*255);
    %I(:,:,1) = I_Comp.Y;
    %CbCr =  DecompressWavelet(CbCr);
    %I = waveletcdf97(I, -5);
   %CbCr = Upsample(CbCr, size(Y,1), size(Y,2));

    %I(:,:,1) = Y;
    %I(:,:,2:3) = CbCr;
    I = YCbCrToRGB(I);
else
   I = full(I_Comp.I);
   I = DecompressWavelet(I, I_Comp.S(1), I_Comp.S(2));
end


I_rec = I;
%DecompressDownsampling(I_Comp);