clear;clc;
load('data.mat');
A = data;

min_sup = 2;%支持计数，未除n
min_con = 0.5;%最小置信度

% 求频繁k项集
[n,m] = size(data);%n为交易的次数，m为商品次数
for i = 1:n
    shop{i} = find(A(i,:) == 1); %第i次交易都买了哪些商品
end

k = 0;%代表频繁k项集

while 1
    k = k + 1;
    %迭代求频繁k项集
    L{k} = {};%频繁项集
    if k == 1
        C{k} = (1:m)';
    else 
       cnt = 0;
       [LN,LM] = size(L{k-1});%每两项进行合并
       for i = 1:LN
           for j = i + 1:LN
                tmp = union(L{k-1}(i,:),L{k-1}(j,:));
                if length(tmp) == k
                    cnt = cnt + 1;
                    C{k}(cnt,1:k) = tmp;
                end
           end
       end
       C{k} = unique(C{k},'rows'); % 得到候选k项集
    end
    [CN,CM] = size(C{k});
    for i = 1:CN
        cnt = 0;
        for j = 1:n
            if all(ismember( C{k}(i,:),shop{j} ),2)==1 %是一组的
                cnt = cnt + 1;
            end
        end
        C_sup{k}(i,1) = cnt;%求支持度
    end
   L{k} = C{k}(C_sup{k} >= min_sup,:);%求频繁k项集
   len = size(L{k},1); %求频繁项集行数
   if len == 0 %没找到频繁k项集
       break;
   elseif len == 1 %只有1行，则不可能生产k+1项集
       break;
   end
end

fprintf("\n");
for i=1:k
    fprintf("第%d轮候选集为:\n",i);
    C{i}
    if i == k
        break;
    end
    fprintf("\n频繁%d-项集为:\n",i);
    L{i}
end

%生成强的关联规则
[LN,LM] = size(L{k-1}); %最大的频繁k项集

tot_cnt = 0;

for p=1:LN %第p个频繁项集, p(ab)/p(a)
    tmp = L{k-1}(p,:); %提取出每一项
    cnt_ab = 0;
    for i=1:n %求p(ab);
        if all(ismember(tmp,shop{i}),2) == 1
            cnt_ab = cnt_ab + 1;
        end
    end
    %枚举划分
    len = length(tmp);
    for i=1:len-1%生成a->b
        matrix_a = nchoosek(tmp,i);%生成了a矩阵
        [NA,MA] = size(matrix_a);
        for j = 1:NA %求cnt_a
            cnt_a = 0;
            for z = 1:n
                if all(ismember( matrix_a(j,:),shop{z}),2) == 1
                    cnt_a = cnt_a + 1;
                end
            end
            Paba = (cnt_ab / cnt_a);
            if  Paba >= min_con %满足最小置信度
                matrix_b = setdiff(tmp,matrix_a(j,:)); %生成b
                a_len = i;
                b_len = len - a_len;
                tot_cnt = tot_cnt + 1;
                rule(tot_cnt,1:a_len) = matrix_a(j,:); % 产生了a
                rule(tot_cnt,a_len + 1) = -2019214192; %分隔符标志位
                rule(tot_cnt,a_len+2:a_len+1+b_len) = matrix_b; %生成b
                rule(tot_cnt,len+2) = Paba; %置信度
            end 
        end
    end
end
fprintf("支持度为2，置信度为0.75时生成的强关联规则为:\n");

for i = 1:tot_cnt
    len = length(rule(i,:));
    for j = 1:len-1
        if rule(i,j) ~= -2019214192
            fprintf("%d  ",rule(i,j));
        else
            fprintf("=>  ");
        end
    end
    fprintf("   置信度为%f\n",rule(i,len));
end





