function I_rec = Decompress_PWC(I_Comp)

if length(I_Comp.S) > 2
        
    m = I_Comp.S(1); n = I_Comp.S(2);
    levels = 4;
    Y_B = I_Comp.Y_B;
    Y_zr = I_Comp.Y_zr;
    Y_meta = I_Comp.Y_meta;
    
    Y = RLRDecode(Y_B,Y_zr, Y_meta);
    Y = Unzigzag(Y, levels, m, n);
    %Y = EntropyDecodeSPIHT(Y, 4);
    % Y = waveletcdf97(double(Y), -4);
    Y = DeQuantize(Y,16);
    %figure('Name','Dequantized'), imshow(Y); impixelregion;
    
    Y = CDFDecompress(double(Y), levels, 'cdf97');
    Y = Y(1:m,1:n);
    
    % -------------
    Cb_B = I_Comp.Cb_B;
    Cb_zr = I_Comp.Cb_zr;
    Cb_meta = I_Comp.Cb_meta;
   
    
    Cb = RLRDecode(Cb_B, Cb_zr, Cb_meta);
    Cb = Unzigzag(Cb, levels,m,n);
    %Cb = EntropyDecodeSPIHT(Cb, 5);    
    Cb = DeQuantize(Cb,16);
    Cb = CDFDecompress(Cb, levels, 'cdf97');
    Cb = Cb(1:m,1:n);
    
    Cr_B = I_Comp.Cr_B;
    Cr_zr = I_Comp.Cr_zr;
    Cr_meta = I_Comp.Cr_meta;
   
    
    Cr = RLRDecode(Cr_B, Cr_zr, Cr_meta);
    Cr = Unzigzag(Cr, levels,m,n);
    %Cr = EntropyDecodeSPIHT(Cr, 5);
    Cr = DeQuantize(Cr,16);
    Cr = CDFDecompress(Cr, levels, 'cdf97');
    Cr = Cr(1:m,1:n);
    
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
