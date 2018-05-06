function visitfreq=hotvisit(od,group,grid)

for i=1:length(unique(group))
    ind=find(group==i);
    tempod=od(ind,ind);
    tempgrid=grid(ind);
    tempvisit=sum(tempod,1)';
    eval(['visitfreq.region',num2str(i),'=[tempgrid tempvisit];'])
    T=table(tempgrid,tempvisit,'VariableNames',{'gridID','visitFreq'});
    eval(['writetable(T,''visitfreq_region',num2str(i),'.csv'')'])
end

