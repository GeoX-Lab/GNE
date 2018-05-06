function [n1,n2,auc]=compute_auc(X,emb,percent,n);
%X:the relation graph
%emb:embedding vectors,rows=observations
%percent:the percent of hide links
%n:the times of comparison

[edg(:,1),edg(:,2),edg(:,3)]=find(X);
[nonedg(:,1),nonedg(:,2),nonedg(:,3)]=find(X==0);

order=randperm(length(edg));
edg_tr=edg(1:round(length(order)*percent),:);%ÑµÁ·¼¯

ind1=randi([1,length(edg_tr)],1,n);
ind2=randi([1,length(nonedg)],1,n);

n1=0;
n2=0;

for i=1:n
    x=ind1(i);
    dist1=pdist([emb(edg_tr(x,1),:);emb(edg_tr(x,2),:)]);
    
    y=ind2(i);
    dist2=pdist([emb(nonedg(y,1),:);emb(nonedg(y,2),:)]);
%     dist2=pdist([emb(nonedg(ind2(i),1),:);emb(nonedg(ind2(i),2),:)]);
    if dist1<dist2
        n1=n1+1;
    else
        if dist1==dist2
            n2=n2+1;
        end
    end
end

auc=(n1+0.5*n2)/n;