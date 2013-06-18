function Y = EntropyEncodeSPIHT(m, max_bits, level)
%%
% Embedded Sot Encoding Algorithm: Embedded Coding
% in Spatial Orientation Trees–The SPIHT Algorithm.

% based on pseudocode from:
% Foundations and Trends in Signal Processing
% Vol. 2, No. 2 (2008) 95–180
%W. A. Pearlman and A. Said

% m - input matrix obtained from wavelet transform
% max_bits - maximum bit that we want to spend on encoding, actual number
%            used is usually lower
% level - how many levels (stages) the wavelet transform contains

%%

[size_m_orig, size_n_orig] = size(m);

m = TreeTransform(m, level, 'fw', size_m_orig, size_n_orig);
%size(m)
%[m, levelWidth_m, levelWidth_n] = TreeTransformFW(m, level);
%figure(); imshow(m/max(max(m)));

%m = TreeTransformBW(m,level,size_m_orig, size_n_orig);
%figure(); imshow(m/max(max(m)));

%return;
[size_m, size_n] = size(m);

%assert(size_m == size_n, 'matrix has to be square')
%assert(2^nextpow2(size_m) == size_m, 'size has to be power of two');

size_m_c = uint16(ceil((size_m + 1)/4));
size_n_c = uint16(ceil((size_n + 1)/4));

m_abs = abs(m);
out = uint8(zeros(max_bits,1));
n_max = floor(log2(max(max(m_abs))));

% image size, bit planes, level
metadata = [size_m size_n n_max size_m_orig size_n_orig];
ctr = 1;

Y.metadata = metadata;

% (1) Initialization: output n = log2 max(i,j){|ci,j|}; 
% set the LSP as an empty list, and 
% add the coordinates (i, j)?H to the LIP, and only those with descendants also to the LIS, as type A entries.
levelWidth_m = size_m/2^(level-1);
levelWidth_n = size_n/2^(level-1);
% levelWidth_m = 2^(log2(size_m) - level + 1)
% levelWidth_n = 2^(log2(size_n) - level + 1)

tmp = repmat(1:levelWidth_m, levelWidth_n,1);
LIP(:, 1) = tmp(:);
LIP(:, 2) = repmat((1:levelWidth_n)', levelWidth_m,1);
LIS(:, 1) = LIP(:, 1);
LIS(:, 2) = LIP(:, 2);
LIS(:, 3) = zeros(length(LIP(:, 1)), 1);

LIS(repmat(1:levelWidth_n/2,levelWidth_m/2,1) + repmat((0:levelWidth_n:levelWidth_n*levelWidth_m/2 - 1)',1,levelWidth_n/2),:) = [];

LIS = uint16(LIS);   

newLIS = uint16(zeros(10000,3));

LSP = zeros(60000,1);
LSP_idx = 1;

LIP = m(LIP(:,1)+(LIP(:,2)-1)*size_m);

%LIP = uint16(LIP);

n = n_max;

% Precompute tree subsections significance
% we go bottom-up
m_desc = zeros(size_m, size_n);

siz_m = int32(size_m);
siz_n = int32(size_n);
for i = 1:level
        
    x = siz_m/2+1:siz_m;
    for y = 1:2:siz_n/2            
            m_abs(x,y:y+1);
            tmp1 = max(reshape(max(m_abs(x,y:y+1),[],2),2,[]));
            tmp2 = max(reshape(max(m_desc(x,y:y+1),[],2),2,[]));
     
            size( m_desc(siz_m/4+1:siz_m/2,y));
            size(max(tmp1,tmp2)');
            m_desc(siz_m/4+1:siz_m/2,(y+1)/2) = max(tmp1,tmp2)';     
    end
    
    x = 1:siz_m/2;
    for y = 1:2:siz_n       
            tmp1 = max(reshape(max(m_abs(x,y:y+1),[],2),2,[]));
            tmp2 = max(reshape(max(m_desc(x,y:y+1),[],2),2,[]));
            
            m_desc(1:siz_m/4,(y+1)/2) = max(tmp1,tmp2)';
    end
    
    siz_m = siz_m/2;
    siz_n = siz_n/2;
end    

newLIP = zeros(15000,1);
newLIP_idx=1;

newPixels = zeros(30000,1);
% end precompute

while(ctr < max_bits)
    two_exp_n = 2^n;
   % tic
    LSP_idx_start = LSP_idx; 
    % there are two kinds of splitting, one that produces
    % Type A LIS entries, indicating all descendants of the root, and one
    % producing Type B LIS entries, indicating grand-descendant sets. The
    % initial tree and the descendants of a child node are Type A sets.
   % disp('Sorting pass (a)')
   % tic
    % (2) Sorting pass
    % (a) for each entry (i, j) in the LIP do:
    to_remove = [];
    %[count, symbols] = hist(double(LIP),unique(double(LIP)))
%     for i = 1:size(LIP,1)    
%         % i. output ?n(i, j);
%         isSignificant = abs(LIP(i)) >= two_exp_n;
%         %out(ctr) = isSignificant; 
%         %ctr = ctr +1;       
%         
%         % ii. if ?n(i, j) = 1 then move (i, j) to the LSP and output the sign of ci,j ;
%         if isSignificant == 1 % 1: positive; 0: negative            
%             %sgn = LIP(i)>=0;
%             %out(ctr) = sgn; ctr = ctr +1;
% 
%             %LSP = [LSP; LIP(i,:)];
%             LSP(LSP_idx) = LIP(i);
%             LSP_idx = LSP_idx + 1;
%             to_remove = [to_remove i];
%         end
%     end
  
    areSignificant = (abs(LIP) >= two_exp_n);

    out(ctr:ctr+size(LIP,1)-1) = areSignificant;
    ctr = ctr +size(LIP,1);
    
    num_significant = sum(areSignificant);
    LSP(LSP_idx:LSP_idx+num_significant-1) = LIP(areSignificant);
    LSP_idx = LSP_idx + num_significant;
    
    LIP(areSignificant) = [];
    
    
    
  %  toc
    %size(LIP)
 % tic  
    newPixels_idx = 1;
    
    newLIS_idx = 1;
    newLIP_idx=1;
    %(b) for each entry (i, j) in the LIS do:                  
   to_remove = [];
   i = 1;
 while (1)   
    while ( i <= size(LIS,1))
        x = LIS(i,1);
        y = LIS(i,2);
        type = LIS(i,3);
        
        % i. if the entry is of type A then
        if type == 0       
            % • output ?n(D(i, j));            
%             if (descendantsValueMemoized(x,y) == -1)
%                 max_d = MaxDescendant(x,y,type,m, two_exp_n);
%                 descendantsValueMemoized(x,y) = max_d;
%             end
%             max_d = descendantsValueMemoized(x,y);
            max_d = m_desc(x,y);
            isSignificant = (max_d >= two_exp_n);            
            out(ctr) = isSignificant; ctr = ctr +1;
            
            % • if ?n(D(i, j)) = 1 then
            if isSignificant == 1
                         
                % — for each (k, l) ? O(i, j) do:
                %O = [2*x-1 2*y-1; 2*x-1 2*y; 2*x 2*y-1; 2*x 2*y];
                O = [m(2*x-1, 2*y-1); m(2*x-1, 2*y); m(2*x, 2*y-1); m(2*x, 2*y)];
                %newPixels(newPixels_idx:newPixels_idx+3) = [m(2*x-1, 2*y-1); m(2*x-1, 2*y); m(2*x, 2*y-1); m(2*x, 2*y)];
                %newPixels_idx = newPixels_idx + 4;
                
                areSignificant = (abs(O) >= two_exp_n);

                out(ctr:ctr+3) = areSignificant;
                ctr = ctr+4;
                
                num_significant = sum(areSignificant);
                LSP(LSP_idx:LSP_idx+num_significant-1) = O(areSignificant);
                LSP_idx = LSP_idx + num_significant;
                
                newLIP(newLIP_idx:newLIP_idx +(4-num_significant)-1) = O(~areSignificant);
                newLIP_idx = newLIP_idx +(4-num_significant);
                
%                 for j = 1:4
%                     k = O(j,1);
%                     l = O(j,2);
%                 
%                     % ? output ?n(k, l);                                
%                     isSignificant = (m_abs(k,l) >= two_exp_n);
%                     out(ctr) = isSignificant;  ctr = ctr +1;                        
%                     
%                     if isSignificant == 1
%                         % ? if ?n(k, l) = 1 then add (k, l) to the LSP and output the sign of ck,l;
%                         %LSP = [LSP; k,l];
%                         LSP(LSP_idx) = m(k,l);
%                         LSP_idx = LSP_idx + 1;
%                         
%                         %sgn = m(k,l)>=0;
%                         %out(ctr) = sgn; ctr = ctr +1;                        
%                     else                
%                         % ? if ?n(k, l) = 0 then add (k, l) to the end of the LIP;
%                         %LIP = [LIP; k,l];
%                         newLIP(newLIP_idx) = m(k, l);
%                         newLIP_idx = newLIP_idx +1;
%                     end
%                 end
                                
                % — if L(i, j) != ? then move (i, j) to the end of the LIS, as an entry of type B; 
                %otherwise, remove entry (i, j) from the LIS;
                %if ((2*(2*x)-1) < size(m) & (2*(2*y)-1) < size(m))                
                if (x < size_m_c && y < size_n_c)
                    LIS(i,3) = 1;
                    i = i - 1;
                else
                    to_remove = [to_remove i];
                end

            end
        % ii. if the entry is of type B then
        %end
        %if type == 1
        else
            % • output ?n(L(i, j));
%             if (descendantsValueMemoized(x, y) == -1)
%                 max_d = MaxDescendant(x, y, type,m, two_exp_n);
%                 descendantsValueMemoized(x, y) = max_d;
%             end
%             max_d = descendantsValueMemoized(x, y);                        
            max_d = m_desc(x,y);
            isSignificant = (max_d >= two_exp_n);
            out(ctr) = isSignificant; ctr = ctr +1;           
            
            % • if ?n(L(i, j)) = 1 then
            if isSignificant == 1               
                %— add each (k, l) ? O(i, j) to the end of the LIS as an entry of type A;                             
                %LIS = [LIS; 2*x-1 2*y 0; 2*x 2*y-1 0; 2*x 2*y 0];              
                
                newLIS(newLIS_idx:newLIS_idx+2,:) = [2*x-1 2*y 0; 2*x 2*y-1 0; 2*x 2*y 0];
                newLIS_idx = newLIS_idx + 3;
                
                LIS(i,:) = [2*x-1 2*y-1 0];
                i = i - 1;
                %— remove (i, j) from the LIS.
               %to_remove = [to_remove i];
            end
        end
        
        i = i+1;
    end
    
    if (newLIS_idx > 1)
        LIS = [LIS; newLIS(1:newLIS_idx-1,:)];
        newLIS_idx = 1;
    else
        break
    end
    
 end  
 %newPixels_idx
%     areSignificant = (abs(newPixels(1:newPixels_idx-1)) >= two_exp_n);
% 
%     out(ctr:ctr+newPixels_idx-2) = areSignificant;
%     ctr = ctr+newPixels_idx-1;
%                 
%     num_significant = sum(areSignificant);
%     LSP(LSP_idx:LSP_idx+num_significant-1) = newPixels(areSignificant);
%     LSP_idx = LSP_idx + num_significant;
%                 
%     newLIP(newLIP_idx:newLIP_idx +(newPixels_idx-1-num_significant)-1) = newPixels(~areSignificant);
%     newLIP_idx = newLIP_idx +(newPixels_idx-1-num_significant);
    
    
    
%  
    %size(newLIP)
    
    LIP = [LIP; newLIP(1:newLIP_idx-1)];
    size(LIP);
    LIS(to_remove,:) = [];  
   
    % (3) Refinement pass: for each entry (i, j) in the LSP, except those
    % included in the last sorting pass (i.e., with same n), output
    % the nth most significant bit of |ci,j |;
    %tmp = 1;
    
    %n1 = 2^(n_max-n+1);
    %n2 = 2^(n_max+2);
    %value = floor(abs(n1*LSP(tmp)));   
%     if (LSP_idx_start)
%         LSP(3)
%         floor(abs(n1*LSP(3)))
%         bitget(floor(abs(n1*LSP(3))),n_max+2)
%     end
        
    %while (value >= n2 && (tmp < LSP_idx))   
%      for tmp=1:LSP_idx_start-1
%          value = floor(abs(n1*LSP(tmp)));   
%          s = bitget(value,n_max+2);
%          out(ctr) = s; ctr = ctr +1;             
%      end  
%toc
%tic
    
    % signs
    out(ctr:ctr+(LSP_idx-LSP_idx_start)-1) = LSP(LSP_idx_start:LSP_idx-1) >= 0;
    ctr = ctr + (LSP_idx-LSP_idx_start);
    
    LSP(LSP_idx_start:LSP_idx-1) = abs(LSP(LSP_idx_start:LSP_idx-1));
    
    % Refinement pass
    if (LSP_idx_start>1)        
        out(ctr:ctr+LSP_idx_start-2) = LSP(1:LSP_idx_start-1) >= 2^n;
        ctr = ctr + LSP_idx_start-1;        
    end
    
     dec_idx = LSP >= 2^n;
     LSP(dec_idx) = LSP(dec_idx) - 2^n;
 % toc  
  if 2*ctr >= max_bits  
      
       n       
%         n = n - 1;
%         
%         tmp = 1;
%         n1 = 2^(n_max-n+1);
%         n2 = 2^(n_max+2);
%         value = floor(abs(n1*m(LSP(tmp,1),LSP(tmp,2))));   
%         
%         while (value >= n2 && (tmp < LSP_idx))        
%             s = bitget(value,n_max+2);
%             out(ctr) = s; ctr = ctr +1; 
%         
%             tmp = tmp + 1;
%             if tmp < LSP_idx
%                 value = floor(abs(n1*m(LSP(tmp,1),LSP(tmp,2))));
%             end
%         end  
      
      if (ctr-1 + 8 - mod(ctr -1, 8) > size(out,1))
         out = [out; zeros(ctr-1 + 8 - mod(ctr -1, 8) - size(out,1),1)];
      else            
         out = double(out(1:ctr-1 + 8 - mod(ctr -1, 8)));
      end
      
       bitmask = [1 2 4 8 16 32 64 128];
       Y.out = bitmask*double(reshape(out, 8, []));

      Y.out = uint8(Y.out);
%      Y.tmp = out;
%      [count, symbols] = hist(double(visited(:)),unique(double(visited(:))))
      
      %visited = (visited ==0);
      %max(max(abs(m(visited))))
      %max(max(abs(m(~visited))))
%       max(max(visited))
 %      visited = visited/max(max(visited));
 %      figure(); imshow(double(visited));
%       Y.tmp = bitmask(1:4)*double(reshape(out, 4, []));
%       Y.tmp = uint8(Y.tmp);
      return
  end
      
    % (4) Threshold update: decrement n by 1 and go to Step 2.
    n = n - 1;
end


% function value = MaxDescendant(i, j, type, m, threshold)
% 
% s = size(m,1);
% idx = 0; 
% 
% a = 0; b = 0;
% value = 0;
% 
% while ((2*i-1)<s && (2*j-1)<s)
%     a = i-1; b = j-1;
%     two_to_idx = 2^idx;
% %     if (type == 1 && idx == 0)
% %         idx = idx + 1;
% %         i = 2*a+1; j = 2*b+1;
% %         continue
% %     end
%     
%     mind = [2*(a+1)-1:2*(a+two_to_idx)];
%     nind = [2*(b+1)-1:2*(b+two_to_idx)];
%     
%     %visited(mind,nind) = visited(mind,nind) + 1;
%     
%     tmp = max(max(abs(m(mind,nind))));
%     if (tmp > value)
%         value = tmp;
%     end
%     
% %     if (value > threshold)
% %         return
% %     end
%     
%     idx = idx + 1;
%     i = 2*a+1; j = 2*b+1;
% end

% function value = MaxDescendantSingle(i, j, m_abs, m_desc)
% 
%     a = i-1; b = j-1;
%     
%     mind = [2*(a+1)-1:2*(a+1)];
%     nind = [2*(b+1)-1:2*(b+1)];
%     
%     value = max(max(max(m_abs(mind,nind))),max(max(m_desc(mind,nind))));
    