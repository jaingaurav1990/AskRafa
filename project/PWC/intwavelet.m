function Z = intwavelet( levels, I )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

LS = liftwave('haar','int2int');
els = {'p',[-0.125 0.125],0};
lsnewint = addlift(LS,els);

Z = lwt2(double(I),lsnewint);


%imshow('CA'); impixelregion;
end

