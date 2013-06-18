function [ U ] = Zigzag( I, levels )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here


[M,N] = size(I);
Mb = ceil(M/(2 ^ levels));
Nb = ceil(N/(2 ^ levels));

% Traversing in zigzag order
level = 1;
idx = 1;
U(1:Mb,(idx - 1)*Nb + 1:idx*Nb) = I(1:Mb, 1:Nb);
idx = idx + 1;

for level = 1:levels
    LH_BROW = 1; LH_BCOL = (2 ^ (level - 1)) + 1;
    HL_BROW = (2 ^ (level - 1)) + 1; HL_BCOL = 1;
    HH_BROW = HL_BROW; HH_BCOL = LH_BCOL;
    
    vrt_iter = 2 ^ (level - 1); hz_iter = vrt_iter;
   
    lh_brow = LH_BROW; lh_bcol = LH_BCOL; 
    hl_brow = HL_BROW; hl_bcol = HL_BCOL;
    
    for i = 1:hz_iter
        
        for j = 1:vrt_iter
            row = (lh_brow - 1)*Mb + 1;
            col = (lh_bcol - 1)*Nb + 1;
            
            U(:,(idx - 1)*Nb + 1:idx*Nb) = I(row:row + Mb - 1, col:col + Nb - 1);
            idx = idx + 1;
            
            row = (hl_brow - 1)*Mb + 1;
            col = (hl_bcol - 1)*Nb + 1;
            
            U(:,(idx - 1)*Nb + 1:idx*Nb) = I(row:row + Mb - 1, col:col + Nb - 1);
            idx = idx + 1;

            lh_brow = lh_brow + 1;
            hl_brow = hl_brow + 1;
        end
        
        lh_bcol = lh_bcol + 1;
        hl_bcol = hl_bcol + 1;
        lh_brow = LH_BROW;
        hl_brow = HL_BROW;
    end
    
    hh_brow = HH_BROW; hh_bcol = HH_BCOL;
    for i = 1:hz_iter
        for j = 1:vrt_iter
            row = (hh_brow - 1)*Mb + 1;
            col = (hh_bcol - 1)*Nb + 1;
            
            U(:,(idx - 1)*Nb + 1:idx*Nb) = I(row:row + Mb - 1, col:col + Nb - 1);
            idx = idx + 1;
            
            hh_brow = hh_brow + 1;
        end
        
        hh_brow = HH_BROW; hh_bcol = hh_bcol + 1;
    end
   
    
end

% Convert to a single row
U = U(:)';

end


