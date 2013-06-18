function mat = TreeTransform(mat, level, mode, m1, n1)

isForward = strcmpi(mode,'fw');

%[m1, n1] = size(mat);

levels = [m1 n1];
%mat(1:m1,1:n1) = 0.2;

for i = 1:1:level
        if(m1<2 || n1 <2)
            break;
        end               

        m1 = ceil(m1/2);
        n1 = ceil(n1/2);
        
        %mat(1:m1,1:n1) = i;
        
        levels = [m1 n1; levels];
end  

levels_orig = levels;

mat = circshift(mat,[-levels(1,1) -levels(1,2)]);
   if (mod(levels(1,1),2) == 1)
       if isForward
          mat = [mat; -1*zeros(1,size(mat,2))];
       else
          mat = mat(2:end,:);
       end
       levels(:,1) = levels(:,1) + 1;
   end

    if (mod(levels(1,2),2) == 1)        
       if isForward
          mat = [mat -1*zeros(size(mat,1),1)];       
       else          
          mat = mat(:,2:end);            
       end
       levels(:,2) = levels(:,2) + 1;
   end
   
for i = 2:size(levels,1)
   levelWidth_m = levels(i,1);
   levelWidth_n = levels(i,2);
   [levelWidth_m levelWidth_n];
   mat = circshift(mat,[-floor(levels_orig(i,1)/2) -floor(levels_orig(i,2)/2)]);  
   
   if (2*levels(i-1,1) > levelWidth_m)
       if isForward
           mat = [mat; -1*zeros((2*levels(i-1,1) - levelWidth_m),size(mat,2))];
       else
           mat = mat((2*levels(i-1,1) - levelWidth_m)+1:end,:);
       end
       levels(i:end,1) = levels(i:end,1) + 2*levels(i-1,1)- levelWidth_m;
   end
   
   if (2*levels(i-1,2) > levelWidth_n)
       if isForward
           mat = [mat -1*zeros(size(mat,1),(2*levels(i-1,2) - levelWidth_n))];
       else
           mat = mat(:,(2*levels(i-1,2) - levelWidth_n)+1:end);        
       end
       levels(i:end,2) = levels(i:end,2) + 2*levels(i-1,2)- levelWidth_n;
   end
  
end    
