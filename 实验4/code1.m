clear;
clc;
load('data.mat');%装入数据
A = data;
[n,m] = size(A);
new_rand_data = A(randperm(n),:);%对行进行随机排序，以防数据过于集中分布

X = new_rand_data(:,1:m-1);%条件属性
Y = new_rand_data(:,m);%决策属性
tree1 = fitctree(X,Y);%生成分类决策树(整数)
%显示决策树
view(tree1);
view(tree1,'mode','graph')

%进行剪枝
cut_tree = prune(tree1,'level',1);
%显示剪枝后的决策树
view(cut_tree);
view(cut_tree,'mode','graph');

%用来测试分类的性能
x = ceil(n/3);%三等分，前两份作为训练集，最后一份作为测试集
train_set = new_rand_data(1:2*x,:);%训练集，用于生成决策树
test_set = new_rand_data(2*x+1:n,:);%测试决策树性能
test_data = test_set(:,1:m-1);%提取出测试集的条件属性

X1 = train_set(:,1:m-1);%训练集的条件属性
Y1 = train_set(:,m);%训练集的条件属性
tree2 = fitctree(X1,Y1);%根据训练集生成决策树
%显示根据测试机生成的决策树
view(tree2);
view(tree2,'mode','graph');

%用测试集来预测样本的类标签、求出预测的精度
Y_predict = predict(tree2,test_data);%训练出的决策树，测试集的条件属性
[n2,m2] = size(test_set);
accuracy = ( n2 - length( find( test_set(:,m2) ~= Y_predict(:,1) ) ) ) / n2;%找到预测的与真实的有多少相同
fprintf("预测精度为%f\n",accuracy);
