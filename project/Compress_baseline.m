function I_Comp = Compress_baseline(I)

I_Comp.S = size(I);

if length(I_Comp.S) > 2
    I = RGBToYCbCr(I);
    I_Comp.Y = I(:,:,1);
   % CbCr = I(:,:,2:3);
   % Y = I(:,:,1);
    
   % CbCr_size = whos('CbCr');
   % Y_size = whos('Y');
      
    %CbCr = Downsample(CbCr);
    I_Comp.size = size(I);
    %CbCr = CompressWavelet(CbCr,35); 
    %I_Comp.Cb = sparse(keep(waveletcdf97(double(I(:,:,2)), 5),1/50));
    %I_Comp.Cr = sparse(keep(waveletcdf97(double(I(:,:,3)), 5),1/50));
    
    %I = waveletcdf97(double(I), 5);    
    %I = keep(I,1/50);
   
    Cb = I(:,:,2);
    Cr = I(:,:,3);
    
    Cb_size = whos('Cb');
    
    Cb = CompressWavelet(Cb);
    Cb = keep(Cb, 1/502);
    Cr = CompressWavelet(Cr);
    Cr = keep(Cr, 1/502);
    
    I_Comp.Cb = sparse(Cb);
    I_Comp.Cr = sparse(Cr);
    
    Cb = I_Comp.Cb;
    Cb_size_after = whos('Cb');
    
    disp(['compression CbCr: ', num2str(Cb_size.bytes), ' ', num2str(Cb_size_after.bytes)])
    %sum(sum(I(:,:,1) ~= 0))
    %sum(sum(I(:,:,2) ~= 0))
   % sum(sum(I(:,:,3) ~= 0))
    %size(I_Comp.Cr)
    %numel(nonzeros(I_Comp.Cb))
     %numel(nonzeros(I_Comp.Cr))
    %tmp = I_Comp.Y;
    %whos('tmp')
   % I = sparse(reshape(I,1,[]));

    %
    %Y = CompressPCA(double(Y)/255);
   % CbCr_size_after = whos('CbCr');
   % Y_size_after = whos('Y');
   %disp(['compression I: ', num2str(I_size.bytes), ' ', num2str(I_size_after.bytes)])
   % disp(['compression CbCr: ', num2str(CbCr_size.bytes), ' ', num2str(CbCr_size_after.bytes)])
   % disp(['compression Y: ', num2str(Y_size.bytes), ' ', num2str(Y_size_after.bytes)])
   % whos('Y')
   % whos('CbCr')
   % I_Comp.I = I;
   % I_Comp.Y = Y;
   % I_Comp.CbCr = CbCr;
else
    I = CompressWavelet(I);
    I = keep(I, 1/25);
    I_Comp.I = sparse(I);
end



