function [G,dist,connect] = graph_gabriel(data,noplot,tol)
% GRAPH_GABRIEL finds the Gabriel connectivity graph among data points.
% Usage: [G,dist,connect] = graph_gabriel(data,noplot,tol)
%--------------------------------------------------------------------------
% INPUTS:
% data   :  [n x p] matrix of point coordinates.
% noplot :  optional boolean flag indicating that plot should be 
%           suppressed [default = 0].  Plot of the Gabriel graph
%           is produced only for p=2.
% tol    :  optional tolerance for squared distance from a third point 
%           to the minimum A-B circle (i.e., that circle on whose 
%           circumference A & B are at opposite points) [default = 1e-6].
%--------------------------------------------------------------------------
% OUTPUTS:
% G       : [n x n] sparse matrix that represents a graph. Nonzero entries 
%           in matrix G represent the weights of the edges.
% dist    : corresponding edge lengths (Euclidean distances);
%           non-connected edge distances are given as zero.
% connect : [n x n] boolean adjacency matrix.
%--------------------------------------------------------------------------
% REFERENCES 
% Gabriel, KR & RR Sokal. 1969. A new statistical approach to geographic 
%   variation analysis.  Syst. Zool. 18:259-278.
%
% Matula, DW & RR Sokal. 1980. Properties of Gabriel graphs relevant to
%   geographic variation research and the clustering of points in the plane.  
%   Geogr. Analysis 12:205-222.
%--------------------------------------------------------------------------
% Copyright RE Strauss, 1/8/99
%   9/7/99 -   changed plot colors for Matlab v5.
%   10/23/02 - remove restriction of p==2;
%              produce plot only for p==2.
%   6/4/03 -   added tolerance to the minimum A-B circle.
%--------------------------------------------------------------------------
  if (nargin < 2) 
	  noplot = []; 
  end;
  if (nargin < 3) 
	  tol = []; 
  end;

  if (isempty(noplot)) 
	  noplot = 0; 
  end;
  if (isempty(tol))    
	  tol = 1e-10; 
  end;
  
  [n,p] = size(data);

  if (n<2)
    error('  GABRIEL: requires at least two points ');
  end;

  connect = zeros(n,n);

  dist = (dist_euclidean(data,data));		 % Faster implementation by Piotr Dollar
  d = dist;
  
  for i = 1:(n-1)                       % Cycle thru all possible pairs of points
    for j = (i+1):n
      dij = d(i,j);
      c = 1;
      for k = 1:n
        if (k~=i && k~=j)
          if (d(i,k)+d(j,k)-tol <= dij)
            c = 0;
          end;
        end;
      end;
      if (c)
        connect(i,j) = 1;
        connect(j,i) = 1;
      else
        dist(i,j) = 0;
        dist(j,i) = 0;
      end;
    end;
  end;

  % form graph format
  G=sparse(tril(dist));
  
  
  if (~noplot && p==2)
    figure;
    plot(data(:,1),data(:,2),'ko');
    putbnds(data(:,1),data(:,2));
    axis('equal');
    hold on;
    for i = 1:(n-1)
      for j = 2:n
        if (connect(i,j))
          plot(data([i j],1),data([i j],2),'k');
        end;
      end;
    end;
    hold off;
  end;

  return;
