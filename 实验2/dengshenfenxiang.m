%clear;clc
%装载数据
A = rand(20,5);
%排序,1为列,2为行,'ascend'升序,'descend'降序
A = sort(A,1,'ascend');
%% 等深分箱深度,深度为3
h = 3;
%对每列进行等深分箱，
[n,m] = size(A);
s1 = fix(n/h);
ans_deep = zeros(s1,m);

for j = 1:m
    cnt = 1;
    for i = 1:h:n
        %求出每个箱子的左右区间
        L = int64(i);
        R = int64(min(i+h-1,n)); 
        ans_deep(cnt,j) = mean(A(L:1:R,j));%求出每个箱子的均值
        cnt = cnt + 1;
    end
end

%% 等宽分箱宽度
B = [0.2,0.4,0.6,0.8];  %直接划分到5个箱子中
Sum = zeros(5,m);   %每个箱子的和
Num = zeros(5,m);    %每个箱子的数量
Avg = zeros(5,m);    %每个箱子的均值

%求每一行落到每个箱子中的数值的个数、和和均值
for i=1:m
    for j=1:n
        if A(j,i)<=B(1)
        Sum(1,i)=Sum(1,i)+A(j,i);
        Num(1,i)=Num(1,i)+1;
        else if A(j,i)>B(1) && A(j,i)<=B(2)
          Sum(2,i)=Sum(2,i)+A(j,i);
          Num(2,i)=Num(2,i)+1;  
        else if A(j,i)>B(2) && A(j,i)<=B(3)
               Sum(3,i)=Sum(3,i)+A(j,i);
               Num(3,i)=Num(3,i)+1;
        else if A(j,i)>B(3) && A(j,i)<=B(4)
                  Sum(4,i)=Sum(4,i)+A(j,i);
                  Num(4,i)=Num(4,i)+1;  
        else if  A(j,i)>B(4)
                       Sum(5,i)=Sum(5,i)+A(j,i);
                       Num(5,i)=Num(5,i)+1; 
            end
            end
            end
            end
        end
    end
end
% 求每个箱子均值
for i=1:m
    for j=1:5
        Avg(j,i)=Sum(j,i)./Num(j,i);
    end
end