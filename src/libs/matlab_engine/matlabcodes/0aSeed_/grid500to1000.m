function [data2,grid2]=grid500to1000(data1,grid1)

%Input:
%data1:data's location representated by grids whose size is 500m*500m. Rows are observations.
%grid1:the valid grid ID of data1

%Output:
%data2:data's location representated by grids whose size is 1000m*1000m. Rows are observations.
%grid2:the valid grid ID of data1

g500=0:6999;
shp500=reshape(g500,100,70)';
shp500=flip(shp500,1);

gmap0=repmat(0:1749,2,1);
gmap0=reshape(gmap0,100,length(0:1749)/50)';
gmap0=flip(gmap0,1);
gmap=zeros(size(shp500));
for i=1:size(gmap0,1)
	newi=2*i-1;
	gmap(newi:newi+1,:)=repmat(gmap0(i,:),2,1);
end

checklist=[shp500(:) gmap(:)];

[~,ia,~]=intersect(checklist(:,1),grid1);
grid2=checklist(ia,2);

if isempty('data1')
	grid2=[grid1 grid2];
	return
else
	newchecklist=[grid1 grid2];
	grid2=unique(grid2);
    data2=zeros(length(grid2),size(data1,2));
	for i=1:length(grid2)
		[~,ia,~]=intersect(newchecklist(:,2),grid2(i));
		data2(i,:)=sum(data1(ia,:),1);
	end
end

end
