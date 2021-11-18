clear;
clc;
%装载数据
data = load('data.mat').data;
[m,n] = size(data);

% 求初始信息熵
label_value = data(:,n); %取出决策属性
label = unique(label_value); %确定有几个决策属性
label_num = zeros(length(label),2); % 第一列为决策属性取值，第二列为存储该取值的个数，相当于map[属性]++

label_num(:,1) = label';
for i = 1:length(label)
    label_num(i,2) = sum(label_value == label(i)) / m; %求不同决策属性出现概率
end
E0 = sum(-label_num(:,2).*log2(label_num(:,2)));
fprintf("初始信息熵为:%f\n",E0);

%计算每个条件属性的不同取值的个数，并获得信息增益、信息熵
%选取第i个条件属性做处理
E = zeros(n-1,1);%信息熵
G = zeros(n-1,1);%信息增益
for i=1:n-1 %对每个属性单独处理
    A = data(:,i);
    A_unique = unique(A);
    A_num = length(A_unique); %去重
    for j=1:A_num %计算第i个属性的第j个取值的值
        new_data = data(A == A_unique(j),:);%相当于select语句
        son = new_data(:,n);%提取其决策
        son_unique = unique(son);
        son_num = length(son_unique);
        [new_m,new_n] = size(new_data);
        %计算概率
        p = zeros(1,son_num);
        for k=1:son_num
            p(k) = sum(son_unique(k) == son)/new_m;
        end
        weigth = new_m / m;
        E(i) = E(i) + weigth * sum(-p.*log2(p)); %求信息熵
    end
    G(i) = E0 - E(i);%计算信息增益
    fprintf("获得第%d个属性后，信息熵为%f，信息增益为%f\n",i,E(i),G(i));
end
[Gain_max,pos] = max(G);
fprintf("选择第%d个属性时，信息增益为%f时最大\n",pos,Gain_max);