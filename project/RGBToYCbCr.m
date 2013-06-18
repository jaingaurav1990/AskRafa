function I = RGBToYCbCr(I)

%    M = [0.299,0.587,0.114;-0.168736,-0.331264,0.5;0.5,-0.418688,-0.081312];
% R = I(:,:,1); G = I(:,:,2); B = I(:,:,3);
% I(:,:,1) = M(1)*R + M(4)*G + M(7)*B;  % Intensity Y channel
% I(:,:,2) = M(2)*R + M(5)*G + M(8)*B;  % Blue chroma Cb channel
% I(:,:,3) = M(3)*R + M(6)*G + M(9)*B;  % Red chroma Cr channel
% I = min(max(I,-1),1);  % Clip result to [-1,1]
   

   % convert back to uint8 representation
   I = uint8(I*255);
   
   r = I(:,:,1);
   g = I(:,:,2);
   b = I(:,:,3);
   
   % rotate to YCbCr
   %Y
   I(:,:,1)  = uint8(      0.299   *r +  0.587   *g  +  0.114   *b);
   %Cb
   I(:,:,2) = uint8(128 - 0.168736*r -  0.331264*g  +  0.5     *b);
   %Cr
   I(:,:,3) = uint8(128 + 0.5     *r -  0.418688*g  -  0.081312*b);
