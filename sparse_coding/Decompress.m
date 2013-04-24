function I_rec = Decompress(I_comp)

% Your decompression code goes here!
m = I_comp.S(1);
n = I_comp.S(2);
channels = I_comp.S(3);
N = I_comp.S(4);
I_rec = zeros(m,n,channels);

for chan=1:channels
    if (chan == 1)
       Z = full(I_comp.red_trans);
       I_red_trans = Z;
    elseif (chan == 2)
        Z = full(I_comp.green_trans);
        I_green_trans = Z;
    else
        Z = full(I_comp.blue_trans);
        I_blue_trans = Z;
    end
    
    %figure,imshow(Z);
    size(Z);
    H = haarTrans(N);
    %Z1 = Z*H;
    Img = H'*Z*H;
    I = Img(1:m,1:n);
    I_rec(:,:,chan) = Img(1:m,1:n);
    %figure,imshow(I);
    %I_rec(:,:,chan) = Img(1:m, 1:n);
    
end
%figure, imshow(I_red_trans);
%figure, imshow(I_green_trans);
%figure, imshow(I_blue_trans);
% Uncomment following to view decompressed images
%figure,imshow(I_rec);
%I_rec = I_comp.I; % this is just a stump to make the evaluation script run, replace it with your code!