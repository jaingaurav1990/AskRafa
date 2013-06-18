function I_rec = Decompress(I_Comp)

if length(I_Comp.S) > 2
        
    Y = I_Comp.Y;    
    Y = EntropyDecodeSPIHT(Y, 4);
   % Y = waveletcdf97(double(Y), -4);
    Y = CDFDecompress(double(Y), 4, 'cdf97');
    
    Cb = I_Comp.Cb;      
    Cb = EntropyDecodeSPIHT(Cb, 5);    
    Cb = CDFDecompress(Cb, 5, 'cdf97');
    
    Cr = I_Comp.Cr;
    Cr = EntropyDecodeSPIHT(Cr, 5);
    Cr = CDFDecompress(Cr, 5, 'cdf97');
    
    I(:,:,1) = double(Y);
%    I(:,:,2) = waveletcdf97(Cb, -5);
    I(:,:,2) = double(Cb);
    
 %   I(:,:,3) = waveletcdf97(Cr, -5);
    I(:,:,3) = double(Cr);
    

    I = YCbCrToRGB(I);
    %I = I/255;
else
   
   I = EntropyDecodeSPIHT(I_Comp.I, 4);   
   I = CDFDecompress(double(I), 4, 'cdf97');
   %I = waveletcdf97(double(I), -4);
end

I_rec = I;
