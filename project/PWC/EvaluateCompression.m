% Measure approximation error and compression ratio for several images.
%
% NOTE Images must be have .jpg ending and reside in the same folder.

file_list = dir(); 
k = 1;

Errors = []; % mean squared errors for each image would be stored here
Comp_rates = []; % compression rate for each image would be stored here

for i = 3:length(dir) % runing through the folder
    
    file_name = file_list(i).name; % get current filename
    
    if(max(file_name(end-3:end) ~= '.jpg')) % check that it is an image
        continue;
    end
    
    % Read image, convert to double precision and map to [0,1] interval
    I = imread(file_name); 
    I = double(I) / 255; 
    
    size_orig = whos('I'); % size of original image
    size_orig
    tic
    I_comp = Compress_PWC(I);
    I_rec = DeCompress_PWC(I_comp);
    %I_comp = Compress(I);
    %I_rec = Decompress(I_comp);
    %I_comp = Compress_WebP(I);
    %I_rec = DeCompress_WebP(I_comp);
    toc
    
    figure()
    imshow(I); title('original');
    
    figure()
    imshow(I_rec); title('rec');
    
    
    %I_comp = Compress_ClustPatchesWaveletCoeff(I); % compress image
    %I_rec = Decompress_ClustPatchesWaveletCoeff(I_comp);
    %I_comp = Compress_baseline(I);
    %I_rec = Decompress_baseline(I_comp); % decompress it
    
    % Measure approximation error
    Errors(k) = mean(mean(mean( ((I - I_rec) ).^2)));

    % Measure compression rate
    size_comp = whos('I_comp'); % size of compresseed image
    disp(['Size of the compressed image: ' num2str(size_comp.bytes)])
    Comp_rates(k) = size_comp.bytes / size_orig.bytes; 
    
    k = k+1;
    
end

Result(1) = mean(Errors);
Result(2) = mean(Comp_rates);

disp(['Average quadratic error: ' num2str(Result(1))])
disp(['Average compression rate: ' num2str(Result(2))])