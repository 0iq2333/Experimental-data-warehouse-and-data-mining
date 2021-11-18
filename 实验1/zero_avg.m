%% 零-均值规范化
clear;
clc;
load('data.mat','data');
A = data;
%自主实现
A_mean = mean(A);
A_std = std(A);
[n,m] = size(A);
B1 = (A - repmat(A_mean,n,1))./repmat(A_std,n,1);
%调用函数实现
[B2,A_mead,A_std] = zscore(A);

