clear;
clc;
load('old_data.mat');
A = old_data;
%最小最大规范化到[0,1]之间
X = mapminmax(A',0,1)';
%% 直接聚类
T1 = clusterdata(X,0.2); %当0<cutoff<2时，不一致系数大于cutoff时，分到不同类中
T2 = clusterdata(X,3); %当cutoff≥2的整数时，形成类别数为cutoff
%% 逐步聚类
Y = pdist(X); %计算矩阵X中样本两两之间的距离，得到的Y为行向量(M*(M-1)/2)
D = squareform(Y); %根据行向量的Y转换成的方阵，得到对角元素为0的对称阵
Z = linkage(Y); %产层次聚类树，是一个(m-1)*3的矩阵，前两个为索引表示
dendrogram(Z);%显示层次聚类树
T3 = cluster(Z,4); %最终得到的k类
%% k均值
T4 = kmeans(X,5);%生成5类