function I_rec = Decompress(I_comp)

% Your decompression code goes here!
z = I_comp.z; U = I_comp.U;
nExamples = size(z,2);
nClusters = size(U,2);
R = zeros(nClusters, nExamples);
id = [0:(nExamples-1)];
id = id.*nClusters;
n_id = z + id;
R(n_id) = 1;
data = U*R;

m = I_comp.S(1);
n = I_comp.S(2);
channels = I_comp.S(3);
I_rec = zeros(m,n,channels);
for chan=1:channels
    assign = data(chan,:);
    assign = reshape(assign, m,n);
    I_rec(:,:,chan) = assign;
end
% Uncomment following to view decompressed images
%figure,imshow(I_rec);
%I_rec = I_comp.I; % this is just a stump to make the evaluation script run, replace it with your code!