function evas=get_clustereval(embs,group,output)

%part one: Clustering criteria

%temp_sil=zeros(size(group));
%temp_dbi=zeros(size(group));
%temp_ch=zeros(size(group));
%temp_di=zeros(size(group));
for mi=1:size(group,2)
    tempeva=evalclusters(embs,group(:,mi),'Silhouette');
    temp_sil(mi)=tempeva.CriterionValues;
    
    tempeva=evalclusters(embs,group(:,mi),'DaviesBouldin');
    temp_dbi(mi)=tempeva.CriterionValues;
    
    tempeva=evalclusters(embs,group(:,mi),'CalinskiHarabasz');
    temp_ch(mi)=tempeva.CriterionValues;
    
    tempeva=dunnsindx(embs,group(:,mi));
    temp_di(mi)=tempeva.CriterionValues;
end
evas=table(temp_sil,temp_dbi,temp_ch,temp_di,'VariableNames',{'sil','dbi','ch','di'});
clear mi tempeva temp_sil temp_dbi temp_ch tempdi

writetable(evas,output)

%part two:tsne-visualization

for i=1:size(group,2)
    figure;
    temptsne=tsne(embs,group(:,i));
    axis off
    title(['tsne-visualization of embedding-clustering results ',num2str(i)])
    set(gca,'Fontname','Times New Roman','Fontsize',16)
end


% export_fig('tsne-visualization of embedding-clustering results','-jpg','-r600')

end