function eva=dunnsindx(varargin)

%varargin={data,kList,labels,distance}
%data:[N*d] matrix
%kList:the number of groups, such as 2:20
%distance: a string that is passed to pdist to calculate distance between
%          data (e.g. 'euclidean', 'correlation', ...). If [],
%          'euclidean' is used as default.\
%labels:[N*s] matrix (s could be 1)



if nargin==1
    disp('输入参数数目不足')
else
    if nargin>3
        disp('输入参数数目过多')
    end
end

data=varargin{1};

if nargin==2
    if length(unique(varargin{2}))==length(varargin{2})
        kList=varargin{2};
    else
        labels=varargin{2};
    end
    distance='euclidean';
end

if nargin==3
    distance=varargin{3};
end

if exist('kList','var')
    dunnevaluation=zeros(size(kList));
    for i=1:length(kList)
        grps=kmeans(data,kList(i),'start','sample','maxiter',1000,'replicates',100,'EmptyAction','singleton');
        dunnevaluation(i)=indexDN(data,grps,distance);
    end
    eva.CriterionName='Dunn''s Index';
    eva.X=data;
    eva.kList=kList;
    eva.CriterionValues=dunnevaluation;
    [~,indx]=max(dunnevaluation);
    eva.optimalK=kList(indx);
else
    if exist('labels','var')
    dunnevaluation=zeros(size(labels,2),1);
    for i=1:size(labels,2)
        dunnevaluation(i)=indexDN(data,labels(:,1),distance);
    end
    eva.CriterionName='Dunn''s Index';
    eva.X=data;
    eva.labels=labels;
    eva.CriterionValues=dunnevaluation;
    [~,indx]=max(dunnevaluation);
    eva.optimalLabels=labels(:,indx);
    end
end

end