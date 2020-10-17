clear all; clc; close all;
test_set = load('zip.test');
training_set = load('zip.train');
%%
example = reshape(training_set(1,2:end)',[16,16]);
imshow(example)

%%
X_train = training_set(:,2:end);
Y_train = training_set(:,1);

X_test = test_set(:,2:end);
Y_test = test_set(:,1);

%%
SVM_models = cell(10,1);
% accuracy = zeros(1,10);
% for i = 1:10
%     SVM_models{i} = fitcsvm(X_train,Y_train == i-1,'BoxConstraint',1);
%     prediction = SVM_models{i}.predict(X_test);
%     accuracy(i) = sum((Y_test == i-1) == prediction)/length(Y_test);
% end
%%

X = [0 2; 2 2; 3 0; 2 0];
y = [-1 ;-1; 1; 1];
Xt = X';
n = size(X,1);
Q = zeros(n);
Ad = [y';-y';eye(n)];
P = -ones(1,n);
C = zeros(n+2,1);

for i = 1:n
    for j = 1:n
        Q(i,j)=y(i)*y(j).*(X(i,:)*Xt(:,j));
    end
end

alpha_sol = quadprog(Q,P,-Ad,C);
alpha_sol(alpha_sol < 10e-8) = 0;
idx_sv = find(alpha_sol ~= 0);
Nsv = length(idx_sv);
w_optimal = zeros(2,1);
for i = 1:length(alpha_sol)
    w_optimal = w_optimal + alpha_sol(i)*y(i).*X(i,:)'; 
end
b_optimal = 0;
for i = 1:Nsv
    b_optimal = b_optimal + y(idx_sv(i)) - w_optimal'*X(idx_sv(i),:)';
end

b_optimal = b_optimal / Nsv;
optimal_slope = -w_optimal(1)/w_optimal(2);
optimal_intercept = -b_optimal/w_optimal(2);

optimal_separator = optimal_slope.*[0:4]+optimal_intercept;

for i = 1:length(y)
    if y(i) == 1
        plot(X(i,1),X(i,2),'rx');
    else
        plot(X(i,1),X(i,2),'bo');
    end
    hold on;
end


plot([0:4],optimal_separator,'g-');