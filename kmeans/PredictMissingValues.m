function X_pred = PredictMissingValues(X, nil)
% Predict missing entries in matrix X based on known entries. Missing
% values in X are denoted by the special constant value nil.

% your collaborative filtering code here!


[num_users, num_items] = size(X);

%find means
items_means = zeros(1,num_items);
users_means = zeros(num_users,1);

for i=1:num_items
   items_means(i) = mean(X(X(:,i) ~= nil,i)); 
end

for u=1:num_users
   users_means(u) = mean(X(u,X(u,:) ~= nil)); 
end

%calculate initial imputed values
avg_of_means = (repmat(items_means,num_users,1) + repmat(users_means,1, num_items))/2; %calculate for each entry the the average of the means by user and by item

missing_values_indices = find(X == nil);
X_pred = X;
X_pred(missing_values_indices) = avg_of_means(missing_values_indices); 


%Now apply k-means
 
K = 5;

[z, U, score] = k_means(X_pred', K);
%ClustInx = ClustInx(:);    % Convert the array of cluster indices to a vector


% update missing values in X_pred

% TODO: fill in your code here 
% You should update the missing values based of averaging over co-clustered
% users for the respective item.

tmp = U(:,z).*(X_pred' == nil); 
X_pred(X_pred == nil) = 0;
X_pred = X_pred + tmp';


end