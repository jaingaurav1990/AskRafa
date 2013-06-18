function I_rec = Decompress(I_comp)

% Your decompression code goes here!
m = I_comp.S(1);
n = I_comp.S(2);
channels = I_comp.S(3);
N = I_comp.S(4);
I_rec = zeros(m,n,channels);
Img = zeros(N,N);

for chan=1:channels
    
   idx = 1;
   ROWS = N;
   COLS = N;
   pw = 4;
   pl = pw*pw;
   H = haarTrans(pw);
   if (chan == 1)
       %Z = full(I_comp.red_trans);
       %I_red_trans = Z;
       z = I_comp.red_trans.z;
       U = full(I_comp.red_trans.U);
    elseif (chan == 2)
        z = I_comp.green_trans.z;
        U = full(I_comp.green_trans.U);
    else
        z = I_comp.blue_trans.z;
        U = full(I_comp.blue_trans.U);
   end
   
   for row = 1:pw:ROWS,
       for col = 1:pw:COLS,
               Tmp = reshape(U(1:pl, z(idx)), pw, pw);
               Img(row:row + pw - 1, col:col + pw - 1) = H'*Tmp*H;
               idx = idx + 1;
        end
    end

    
    %size(Z);
    %H = haarTrans(N);
    %Img = H'*Z*H;
    %I = Img(1:m,1:n);
    I_rec(:,:,chan) = Img(1:m,1:n);
end    

% Uncomment following to view decompressed images
figure,imshow(I_rec);
%I_rec = I_comp.I; % this is just a stump to make the evaluation script run, replace it with your code!