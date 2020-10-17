clear all; clc; close all;

X = [0 2; 2 2; 3 0; 2 0];
y = [-1 ;-1; 1; 1];

w = [1.2 -3.2]';
b = -0.5;

%equation de la droite separatrice y = ax+b
%<w,x>+b = 0 <=> w1*x1 + w2*x2 + b = 0 <==> x2 = -1/w2 (w1*x2 + b)

slope = -w(1)/w(2);
intercept = -b/w(2);

for i = 1:length(y)
    if y(i) == 1
        plot(X(i,1),X(i,2),'rx');
    else
        plot(X(i,1),X(i,2),'bo');
    end
    hold on;
end

separator = slope.*[0:4]+intercept;

plot([0:4],separator,'r-');

rho = zeros(1,length(y));
for i = 1:length(y)
    rho(i) = y(i)*(w'*X(i,:)'+b);
end

if(sum(rho > 0) == length(rho))
    disp("L'hyperplan sépare les données");
end

rho = min(rho);

w_rho = w/rho;
b_rho = b/rho;

new_slope = -w_rho(1)/w_rho(2);
new_intercept = -b_rho/w_rho(2);

new_separator = new_slope.*[0:4]+new_intercept;

plot([0:4],new_separator,'y--');

%C'est bien la même droite que précédemment

d = length(w_rho);

Q = [0, zeros(1,d);zeros(d,1),eye(d)];
u = [b_rho;w_rho];
p = zeros(1,d+1);
c = ones(1,length(y));
A = zeros(length(y),d+1);
for i = 1:length(y)
    A(i,:) = y(i).*[1, X(i,:)];
end

u_solution = quadprog(Q,p,-A,-c);

w_optimal = u_solution(2:end);
b_optimal = u_solution(1);

optimal_slope = -w_optimal(1)/w_optimal(2);
optimal_intercept = -b_optimal/w_optimal(2);

optimal_separator = optimal_slope.*[0:4]+optimal_intercept;

plot([0:4],optimal_separator,'g-');

new_data = ginput(5);
predictions = zeros(1,5);
for i = 1:5
    predictions(i) = sign(w_optimal'*new_data(i,:)'+b_optimal);
    if(predictions(i) == 1)
        plot(new_data(i,1),new_data(i,2),'rx');
    else
        plot(new_data(i,1),new_data(i,2),'bo');
    end
end

SVM_model = fitcsvm(X,y);

matlab_predicitons = SVM_model.predict(new_data);

matlab_predicitons' == predictions