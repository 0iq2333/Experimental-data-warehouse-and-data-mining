clear;clc;
load('data.mat');
A = data;

%计算p(yi)
[n,m] = size(A);
dec_data = A(:,m); %提取出决策属性
dec_unique_data = unique(dec_data);
dec_unique_num = length(dec_unique_data);%决策属性的个数

num = zeros(dec_unique_num,3);%第一列决策属性值、第二列个数、第三列百分比
num(:,1) = dec_unique_data;
for i=1:dec_unique_num
    num(i,2) = length( find(A(:,m)==num(i,1)) ); %计算属性值为num(i,1)的个数
end
num(:,3) = num(:,2)./n;%计算属性值为num(i,1)占总的比例

% 计算p(xk/ci),xi第i个条件属性，ci第i个决策属性
x = [1,2,2,1];%输入类别未知的新样本
he = zeros(m-1,dec_unique_num);
ra = zeros(m-1,dec_unique_num);
for i=1:dec_unique_num  %决策属性
    temp_select = (dec_data == dec_unique_data(i));%找到决策属性为ci的内些行
    temp_data = A(temp_select,:);%相当于 selcet * from A where A.决策 = unique_data(i)
    for j=1:m-1 %条件属性
        he(j,i) = length( find( x(j) == temp_data(:,j)) );%提取第j个属性
        ra(j,i) = he(j,i)/num(i,2); %计算p(xj|ci)
    end
end

% 计算p(ci)*p(x|ci) = 连乘
P = num(:,3)';
[mm,nn] = size(ra);
for j=1:dec_unique_num
    for i=1:m-1
        P(1,j) = P(1,j) * ra(i,j);
    end
end
[maxx,pos] = max(P);
fprintf("当前类别未知的样本属于%d的概率最大,概率值为%f\n",dec_unique_data(pos),maxx);