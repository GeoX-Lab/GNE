function sepvis=funcannot(tf,group)
%Used for function annotation for each spatial unit(grids, stations or others)
%tf:matrix of Time Feature,each row is an oberservation and each column is
%an variable;
%group:the clustering resualt of spatial units
cmap_sep=[repmat([60 152 158]./255,12,1);...
    repmat([93 181 164]./255,13,1);...
    repmat([244 205 165]./255,13,1);...
    repmat([245 122 130]./255,13,1);...
    repmat([237 82 118]./255,13,1)];

n=length(unique(group));
ep=cell(1,n);
sep=cell(1,n);

for i=1:n
    regfea=tf(group==i,:);
    [ep{i},~,~,~,explained,~]=pca(regfea);
    for j=1:length(explained)
        if sum(explained(1:j))>0.9
            rank(i)=j;
            break
        end
    end
end
rankr=max(rank(:));
for i=1:n
    sep{i}=ep{i}(:,1:rankr);
end

fig1=visual_sep(sep,cmap_sep);

sepvis.sep=sep;
sepvis.fig1=fig1;
sepvis.cmap=cmap_sep;

end