function mat = CDFDecompress( mat,L,mode )
%% Input arguments
%% mat = Matrix to be transformed
%% L = Number of levels
%% mode = either 'cdf53', 'cdf97', 'odegard97' or 'cooklet17_11' specifying the kind of transform

%Performs L Level CDF Decompression
m = size(mat,1);
n = size(mat,2);
m1 = ceil(m/pow2(L-1));
n1 = ceil(n/pow2(L-1));
if(strcmpi(mode,'cdf97'))
    for t=L-1:-1:0
        if(m1 < 2 || n1 < 2)
            m1 = ceil(m/pow2(t-1));
            n1 = ceil(n/pow2(t-1)); 
            continue;
        end
        mat=ifwt97(mat,m1,n1);
        m1 = ceil(m/pow2(t-1));
        n1 = ceil(n/pow2(t-1));
    end
elseif(strcmpi(mode,'cdf53'))
       for t=L-1:-1:0
        if(m1 < 2 || n1 < 2)
            m1 = ceil(m/pow2(t-1));
            n1 = ceil(n/pow2(t-1)); 
            continue;
        end
        mat=ifwt53(mat,m1,n1);
        m1 = ceil(m/pow2(t-1));
        n1 = ceil(n/pow2(t-1));
       end 
elseif(strcmpi(mode,'odegard97'))
       for t=L-1:-1:0
        if(m1 < 2 || n1 < 2)
            m1 = ceil(m/pow2(t-1));
            n1 = ceil(n/pow2(t-1)); 
            continue;
        end
        mat=iodegard97(mat,m1,n1);
        m1 = ceil(m/pow2(t-1));
        n1 = ceil(n/pow2(t-1));
       end 
elseif(strcmpi(mode,'cooklet17_11'))
       for t=L-1:-1:0
        if(m1 < 2 || n1 < 2)
            m1 = ceil(m/pow2(t-1));
            n1 = ceil(n/pow2(t-1)); 
            continue;
        end
        mat=icooklet17_11(mat,m1,n1);
        m1 = ceil(m/pow2(t-1));
        n1 = ceil(n/pow2(t-1));
    end 
end
end

