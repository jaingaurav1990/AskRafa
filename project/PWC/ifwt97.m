function mat = ifwt97( mat,m,n )
%Applies inverse CDF 9/7 wavelet transform using 
% backward lifting.
alpha = 1.5861343420693648;
beta  = 0.0529801185718856;
gamma = -0.8829110755411875;
delta = -0.4435068520511142;
scale = 1.1496043988602418;
mid = ceil(n/2);
%%Apply along rows
    mat_o = mat(1:1:m,1:1:mid)/scale;
    mat_e = mat(1:1:m,mid+1:1:n);
    mat_e = mat_e * scale;
    if(rem(n,2))
        res = conv2(mat_e,[delta delta]);
        res(:,size(res,2))=zeros(m,1);
        mat_o = mat_o + res;
        res = conv2(mat_o,[gamma gamma],'same');
        res(:,size(res,2))=[];
        mat_e = mat_e + res;
        res = conv2(mat_e,[beta beta]);
        res(:,size(res,2))=zeros(m,1);
        mat_o = mat_o + res;
        res = conv2(mat_o,[alpha alpha],'same');
        res(:,size(res,2))=[];
        mat_e = mat_e + res;
    else
       
        res = conv2(mat_e,[delta delta]);
        res(:,size(res,2))=[];
        mat_o = mat_o + res;
        res = conv2(mat_o,[gamma gamma],'same');
        mat_e = mat_e + res;
        res = conv2(mat_e,[beta beta]);
        res(:,size(res,2))=[];
        mat_o = mat_o + res;
        res = conv2(mat_o,[alpha alpha],'same');
        mat_e = mat_e + res;
    end
    mat(1:1:m,[1:2:n,2:2:n]) = [mat_o mat_e];
    
    mid = ceil(m/2);
%%Apply along columns
    mat_o = mat(1:1:mid,1:1:n)/scale;
    mat_e = mat(mid+1:1:m,1:1:n);
    mat_e = mat_e*scale;
    if(rem(m,2))
        res = conv2(mat_e,[delta;delta]);
        res(size(res,1),:) = zeros(1,n);
        mat_o = mat_o + res;
        res = conv2(mat_o,[gamma;gamma],'same');
        res(size(res,1),:)=[];
        mat_e = mat_e + res;
        res = conv2(mat_e,[beta;beta]);
        res(size(res,1),:) = zeros(1,n);
        mat_o = mat_o + res;
        res = conv2(mat_o,[alpha;alpha],'same');
        res(size(res,1),:)=[];
        mat_e = mat_e + res;
    else
        res = conv2(mat_e,[delta;delta]);
        res(size(res,1),:)=[];
        mat_o = mat_o + res;
        res = conv2(mat_o,[gamma;gamma],'same');
        mat_e = mat_e + res;
        res = conv2(mat_e,[beta;beta]);
        res(size(res,1),:)=[];
        mat_o = mat_o + res;
        res = conv2(mat_o,[alpha;alpha],'same');
        mat_e = mat_e + res;
    end
    mat([1:2:m,2:2:m],1:1:n) = [mat_o;mat_e];
end

