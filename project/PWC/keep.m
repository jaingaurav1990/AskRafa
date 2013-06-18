function I = keep(I,Ratio)
% keep only fraction of largest elements

if Ratio > 1
   Num = Ratio;
else
   Num = floor(numel(I)*Ratio);
end

[~,i] = sort(abs(I(:)));
I(i(1:end-Num)) = 0;
return;