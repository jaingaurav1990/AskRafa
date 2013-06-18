function [ Residue,P ] = ResidueAndPrediction( I, mb_width, mode )
%ResidueAndPrediction: Returns a matrix of predicted values of the pixels
%of an image according to the specified 'mode'. And the residual signal
%   Detailed explanation goes here

% Define modes used for prediction
V_PRED = 0; H_PRED = 1; DC_PRED = 2; TM_PRED = 3;

% Calculate dimensions of the padded matrix
[m, n] = size(I);
rmndr = rem(m,mb_width);
to_add = 0;
if rmndr ~= 0
    to_add = (mb_width - rmndr) + mb_width;
else
    to_add = mb_width;
end

ROWS = m + to_add

to_add = 0;
rmndr = rem(n,mb_width);
n_up = n;
if rmndr ~= 0
    n_up = n_up + (mb_width - rmndr);
    to_add = (mb_width - rmndr) + 2*mb_width;
else
    to_add = 2*mb_width;
end

COLS = n + to_add
% ----

Padded_Frame = zeros(ROWS, COLS);
Padded_Frame(mb_width + 1: mb_width + m, mb_width + 1:mb_width + n) = I(1:m, 1:n);

% Fill in the padded values (Refer Page 10: RFC 6386)
%{
Padded_Frame(1:mb_width, mb_width + 1:mb_width + n) = repmat(I(1,:), mb_width, 1);
Padded_Frame(mb_width + m + 1:ROWS, mb_width + 1:mb_width + n) = repmat(I(m,:), ROWS - mb_width - m, 1);
Padded_Frame(:, 1:mb_width) = repmat(Padded_Frame(:, mb_width + 1), 1, mb_width);
Padded_Frame(:, mb_width + n + 1:COLS) = repmat(Padded_Frame(:, mb_width + n), 1, COLS - mb_width - n);

% Fill in the 'invisible' corner pixels with 'visible' corner pixels (Page
% 10, RFC 6386)
Padded_Frame(1,1) = I(1,1);
Padded_Frame(1,COLS) = I(1,n);
Padded_Frame(ROWS, 1) = I(m,1);
Padded_Frame(ROWS,COLS) = I(m,n);
%}

% Alternate filling described for Chorma Prediction in Section 12.2 (RFC
% 6386)
Padded_Frame(:, 1:mb_width) = 129;
Padded_Frame(1:mb_width, :) = 127;

%P = Padded_Frame;
switch mode
    case V_PRED
        disp('Using Vertical Prediction');
        %COLS
        row_id = mb_width:mb_width:(ROWS-1); % Don't need to include the very last row
        Approx = Padded_Frame(row_id, (mb_width + 1):COLS - mb_width);
        s_row = 1;
        step = mb_width;
        for i = 1:length(row_id)
            P(s_row:(s_row + step - 1),1:n_up) = repmat(Approx(i,:), mb_width, 1);
            s_row = s_row + step;
        end
        
    case H_PRED
        disp('Using Horizontal Prediction');
        %COLS
        col_id = mb_width:mb_width:(mb_width + n_up - 1);
        Approx = Padded_Frame(mb_width + 1:ROWS, col_id);
        s_col = 1;
        step = mb_width;
        for i = 1:length(col_id)
            P(1:ROWS - mb_width,s_col:s_col + step - 1) = repmat(Approx(:,i),1,mb_width);
            s_col = s_col + step;
        end
        
    case DC_PRED
        disp('Yet to implement this mode');
        
    case TM_PRED
        disp('Using TM_PRED mode');
        
        for row = mb_width:mb_width:ROWS - 1
            for col = mb_width:mb_width:COLS - mb_width - 1
                A = Padded_Frame(row, col + 1:col + mb_width);
                L = Padded_Frame(row + 1:row + mb_width,col);
                Pixel = Padded_Frame(row,col);
                P(row + 1 - mb_width:row, col + 1 - mb_width:col) = repmat(A,mb_width, 1) + repmat(L, 1, mb_width) - Pixel;
            end
        end
        
        
end


Residue = Padded_Frame(mb_width + 1:ROWS, mb_width + 1:mb_width + n_up) - P(:,:);

end

