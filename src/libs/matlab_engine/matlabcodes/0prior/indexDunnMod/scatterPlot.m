function [fig]=scatterPlot(data,labels,options)
% [fig]=SCATTERPLOT(data,labels,options)
% DESCRIPTION:	Function scatterPlot plots a scatter plot of
%				data clustering performed on data resultng in vector
%				labels.
%
% INPUTS:		data			(matrix)	input data, size of [N x D]
%				labels			(vector)	clustering
%								(matrix)	set of clusterings - plot them
%											on the subfigure
%				K				(int)		number of clusters
%				options			(struct)	options structure; can be
%											[] or non-existent for defaults;
%								Fields:
%									.title
%                                   .subtitle (cell of strings - one string for each subplot)
%									.axisLabels (1x2 cell of strings)
%									.axisTicks (1x2 cell of vectors)
%									.colorMode ['color'|'pattern'|'mixed']
%									.fig - force this figure handle
%									.annotations (n x 1) cell of strings,
%												  where n is number of data points
%                                   .markerSize (int) size of the marker
%
% OUTPUTS:		fig				(handle)	handle on figure
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Last modification: 10.6.2013
% (C) 2013, Nejc Ilc (name.surname@gmail.com)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%DEFAULTS
axisTitle='';
axisSubtitle='';
axisLabels={'',''};
axisTicks={[],[]};
colorMode='color';
annotations={};
mS=20; %marker size


if(exist('options','var'))
    if isfield(options,'title')
        axisTitle=options.title;
    end
    if isfield(options,'subtitle')
        axisSubtitle=options.subtitle;
    end
    if isfield(options,'axisLabels')
        axisLabels=options.axisLabels;
    end
    if isfield(options,'axisTicks')
        axisTicks=options.axisTicks;
    end
    if isfield(options,'colorMode')
        colorMode=options.colorMode;
    end
    if isfield(options,'fig')
        figure(options.fig);
        fig=options.fig;
    else
        fig=figure();
    end
    if isfield(options,'annotations')
        annotations=options.annotations;
    end
    if isfield(options,'markerSize')
        mS=options.markerSize;
    end
end

% force labels vector to be a column vector
if isvector(labels)
    labels = labels(:);
end

suptitle(axisTitle);

%-------------------------------------------------------------------------
[N,D]=size(data);

if(D>2)
    %PCA projection onto 2D
    n=2;
    [~, newData]=princomp(data,'econ');
    data=newData(:,1:n);
    
end

patterns={'+','o','x','^','square','diamond','*','.','v','>','<','pentagram','hexagram'};
nP=numel(patterns);


% produce subplot for every clustering in columns of labels
ensembleSize = size(labels,2);

% max 4 subplots in a row of panel
nCols = min(ensembleSize,4);

nRows=floor(ensembleSize/nCols);
if rem(ensembleSize,nCols)~=0
    nRows=nRows+1;
end



labelsAll = labels;

for plotInd = 1:ensembleSize
    labels = labelsAll(:,plotInd);
    K = length(unique(labels));
    
    if(K<5)
        colors=[    218/255 37/255 29/255; ... %red
                    40/255 22/255 111/255; ... % dark blue
                    132/255 194/255 37/255; ... % green
                    232/255 188/255 0/255]; % yellow
        
    else
        colors=colormap(jet(K*10));
        colors=colors(1:10:end,:);
    end
    
    subplot(nRows,nCols,plotInd);
    
    %COLOR MODE - color
    if(strcmp(colorMode,'color'))
        
        for i=1:K
            plot(data(labels==i,1),data(labels==i,2),'.','color',colors(i,:),'markersize',mS);
            hold on;
        end
        hold off;
        
        
        %COLOR MODE - patterns
    elseif (strcmp(colorMode,'pattern'))
        %marker size
        mS=10;
        
        for i=1:K
            plot(data(labels==i,1),data(labels==i,2),['k',patterns{mod(i-1,nP)+1}],'markersize',mS);
            hold on;
        end
        hold off;
        
        
        %COLOR MODE - mixed (filled, big patterns)
    elseif (strcmp(colorMode,'mixedClear'))
        %marker size
        mS=20;
        patterns={'o','>','pentagram','v','square','diamond','^','hexagram','<','.','*','x','+'};
        
        
        for i=1:K
            plot(data(labels==i,1),data(labels==i,2),patterns{mod(i-1,nP)+1},'MarkerFaceColor',colors(i,:),'MarkerEdgeColor',colors(i,:),'markersize',mS);
            hold on;
        end
        hold off;
        
    else
        %marker size
        mS=10;
        
        for i=1:K
            plot(data(labels==i,1),data(labels==i,2),patterns{mod(i-1,nP)+1},'color',colors(i,:),'markersize',mS);
            hold on;
        end
        hold off;
    end
    
    % plot annotations below data points as well
    if ~isempty(annotations)
        assert(length(annotations) == N);
        offset = (max(data(:,2))-min(data(:,2)))/100;
        for ind=1:N
            of = offset*2*rand();
            text(data(ind,1), data(ind,2)-of, annotations{ind},'FontSize',8,'Interpreter','None','HorizontalAlignment','center','VerticalAlignment','top','Rotation',0);
            
        end
    end
    
    if ~isempty(axisTicks{1}) && ~isempty(axisTicks{2})
        set(gca, 'XTick',axisTicks{1},'YTick',axisTicks{2});
    end
    
    if iscell(axisSubtitle)
        title(axisSubtitle(plotInd));
    end
    
    xlabel(axisLabels{1});
    ylabel(axisLabels{2});
    
    axis('equal');
    axis('square');
end

