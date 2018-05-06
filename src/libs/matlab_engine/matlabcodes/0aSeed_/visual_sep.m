
function fig1=visual_sep(sep,cmap)
%the varargin should be sep1,sep2,...,sep g,cmap
%their forms are 144*r(the number of significant eigenplaces)

% g=size(varargin,2)-1;%the number of groups
g=size(sep,2);
% cmap=varargin{g+1};
% n=size(varargin{1},2);%count the number of significant eigenplaces
n=size(sep{1},2);
%t={'H','Tr','W','D','E','O'};%according to your types of demands - taxi
%t={'H','E','Tr','W','D','O'};%the check-in data
t={'weekday','weekend'}; %common tfs
d=size(t,2);%count the number of types

h=size(sep{1},1)/d;


tempsep=cell2mat(sep);
cLims=[min(tempsep(:)),max(tempsep(:))];

figure;

if ~(g>6)
    type=1;
    vr=n*d;
    vc=g;
    visplace=reshape(1:n*d*g,g,n*d)';
    
else
    type=2;
    vr=g;
    vc=n*d;
    visplace=reshape(reshape(1:n*d*g,vr,vc),vc,vr);
end
    

switch type
    case 1
        for k=1:g 
            for j=1:n
                for i=1:d
                    eig=sep{k}((h*i-(h-1)):(h*i),j)';
                %     eig=mapminmax(eig);

                    subplot(vr,vc,visplace(d*(j-1)+i,k));
                    imagesc(eig);
                    set(gca,'CLim',cLims);

                    set(gca,'ytick',1,'yticklabel',t{i});
                %     h1=get(gca,'ylabel');
                    set(gca,'fontsize',15,'Fontname','Times New Roman');
                    colormap(cmap);
                %     set(gca, 'CLim', [-0.4745 0.8044]);
                    set(gca,'XTickLabel',[])
                    set(gca,'fontsize',15,'Fontname','Times New Roman','TickLength',[0.03 0.03]);
                    if j==n&&i==d
                        if length(eig)==24
                          set(gca,'xtick',5:5:20,'xticklabel',{'5','10','15','20'});
                        else
                            set(gca,'xtick',[1 (5:5:20)-3 24-3],'xticklabel',{'1','5','10','15','20','24'});%for metro
                        end
                        xlabel(['Region ',num2str(k)])
                    end
                    if i*j*k==1
                        fig1=gca;
                    end
                end
            end
        end
        
    case 2
        for k=1:g 
            for j=1:n
                for i=1:d
                    eig=sep{k}((h*i-(h-1)):(h*i),j)';
                %     eig=mapminmax(eig);

                    subplot(vr,vc,visplace(d*(j-1)+i,k));
                    imagesc(eig);
                    set(gca,'CLim',cLims);

                    set(gca,'ytick',1,'yticklabel',t{i});
                %     h1=get(gca,'ylabel');
                    set(gca,'fontsize',15,'Fontname','Times New Roman');
                    colormap(cmap);
                %     set(gca, 'CLim', [-0.4745 0.8044]);
                    set(gca,'XTickLabel',[])
                    set(gca,'fontsize',15,'Fontname','Times New Roman','TickLength',[0.03 0.03]);
                    if i==1
                        ylabel(['Region ',num2str(k)],'Rotation',0)
                    end
                    if j==n
                        if length(eig)==24
                          set(gca,'xtick',5:5:20,'xticklabel',{'5','10','15','20'});
                        else
                            set(gca,'xtick',[1 (5:5:20)-3 24-3],'xticklabel',{'1','5','10','15','20','24'});%for metro
                        end
                    end
                    if i*j*k==1
                        fig1=gca;
                    end
                end
            end
        end
end

end
