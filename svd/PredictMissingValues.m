function X_pred = PredictMissingValues(X, nil)
% Predict missing entries in matrix X based on known entries. Missing
% values in X are denoted by the special constant value nil.

% your collaborative filtering code here!
X_pred = X;
% X_pred(X_pred == nil) = 1;

not_nil = (X_pred ~= nil);
not_nil_sum_row = sum(not_nil');
nil_m_idx = (X_pred == nil);
nil_m = nil.*nil_m_idx;
X_pred = X_pred - nil_m;

avg = sum(X_pred');
avg = avg./not_nil_sum_row;

for i = 1:7834,
    X_pred(i, nil_m_idx(i, :)) = avg(i);
end

