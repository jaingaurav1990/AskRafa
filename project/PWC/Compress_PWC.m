function I_Comp = Compress_PWC(I)

I_Comp.S = size(I);

if length(I_Comp.S) > 2
    
    I = RGBToYCbCr(I);
    %I = I*255;
    %Compress Luminance
    
    Y = I(:,:,1);
    Y_size = whos('Y');    
    %disp('Analyzing Channel Y');
    %AnalyzeChannel(Y);
    %Y = waveletcdf97(double(Y), 4); 
    levels = 4;
    Y = Pad(Y, levels);
    Y = CDFCompress(double(Y), levels,'cdf97');
    %figure('Name','Before quantizing'), imshow(Y); impixelregion;
    Y = Quantize(Y, 16);
    Y_Z = Zigzag(Y, levels); % Note that Zigzag does padding if dimensions are not a multiple of 2 ^ levels
    [Y_B,Y_zr,Y_meta] = RLREncode(int16(Y_Z));
    %figure('Name', 'Quantized image'), imshow(Y); impixelregion; 
    %figure('Name','Coefficient matrix'); imshow(Y);
    %max_bits = round((size(Y,1)^2)*1);
    %Y = EntropyEncodeSPIHT(Y, round(max_bits*2), 4);  
    
    I_Comp.Y_B = Y_B;
    I_Comp.Y_zr = Y_zr;
    I_Comp.Y_meta = Y_meta;
    
    s1 = whos('Y_B');
    s2 = whos('Y_zr');
    s3 = whos('Y_meta');
   
    disp(['compression Y: ', num2str(Y_size.bytes), ' ', num2str(s1.bytes + s2.bytes + s3.bytes)])
    %               
    %Compress Cb and Cr
    Cb = I(:,:,2);
    Cr = I(:,:,3);
    Cb_size = whos('Cb')
        
    %Cb = waveletcdf97(double(Cb), 5);   
    Cb = Pad(Cb, levels);
    Cb = CDFCompress(double(Cb), levels,'cdf97');
    Cb = Quantize(Cb,16);
    Cb_Z = Zigzag(Cb, levels);
    [Cb_B, Cb_zr, Cb_meta] = RLREncode(int16(Cb_Z));
    %Cb= EntropyEncodeSPIHT(Cb, round(max_bits/4), 5);
    
    I_Comp.Cb_B = Cb_B;
    I_Comp.Cb_zr = Cb_zr;
    I_Comp.Cb_meta = Cb_meta;
    
    s1 = whos('Cb_B');
    s2 = whos('Cb_zr');
    s3 = whos('Cb_meta');
    %Cr = waveletcdf97(double(Cr), 5);    

    Cr = Pad(Cr, levels);
    Cr = CDFCompress(double(Cr), levels,'cdf97');
    Cr = Quantize(Cr,16);
    Cr_Z = Zigzag(Cr, levels);
    [Cr_B, Cr_zr, Cr_meta] = RLREncode(int16(Cr_Z));
    
    disp(['compression Cb: ', num2str(Cb_size.bytes), ' ', num2str(s1.bytes + s2.bytes + s3.bytes)])

    I_Comp.Cr_B = Cr_B;
    I_Comp.Cr_zr = Cr_zr;
    I_Comp.Cr_meta = Cr_meta;

    total_size_after = whos('I_Comp');
     disp(['total: ', num2str(total_size_after.bytes)])
   
    I_Comp.size = size(I);    
else
    
    I_size = whos('I'); 
    
    
    I = CDFCompress(double(I), 4,'cdf97');
    %I = waveletcdf97(double(I), 4); 
    max_bits = round((size(I,1)^2)*1);
    I = EntropyEncodeSPIHT(I, round(max_bits*2), 4);
    
    I_size_after = whos('I');
    disp(['compression B&W: ', num2str(I_size.bytes), ' ', num2str(I_size_after.bytes)])
    I_Comp.I = I;
end





