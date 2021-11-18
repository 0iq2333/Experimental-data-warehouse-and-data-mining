clear; clc;

data=[
1	1	0	0	1
0	1	0	1	0
0	1	1	0	0
1	1	0	1	0
1	0	1	0	0
1	1	1	0	1
1	1	1	0	0
];

min_sup=input("请输入最小支持度(正整数，示例：2)\n"); % 最小支持度(未除以n)
min_con=input("请输入最小置信度([0,1]的小数，示例：0.75)\n"); % 最小置信度(已除以n)

[n,m]=size(data);
for i=1:n
	x{i}=find(data(i,:)==1); % 求每行购买商品的编号
end

k=0;
while 1
	k=k+1;
	L{k}={};
	%% 生成候选集C{k}
	if k==1
		C{k}=(1:m)';
	else
		[nL,mL]=size(L{k-1});
		cnt=0;
		for i=1:nL
			for j=i+1:nL
				tmp=union(L{k-1}(i,:),L{k-1}(j,:)); % 两集合并集
				if length(tmp)==k
					cnt=cnt+1;
					C{k}(cnt,1:k)=tmp;
				end
			end
		end
		C{k}=unique(C{k},'rows'); % 去掉重复的行
	end
	%% 求候选集的支持度C_sup{k}
	[nC,mC]=size(C{k}); % 候选集大小
	for i=1:nC
		cnt=0;
		for j=1:n
			if all(ismember(C{k}(i,:),x{j}),2)==1 % all函数判断向量是否全为1，参数2表示按行判断
				cnt=cnt+1;
			end
		end
		C_sup{k}(i,1)=cnt; % 每行存候选集对应的支持度
	end
	%% 求频繁项集L{k}
	L{k}=C{k}(C_sup{k}>=min_sup,:);
	if isempty(L{k}) % 这次没有找出频繁项集
		break;
	end
	if size(L{k},1)==1 % 频繁项集行数为1，下一次无法生成候选集，直接结束
		k=k+1;
		C{k}={};
		L{k}={};
		break
	end
end

fprintf("\n");
for i=1:k
	fprintf("第%d轮的候选集为:",i); C{i}
	fprintf("第%d轮的频繁集为:",i); L{i}
end
fprintf("第%d轮结束，最大频繁项集为:",k); L{k-1}

[nL,mL]=size(L{k-1});
rule_count=0;
for p=1:nL % 第p个频繁集
	L_last=L{k-1}(p,:); % 之后将L_last分成左右两个部分，表示规则的前件和后件
	%% 求ab一起出现的次数cnt_ab
	cnt_ab=0;
	for i=1:n
		if all(ismember(L_last,x{i}),2)==1 % all函数判断向量是否全为1，参数2表示按行判断
			cnt_ab=cnt_ab+1;
		end
	end
	len=floor(length(L_last)/2);
	for i=1:len
		s=nchoosek(L_last,i); % 选i个数的所有组合
		[ns,ms]=size(s);
		for j=1:ns
			a=s(j,:);
			b=setdiff(L_last,a);
			[na,ma]=size(a);
			[nb,mb]=size(b);
			%% 关联规则a->b
			cnt_a=0;
			for i=1:na
				for j=1:n
					if all(ismember(a,x{j}),2)==1 % all函数判断向量是否全为1，参数2表示按行判断
						cnt_a=cnt_a+1;
					end
				end
			end
			pab=cnt_ab/cnt_a;
			if pab>=min_con % 关联规则a->b的置信度大于等于最小置信度，是强关联规则
				rule_count=rule_count+1;
				rule(rule_count,1:ma)=a;
				rule(rule_count,ma+1:ma+mb)=b;
				rule(rule_count,ma+mb+1)=ma; % 倒数第二列记录分割位置(分成规则的前件、后件)
				rule(rule_count,ma+mb+2)=pab; % 倒数第一列记录置信度
			end
			%% 关联规则b->a
			cnt_b=0;
			for i=1:na
				for j=1:n
					if all(ismember(b,x{j}),2)==1 % all函数判断向量是否全为1，参数2表示按行判断
						cnt_b=cnt_b+1;
					end
				end
			end
			pba=cnt_ab/cnt_b;
			if pba>=min_con % 关联规则b->a的置信度大于等于最小置信度，是强关联规则
				rule_count=rule_count+1;
				rule(rule_count,1:mb)=b;
				rule(rule_count,mb+1:mb+ma)=a;
				rule(rule_count,mb+ma+1)=mb; % 倒数第二列记录分割位置(分成规则的前件、后件)
				rule(rule_count,mb+ma+2)=pba; % 倒数第一列记录置信度
			end
		end
	end
end

fprintf("当最小支持度为%d，最小置信度为%.2f时，生成的强关联规则：\n",min_sup,min_con);
fprintf("强关联规则\t\t置信度\n");
[nr,mr]=size(rule);
for i=1:nr
	pos=rule(i,mr-1); % 断开位置，1:pos为规则前件，pos+1:mr-2为规则后件
	for j=1:pos
		if j==pos
			fprintf("%d",rule(i,j));
		else 
			fprintf("%d∧",rule(i,j));
		end
	end
	fprintf(" => ");
	for j=pos+1:mr-2
		if j==mr-2
			fprintf("%d",rule(i,j));
		else 
			fprintf("%d∧",rule(i,j));
		end
	end
	fprintf("\t\t%f\n",rule(i,mr));
end
