function [regionpoi,vclust]=poi_region(poitab,tfgroup,tfgrid)

%poitab:a table, VariableNames=['gridID','t1','t2',...'t19']
%tfgroup:the clustering results of Time Feature matrix, a column vector
%tfgrid:the gridID

poigrid=table2array(poitab(:,1));
poi=table2array(poitab(:,2:end));
if max(tfgrid)<1750
	[newpoi,newpoigrid]=grid500to1000(poi,poigrid);
else
	newpoi=poi;
	newpoigrid=poigrid;
end

[vgrid,ia,ib]=intersect(newpoigrid,tfgrid);
newpoi=newpoi(ia,:);
newgrps=tfgroup(ib,:);
regionpoi=zeros(length(unique(newgrps)),size(newpoi,2));
for i=1:length(unique(newgrps))
	regionpoi(i,:)=sum(newpoi(newgrps==i,:),1);
end
vclust=[vgrid,newgrps];
end
