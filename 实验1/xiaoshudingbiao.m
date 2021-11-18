%% 零均值规范化
clc;clear;
load('data.mat','data');
A = data;
%自主实现
maxx_abs = max(abs(A));
x1 = log10(maxx_abs);
x1 = ceil(x1);
[n,m] = size(A);
B = zeros(n,m);
for i = 1:n
    for j = 1:m
        B(i,j) = A(i,j) / (10^x1(j));
    end
end