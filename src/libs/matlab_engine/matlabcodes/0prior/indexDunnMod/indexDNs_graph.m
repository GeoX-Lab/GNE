function value = indexDNs_graph(G,labels,isDirected)
% INDEXDNG_GRAPH computes the Modified Dunn's index on already built graph. 
% Best cluster partition maximizes the index value.
% value = INDEXDNS(data,labels,graph_type,options)
%--------------------------------------------------------------------------
% INPUTS:
%   G               (matrix)	graph on data points; output of function
%                               graph_create()
%
%	labels			(vector)	array of non-negative integers determining
%								the labels of data samples
%
%	isDirected		(scalar)	does the graph have directed edges?
%								0 - no (default)
%                               1 - yes (if graph_type == 'directedKnn')
%--------------------------------------------------------------------------
% OUTPUTS:
%   value			(scalar)	value of index
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

if  ~exist('isDirected','var') || isempty(isDirected)
	isDirected=0;
end


lab_uniq=unique(labels);
K=length(lab_uniq);


% Find all (shortest) distances between data points (nodes in the [un]directed graph G)
[dist] = graphallshortestpaths(G,'Directed',isDirected);

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
		warning('indexDNs:unconnected','Some points in the graph are not connected to the rest of the cluster! Decrease tolerance when creating graph.');
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