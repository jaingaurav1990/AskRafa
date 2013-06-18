function mat = CDFCompress( mat,L,mode)
%% Input arguments
%% mat = Matrix to be transformed
%% L = Number of levels
%% mode = either 'cdf53' 'cdf97','odegard97' or 'cooklet17_11' specifying the kind of transform


%Performs L Level compression
m = size(mat,1);
n = size(mat,2);
m1 = m;
n1 = n;
if(strcmpi(mode,'cdf97'))
    for i = 1:1:L
        if(m1<2 || n1 <2)
            break;
        end
        mat = fwt97(mat,m1,n1);
        m1 = ceil(m1/2);
        n1 = ceil(n1/2);
    end
elseif(strcmpi(mode,'cdf53'))
     for i = 1:1:L
        if(m1<2 || n1 <2)
            break;
        end
        mat = fwt53(mat,m1,n1);
        m1 = ceil(m1/2);
        n1 = ceil(n1/2);
     end   
elseif(strcmpi(mode,'odegard97'))
     for i = 1:1:L
        if(m1<2 || n1 <2)
            break;
        end
        mat = odegard97(mat,m1,n1);
        m1 = ceil(m1/2);
        n1 = ceil(n1/2);
     end  
elseif(strcmpi(mode,'cooklet17_11'))
     for i = 1:1:L
        if(m1<2 || n1 <2)
            break;
        end
        mat = cooklet17_11(mat,m1,n1);
        m1 = ceil(m1/2);
        n1 = ceil(n1/2);
    end  
end
end

