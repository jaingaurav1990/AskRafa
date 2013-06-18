function m = EntropyDecodeSPIHT(enc, level)

metadata = enc.metadata;

% Convert from packed binary represetation into single bits
in_collapsed = uint8(enc.out);
in = zeros(size(in_collapsed,2)*8, 1);

for i = 0:size(in_collapsed,2)-1
   v = in_collapsed(i+1);
   
   in(8*i + 1) = bitget(v,1);
   in(8*i + 2) = bitget(v,2);
   in(8*i + 3) = bitget(v,3);
   in(8*i + 4) = bitget(v,4);
   in(8*i + 5) = bitget(v,5);
   in(8*i + 6) = bitget(v,6);
   in(8*i + 7) = bitget(v,7);
   in(8*i + 8) = bitget(v,8);   
end    

in = double(in);
 
% end convert
size_m = metadata(1);
size_n = metadata(2);
% image size, bit planes, level
m = zeros(size_m, size_n);
n_max = metadata(3);
ctr = 1;
 
size_m_c = uint16(ceil((size_m + 1)/4));
size_n_c = uint16(ceil((size_n + 1)/4));

% (1) Initialization: output n = log2 max(i,j){|ci,j|}; 
% set the LSP as an empty list, and 
% add the coordinates (i, j)?H to the LIP, and only those with descendants also to the LIS, as type A entries.

levelWidth_m = size_m/2^(level-1);
levelWidth_n = size_n/2^(level-1);
% levelWidth_m = 2^(log2(size_m) - level + 1);
% levelWidth_n = 2^(log2(size_n) - level + 1);
tmp = repmat(1:levelWidth_m, levelWidth_n,1);
LIP(:, 1) = tmp(:);
LIP(:, 2) = repmat((1:levelWidth_n)', levelWidth_m,1);
LIS(:, 1) = LIP(:, 1);
LIS(:, 2) = LIP(:, 2);
LIS(:, 3) = zeros(length(LIP(:, 1)), 1);

LIS(repmat(1:levelWidth_n/2,levelWidth_m/2,1) + repmat((0:levelWidth_n:levelWidth_n*levelWidth_m/2 - 1)',1,levelWidth_n/2),:) = [];

LIS = uint16(LIS); 
newLIS = uint16(zeros(10000,3));

%LIP = uint16(LIP);
LIP = uint32(LIP(:,1)+(LIP(:,2)-1)*size_m);

LSP = uint32(zeros(60000,1));
LSP_idx = 1;

newLIP = uint32(zeros(15000,1));
newLIP_idx=1;

n = n_max;
while (ctr <= size(in,1) )
    LSP_idx_start = LSP_idx;    
    % (2) Sorting pass
    % (a) for each entry (i, j) in the LIP do:
%     to_remove = [];
%     for i = 1:size(LIP,1)
%         
%         % i. output ?n(i, j);
%         isSignificant = in(ctr);
%         ctr = ctr + 1;
%         
%         % ii. if ?n(i, j) = 1 then move (i, j) to the LSP and output the sign of ci,j ;
%         if isSignificant == 1 % 1: positive; 0: negative            
%             %sgn = in(ctr);
%             %if (sgn == 0)
%             %    sgn = -1;
%             %end
%             
%             %ctr = ctr + 1;
%             
%             %m(LIP(i)) = sgn*2^n + sgn*2^(n-1);
%         
%             %LSP = [LSP; LIP(i,:)];
%             LSP(LSP_idx) = LIP(i);
%             LSP_idx = LSP_idx + 1;
%             to_remove = [to_remove i];
%         end
%     end
%     LIP(to_remove) = [];
    
    areSignificant = logical(in(ctr:ctr+size(LIP,1)-1));
    ctr = ctr +size(LIP,1);
    
    num_significant = sum(areSignificant);
  
    LSP(LSP_idx:LSP_idx+num_significant-1) = LIP(areSignificant');
    LSP_idx = LSP_idx + num_significant;
    
    LIP(areSignificant) = [];        
    
    newLIP_idx=1;
    to_remove = [];
   i = 1;   
  while (1)  
    newLIS_idx=1;
    
    while ( i <= size(LIS,1))                     
        x = double(LIS(i,1));
        y = double(LIS(i,2));
        type = double(LIS(i,3));
        % i. if the entry is of type A then
        if type == 0                        
            % • output ?n(D(i, j));                            
            isSignificant = in(ctr);            
            ctr = ctr + 1;                       
            
            % • if ?n(D(i, j)) = 1 then
            if isSignificant == 1
                                               
                % — for each (k, l) ? O(i, j) do:
                O = [2*x-1 2*y-1; 2*x-1 2*y; 2*x 2*y-1; 2*x 2*y];
                
                for j = 1:4
                    k = O(j,1);
                    l = O(j,2);                                      
                
                    % ? output ?n(k, l);                                
                    isSignificant = in(ctr); ctr = ctr + 1;                    
                    
                    if isSignificant == 1
                        % ? if ?n(k, l) = 1 then add (k, l) to the LSP and output the sign of ck,l;
                        %sgn = in(ctr); ctr = ctr + 1;
                        %if (sgn == 0)
                        %    sgn = -1;
                        %end
                        
                        % m(k,l) = sgn*2^n + sgn*2^(n-1); 
                        
                        %LSP = [LSP; k,l];
                        LSP(LSP_idx) = k+(l-1)*size_m;
                        LSP_idx = LSP_idx + 1;
                    else                
                        % ? if ?n(k, l) = 0 then add (k, l) to the end of the LIP;
                        %LIP = [LIP; k,l];
                        newLIP(newLIP_idx) = k+(l-1)*size_m;
                        newLIP_idx = newLIP_idx +1;
                    end
                end
                                
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
        else
       %end
        %if type == 1
           
            % • output ?n(L(i, j));
            isSignificant = in(ctr); ctr = ctr + 1;
            
            % • if ?n(L(i, j)) = 1 then
            if isSignificant                
                %— add each (k, l) ? O(i, j) to the end of the LIS as an entry of type A;                             
                %LIS = [LIS; 2*x-1 2*y 0; 2*x 2*y-1 0; 2*x 2*y 0];
                newLIS(newLIS_idx:newLIS_idx+2,:) = [2*x-1 2*y 0; 2*x 2*y-1 0; 2*x 2*y 0];
                newLIS_idx = newLIS_idx + 3;
                
                %LIStmp = [LIStmp; 2*x-1 2*y-1 0; 2*x-1 2*y 0; 2*x 2*y-1 0; 2*x 2*y 0];
                LIS(i,:) = [2*x-1 2*y-1 0];
                i = i - 1;
                %— remove (i, j) from the LIS.
               % LIS(tmp,:) = []; tmp = tmp - 1;
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
 
    LIP = [LIP; newLIP(1:newLIP_idx-1)];
    LIS(to_remove,:) = [];
           
    ctr_before = ctr;
    % Refinement Pass       
    %tmp = 1;
    %value = m(LSP(tmp));
    %while (abs(value) >= 2^(n+1) & (tmp <= size(LSP,1)))
    for tmp=LSP_idx_start:LSP_idx-1    
        sgn = in(ctr);
        if (sgn == 0)
            sgn = -1;
        end
            
        ctr = ctr + 1;
            
        m(LSP(tmp)) = sgn*2^n + sgn*2^(n-1);
    end
    
    n1 = (2^(n-1));
    for tmp=1:LSP_idx_start-1        
        value =  m(LSP(tmp)) + ((-1)^(in(ctr) + 1)) * n1*sign(m(LSP(tmp)));         
        m(LSP(tmp)) = value; ctr = ctr + 1;
    end
    
%     if (LSP_idx_start>1)  
%         LSP = LSP + signs(1:length(LSP)).*in(ctr:ctr+size(LSP,1)-1)*(2^n);
%         ctr = ctr + size(LSP,1);
%     end
        
    ctr;
    size(in,1);
    if ctr + 8 >= size(in,1) - (ctr - ctr_before)*2 
        %signs = in(ctr:ctr+LSP_idx-1);
        
        n
         size_m_orig = enc.metadata(4);
         size_n_orig = enc.metadata(5);
         m = TreeTransform(m, level, 'bw', size_m_orig, size_n_orig);
%         m = m(1:size_m_orig, 1:size_n_orig);
%         n = n-1;
%         
%         tmp = 1;
%         value = m(LSP(tmp,1), LSP(tmp,2));
%         while (abs(value) >= 2^(n+1) & (tmp <= size(LSP,1)))
%                    
%             value = value + ((-1)^(in(ctr) + 1)) * (2^(n-1))*sign(m(LSP(tmp,1),LSP(tmp,2))); 
%             m(LSP(tmp,1),LSP(tmp,2)) = value;
%             ctr = ctr + 1;
%             tmp = tmp + 1;    
%             if tmp <= size(LSP,1)
%                 value = m(LSP(tmp,1),LSP(tmp,2));
%             end
%         end  
        
        return
    end
    
    n = n-1;
end