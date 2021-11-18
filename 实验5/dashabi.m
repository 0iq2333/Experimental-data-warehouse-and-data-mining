clear ;
clc;
load('data.mat');
[m,n]=size(data);
label=unique(data(:,n));   %%label中存储决策属性的取值
num=zeros(length(label),3);  %%构建矩阵num，第一列存储决策属性的取值；第二列存储每个取值覆盖的样本数；第三列存储每个属性覆盖样本数的占比
num(:,1)=label';   %%第一列存储决策属性的取值
for i=1:length(label)  %%对所有的决策属性的取值
  num(i,2)=sum(data(:,n)==label(i));  %%计算每个取值覆盖的样本数，存入num的第二列
end
num(:,3)=num(:,2)./m;  %%第三列存储每个取值覆盖样本的占比


x=[1,2,2,1];  %%类别未知的新样本
y=label';  %%将决策属性的取值由列向量转为行向量
he=zeros(n-1,length(y));  %%存储在决策属性的每个不同取值所覆盖的样本中，不同条件属性取未知样本X中的值的样本的个数
ra=zeros(n-1,length(y)); %%存储条件概率，即P(Xk/yi)

for i=1:m  %%对数据集中的每一行
    for j=1:n-1 %%对每个条件属性
        for s=1:length(y)  %%对每个决策属性的取值
            if (data(i,j)==x(j)) && (data(i,n)==y(s))  %%判断在决策属性的某个取值下，某条件属性的值是否恰好等于X在该属性上的取值
                he(j,s)=he(j,s)+1;  %%统计符合要求的样本的数量
            end
        end
    end
end

for i=1:n-1
    for j=1:length(y)
       ra(i,j)=he(i,j)/num(j,2);  %%计算P(Xk/yi)
    end
end

P=ones(1,length(y));  %%P中存放最终的概率计算的结果
 
for j=1:length(y)   %%对每个决策属性
    P(1,j)=P(1,j)*num(j,3);  %%先乘以每个决策取值自身的占比，即P(YI)
    for i=1:n-1   %%对每个条件属性
        P(1,j)=P(1,j)*ra(i,j);  %%计算P(yi)*P(Xk/yi)
    end
end
