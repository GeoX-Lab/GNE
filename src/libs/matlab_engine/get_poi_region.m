function [regionpoi,vclust]=get_poi_region(poitab,tfgroup,tfgrid,output)

%poitab:a table, VariableNames=['gridID','t1','t2',...'t19']
%tfgroup:the clustering results of Time Feature matrix, a column vector
%tfgrid:the gridID
%output: the output file path, such as 'F:\poivectors_inregion.csv'
if ~exist('tfgrid','var')
	tfgrid=1:size(tfgroup,1);
	tfgrid=tfgrid';
end

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

if isempty(vclust)||isempty(vgrid)
    error('Area of POI is not occupied with the area of data.')


xlswrite(output,regionpoi)
end
