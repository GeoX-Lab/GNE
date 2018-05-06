function value = indexDNs(data,labels,graph_type,options)
% value = INDEXDNS(data,labels,graph_type,options)
%--------------------------------------------------------------------------
% Modified Dunn's cluster validity index using shortest paths.
% Best cluster partition maximizes the index value.
%--------------------------------------------------------------------------
% INPUTS
%   data		(matrix)	matrix [n X d] with n d-dimensional samples
%
%	labels		(vector)	array of non-negative integers determining
%								the labels of data samples
%
%	graph_type	(scalar)	which type of graph to use. Select from:
%                             'rng'		    - relative neighborhood graph
%                             'gabriel'	    - Gabriel graph
%                             'directedKnn' - directed kNN graph
%                             'mutualKnn'	- mutual kNN graph
%                             'symKnn'	    - symmetric KNN graph
%                             'EMST'		- Euclidean Minimum Spanning 
%                                             Tree graph
%                             'epsilon'	    - Epsilon graph
%
%	options.k    : connectivity parameter of the kNN graph [default=3]
%	options.eps  : threshold of the epsilon graph [default=auto]
%	options.show : if 0, plot of the graph is not shown [default=0]
%--------------------------------------------------------------------------
% OUTPUTS:
%   value        (scalar)	value of index
%
%------- LEGAL NOTICE -----------------------------------------------------
% Copyright (C) 2013,  Nejc Ilc
%
%------- REFERENCE --------------------------------------------------------
% Ilc, N. (2012). Modified Dunn's cluster validity index based on graph
% theory. Przeglad Elektrotechniczny (Electrical Review), (2), 126-131.
%
%------- VERSION ----------------------------------------------------------
% Version: 1.0
% Last modified: 11-June-2013 by Nejc Ilc
%
%------- CONTACT ----------------------------------------------------------
% Please write to: Nejc Ilc <myName.mySurname@gmail.com>
%==========================================================================


if (nargin < 2) 
	  error('indexDNs: Labels required!'); 
end
if (nargin < 3) 
	  graph_type = [];
end

if  ~exist('graph_type','var') || isempty(graph_type)
	graph_type='gabriel';
end

if ~exist('options','var') || isempty(options)
	options.show = 0;
	options.eps = [];
	options.k = 3;
end

lab_uniq=unique(labels);
K=length(lab_uniq);

% Construct graph on the data
G=graph_create(data,labels,graph_type,options);

%G=sqrt(G); %switch from squared euclidean to euclidean distances


% Find all (shortest) distances between data points (nodes in the [un]directed graph G)
if strcmp(graph_type,'directedKnn')
	[dist] = graphallshortestpaths(G,'Directed',true);
else
	[dist] = graphallshortestpaths(G,'Directed',false); 
end

% Compute diameter of each cluster.
% Diameter is the longest distance between any points x and y, where x and
% y belong to the same cluster.
diam=zeros(1,K);
for k=1:K
	%select indices of data points in cluster C_k
	C_ind=(labels==k);
	%pair-wise distances between all points in cluster C_k
	C_dist=dist(C_ind,C_ind);
	
	%some entries of C_dist matrix can contain Inf value - it means that
	%there is no path between two points in cluster. These Inf values can
	%be ignored - we can set them to NaN.
    %Cause for this is probably the occurence of duplicate data point. Try
    %filtering of duplicates in dataset before applying this algorithm.
	C_dist(C_dist==Inf)=NaN;
	if sum(sum(isnan(C_dist)))>0
		warning('indexDNs:unconnected' ,'Some points in the graph are not connected to the rest of the cluster! Decrease tolerance when creating graph.');
	end
	diam(k)=max(max(C_dist));	
end

max_diam=max(diam);

% distances between every pair of clusters i and j
dist_CiCj=Inf*ones(K,K);
for i=1:K-1
	for j=i+1:K
		
		% distance between clusters C_i and C_j is minimum distance between
		% any two points x and y, where x \in C_i and y \in C_j
		Ci_members=(labels==i);
		Cj_members=(labels==j);
		
		% select distances between points in C_i and C_j clusters.
		CiCj=dist(Ci_members,Cj_members);
		
		% compute minimum distance between C_i and C_j
		dist_CiCj(i,j)=min(min(CiCj));
		
		% if C_i and C_j are not connected, 
		if isinf(dist_CiCj(i,j))
			warning('indexDNs:unconnected','Clusters are not connected!');
		end
		
	end
end

value = min(min(dist_CiCj./max_diam));

end