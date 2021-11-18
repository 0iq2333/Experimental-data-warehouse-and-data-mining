clear;
clc;
load('old_data.mat');
A = old_data;
%最小最大规范化到[0,1]之间
X = mapminmax(A',0,1)';
% 直接聚类
T1 = clusterdata(X,0.5);
T2 = clusterdata(X,0.7);
T3 = clusterdata(X,0.9);
T4 = clusterdata(X,1.1);
T5 = clusterdata(X,1.0);
%
len1 = length(unique(T1));
len2 = length(unique(T2));
len3 = length(unique(T3));
len4 = length(unique(T4));
len5 = length(unique(T5));
if T
    