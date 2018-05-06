function grps=get_cluster(embs,grid,n,output)

grps=kmeans(embs,n,'start','sample','maxiter',1000,'replicates',100,'EmptyAction','singleton');

xlswrite(output,[grid,grps])
end