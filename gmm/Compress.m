function I_comp = Compress(I)

% Your compression code goes here

% Feature Extraction
% Convert the M*N*3 image into 3*(M*N) 2-D array OR 1*(M*N) 1-D array for a
% gray-scale image
[m,n,channels] = size(I);
I = shiftdim(I, 2);
I = reshape(I, channels, m*n);

K = [20];
[z, U, loglike, Z] = gmm_template(I,10);
I_comp.z = z; I_comp.U = U;I_comp.S = [m,n,channels];

%I_comp.I = I; % this is just a stump to make the evaluation script run, replace it with your code!
