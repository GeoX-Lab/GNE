function [G,d,uniqueInd]=graph_create(data,labels,graph_type,options)
% GRAPH_CREATE  creates a graph of graph_type on data.
% Usage: [G,d,uniqueInd]=GRAPH_CREATE(data,labels,graph_type,options)
%--------------------------------------------------------------------------
% INPUTS:
%   data			(matrix)	matrix [n X d] with n d-dimensional samples
%	labels			(vector)	(for plotting only!) 
%                               array of non-negative integers determining
%								the labels of data samples
%                               use [] if there is no labels
%	graph_type		(scalar)	which type of graph to use. Select from:
%								'rng'		- relative neighborhood graph
%								'gabriel'	- Gabriel graph
%								'directedKnn' 
%								'mutualKnn'	
%								'symKnn'	- symmetric KNN graph
%								'EMST'		- Euclidean Minimum Spanning Tree graph
%								'epsilon'	- Epsilon graph
%	options.k - connectivity parameter of the kNN graph [default=3]
%	options.eps - threshold of the epsilon graph [default=auto]
%	options.show - if 0, plot of the graph is not shown [default=0]
%--------------------------------------------------------------------------
% OUTPUTS:
%   G - sparse matrix representing a graph
%   d - [n x n] symmetric matrix containing pair-wise distances between data points. 
%   uniqueInd - indices of unique data points if the duplicates removal
%               occurs; [] otherwise.
%--------------------------------------------------------------------------
% Copyright (C) 2013,  Nejc Ilc
%--------------------------------------------------------------------------

if (nargin < 3) 
	  error(' GRAPH_CREATE: graph_type required!'); 
end

[N,D]=size(data);

if isempty(labels)
	labels=ones(N,1);
end

if ~exist('options','var')
	options = [];
end

if ~isfield(options,'k')
    options.k=3;
end

if ~isfield(options,'eps')
    options.eps=[];
end

if ~isfield(options,'show')
    options.show=0;
end


% Check data for duplicates and remove them.
[dataUniq,iA,iB] = unique(data,'rows');
uniqueInd = [];

if size(dataUniq,1) ~= N
    warning('graph_create:unique','There are duplicates in the data. Only unique data points will be considered.');
    labels=labels(iA);
    data = dataUniq;
    uniqueInd = iA;
end




% Construct graph on the data
switch(graph_type)
	case 'rng'
		[G,d] = graph_rng(data, 1, 1e-10);	
	
	case 'gabriel'
		[G,d] = graph_gabriel(data, 1, 1e-10);
	
	case 'EMST'
		[G,d] = graph_EMST(data,[]);
		
	% WARNING! Knn (directed, mutual, symm) and epsilon graph will probably consists of more than one component,
	% thus there could be no connection between clusters. 
	case 'directedKnn'
		d = dist_euclidean(data,data);
		G = graph_directedKnn(d,options.k,'dist');
	
	case 'epsilon'
		d = dist_euclidean(data,data);
		% if options.eps is [], estimation for "good" epsilon is calculated
		G = graph_epsilon(d,options.eps,'dist');
	
	case 'mutualKnn'
		d = dist_euclidean(data,data);
		G = graph_mutualKnn(d,options.k,'dist');
	
	case 'symKnn'
		d = dist_euclidean(data,data);
		G = graph_symmetricKnn(d,options.k,'dist');
			
	otherwise
		error(' GRAPH_CREATE: Wrong graph type!');
end

%G=sqrt(G); %switch from squared euclidean to euclidean distances

if (options.show==1)
	
	for L=1:size(labels,2)
		lab_uniq=unique(labels(:,L));
		K=length(lab_uniq);

		fig=figure();
		gplot(G,data,'-k');
		hold on;
		p_options.fig=fig;
		p_options.title=[graph_type, ', labels=',num2str(L)];
		pplk_scatterPlot(data,labels(:,L),K,p_options);
		axis('equal');
		hold off;
	end
elseif (options.show==2)
	if strcmp(graph_type,'directedKnn')
		view(biograph(G,[],'ShowArrows','on','ShowWeights','on'));
	else
		view(biograph(G,[],'ShowArrows','off','ShowWeights','on'));
	end
end

end