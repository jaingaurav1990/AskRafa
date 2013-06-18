function I_Comp = Compress(I)

I_Comp.S = size(I);

if length(I_Comp.S) > 2
    
    I = RGBToYCbCr(I);
    %I = I*255;
    %Compress Luminance
    I_Comp.Y = I(:,:,1);
    Y = I_Comp.Y;
    Y_size = whos('Y')    
    disp('Analyzing Channel Y');
    AnalyzeChannel(Y);
    %Y = waveletcdf97(double(Y), 4);      
    Y = CDFCompress(double(Y), 4,'cdf97');
    figure('Name','Coefficient matrix'); imshow(Y);
    max_bits = round((size(Y,1)^2)*1);
    Y = EntropyEncodeSPIHT(Y, round(max_bits*2), 4);  
    
    I_Comp.Y = Y;
    
    Y = I_Comp.Y;
    Y_size_after = whos('Y')
    disp(['compression Y: ', num2str(Y_size.bytes), ' ', num2str(Y_size_after.bytes)])
    %               
    %Compress Cb and Cr
    Cb = I(:,:,2);
    disp('Analyzing Channel Cb');
    %AnalyzeChannel(Cb);
    Cr = I(:,:,3);
    disp('Analyzing Channel Cr');
    %AnalyzeChannel(Cr);
    Cb_size = whos('Cb')
        
    %Cb = waveletcdf97(double(Cb), 5);    
    Cb = CDFCompress(double(Cb), 5,'cdf97');
    Cb= EntropyEncodeSPIHT(Cb, round(max_bits/4), 5);
    
    %Cr = waveletcdf97(double(Cr), 5);    
    Cr = CDFCompress(double(Cr), 5,'cdf97');
    Cr= EntropyEncodeSPIHT(Cr, round(max_bits/4), 5);
    
    I_Comp.Cb = Cb;
    I_Comp.Cr = Cr;
    
    Cb = I_Comp.Cb;
    Cb_size_after = whos('Cb')
    disp(['compression Cb: ', num2str(Cb_size.bytes), ' ', num2str(Cb_size_after.bytes)])


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



