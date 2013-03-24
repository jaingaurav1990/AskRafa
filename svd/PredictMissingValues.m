function X_pred = PredictMissingValues(X, nil)
% Predict missing entries in matrix X based on known entries. Missing
% values in X are denoted by the special constant value nil.

% your collaborative filtering code here!
X_pred = X;
% X_pred(X_pred == nil) = 1;

% Replace nil by row-average
not_nil = (X_pred ~= nil);
not_nil_sum_row = sum(not_nil');
nil_m_idx = (X_pred == nil);
nil_m = nil.*nil_m_idx;
X_pred = X_pred - nil_m;

avg = sum(X_pred');
avg = avg./not_nil_sum_row;

for i = 1:size(X,1),
    X_pred(i, nil_m_idx(i, :)) = avg(i);
end

% Proceed with SVD
[U, D, V] = svd(X);
D_root = sqrt(D);
%U = U*D_root;
%V = D_root*V;

k = 100;
D(k+1:end,1:end) = 0;

Pred = U*D;
Pred = Pred*(V');
%size(Pred)
%size(nil_m_idx)
Pred = Pred.*nil_m_idx;     % Predictions correspond to only the null values
X_pred = X_pred.*not_nil;

X_pred = X_pred + Pred;



