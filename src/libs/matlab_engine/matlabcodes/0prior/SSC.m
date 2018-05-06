function [W,n,vKS,kerKS,c,group]=SSC(X)

%the code of Sparse Subspace Clustering
%X:the data matrix(M*N). Given that each column is an observation, the number of points is N.
%    列为样本
%W, W2: the similarity graphs built by SSC and SVD respectively
%n, n2: the estimations of groups by means of laplacian matrix decomposition(a method of spectral analysis in the field of network theory).
%You can also use the other kinds of laplacian matrix(the standard or random walk one) but the results may be the same.
%OR you can use the clustering criterion to judge the best group number.
%c, c2: the centers of clustering
%group, group2: the clustering results from SSC and SVD respectively.

warning off ;
disp_opt = 0 ;

cvx_solver sdpt3
cvx_quiet(true) ;

N = size(X,2); % total number of points

% for i=1:N
%     X(:,i)=X(:,i)./norm(X(:,i),2);
% end

X=normc(X);
 
 Z =zeros ( N , N ) ;
 for kk = 1 : N
            
    if rem( kk , 10 ) == 0 
                
        disp([num2str(kk), ' of ', num2str( N )] ) ;
    end
    cvx_begin %You have to install the cvx toolbox
            
    variable z( N , 1 ) ;
    minimize norm(z,2)
    subject to
    X(:,kk) == X*z ;
    z(kk)==0 ;
            
    cvx_end
            
    Z(:,kk) = z ;
            
 end
 disp('-------------------------------------------------------------')
 
 MAXiter = 1000; % Maximum iteration for KMeans Algorithm
 REPlic = 100;   % Replication for KMeans Algorithm
 %group for SSC
 W = abs( Z ) + abs( Z.' ) ;
 N = size(W,1);
 disp ('W Done!')
 
 DKS = ( diag( sum(W)+eps ) )^(-1/2);
 Lap  = speye(N) - DKS * W * DKS;
        
[uKS,sKS,vKS] = svd(Lap );
svals = diag(sKS);
[ min_val , ind_min ] = min( diff( svals(1:end-1) ) ) ;  
% n= 
n = size(W, 1 ) - ind_min ;
        
f = size(vKS,2);
kerKS = vKS(:,f-n+1:f);
 for i = 1:N
     kerKS(i,:) = kerKS(i,:) ./ norm(kerKS(i,:));
 end
[group,c] = kmeans(kerKS,n,'start','sample','maxiter',MAXiter,'replicates',REPlic,'EmptyAction','singleton');

%SVD
% [ U , S , V ] = svd( X ) ;        
% W2=abs(V)*abs(V).';
% 
% DKS2 = ( diag( sum(W2)+eps ) )^(-1/2);
% Lap2  = speye(N) - DKS2 * W2 * DKS2;
% [uKS2,sKS2,vKS2] = svd(Lap2 );
% 
% svals2 = diag(sKS2);
% [ min_val2 , ind_min2 ] = min( diff( svals2(1:end-1) ) ) ;  
% n2 = size(W2 , 1 ) - ind_min2 ;
%         
% f2 = size(vKS2,2);
% kerKS2 = vKS2(:,f2-n2+1:f2);
% for i = 1:size(kerKS2,1)
%     kerKS2(i,:) = kerKS2(i,:) ./ norm(kerKS2(i,:));
% end
% 
% [group2,c2] = kmeans(kerKS2,n2,'start','sample','maxiter',MAXiter,'replicates',REPlic,'EmptyAction','singleton');

end