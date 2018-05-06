function [newL2] = match(L1,L2)
%match: permute labels of L2 to match L1 as good as possible
%将聚类结果L2以L1为基准进行对齐
%   version (original): bestMap.m(Written by Deng Cai (dengcai AT gmail.com)) using hugarian.m
%   Rewritten by Lin (linxin2015 AT csu.edu.cn)

%===========    

L1 = L1(:);
L2 = L2(:);
newL2=zeros(size(L2,1),size(L2,2));

if size(L1) ~= size(L2)
    error('size(L1) must == size(L2)');
end

Label1 = unique(L1);
nClass1 = length(Label1);
Label2 = unique(L2);
nClass2 = length(Label2);

nClass=min(nClass1,nClass2);

for i=1:nClass
    A{i}=find(L1==i);
    B{i}=find(L2==i);
end

for i=1:nClass
    for j=1:nClass
    count(i,j)=length(intersect(A{i},B{j}));
    end
end

for t=1:nClass
    if count(:)==0
    indx=find(newL2~=L2);
    newL2(indx)=L2(indx);
    break
    end
[row(t),col(t)]=find(count==max(count(:)));

newL2(L2==col(t))=row(t);
    
count(row(t),:)=0;
count(:,col(t))=0;

end
end

