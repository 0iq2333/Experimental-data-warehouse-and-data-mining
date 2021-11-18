%% 最小最大规范化
clc;clear;
load('data.mat','data');
A = data;
%自主实现
fprintf("输入要映射的区间范围:\n");
new_min = input("最小值:");
new_max = input("最大值:");
[n,m] = size(A);
minn = min(A);
maxx = max(A);
B1 = zeros(n,m);
for i=1:n
    for j=1:m
        B1(i,j) = (A(i,j) - minn(j)) / (maxx(j) - minn(j)) * (new_max - new_min) + new_min;
    end
end
%调用函数实现
B2 = mapminmax(A',new_min,new_max)'; 
