function I_rec = YCbCrToRGB(I)
   


% I = min(max(I,-1),1);
% M = inv([0.299,0.587,0.114;-0.168736,-0.331264,0.5;0.5,-0.418688,-0.081312]);
% Y = I(:,:,1); Cb = I(:,:,2); Cr = I(:,:,3);
% I_rec(:,:,1) = M(1)*Y + M(4)*Cb + M(7)*Cr;  % Red channel
% I_rec(:,:,2) = M(2)*Y + M(5)*Cb + M(8)*Cr;  % Green channel
% I_rec(:,:,3) = M(3)*Y + M(6)*Cb + M(9)*Cr;  % Blue channel
% I_rec = min(max(I_rec,0),1);  % Clip result to [0,1]

    Cb = double(I(:,:,2));
    Cr = double(I(:,:,3));

   % rotate back to RGB
   Y = double(I(:,:,1));
   %red
   I_rec(:,:,1) = uint8(Y + 1.402  *(Cr-128));
   %green
   I_rec(:,:,2) = uint8(Y - 0.34414*(Cb-128) - 0.71414*(Cr-128));
   %blue
   I_rec(:,:,3) = uint8(Y + 1.772  *(Cb-128));

   %scale back to <0,1> interval
   I_rec = double(I_rec) / 255;
   
   
   