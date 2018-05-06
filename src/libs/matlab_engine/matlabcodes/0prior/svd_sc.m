function [W2,n2,vKS2,kerKS2,c2,group2]=svd_sc(X)
%SVD
N=size(X,2);
MAXiter = 1000; % Maximum iteration for KMeans Algorithm
REPlic = 100;   % Replication for KMeans Algorithm
X=normc(X);

[ U , S , V ] = svd( X ) ;        
W2=abs(V)*abs(V).';
W2=W2-diag(diag(W2));

DKS2 = ( diag( sum(W2)+eps ) )^(-1/2);
Lap2  = speye(N) - DKS2 * W2 * DKS2;
[uKS2,sKS2,vKS2] = svd(Lap2 );

svals2 = diag(sKS2);
[ min_val2 , ind_min2 ] = min( diff( svals2(1:end-1) ) ) ;  
n2 = size(W2 , 1 ) - ind_min2 ;
        
f2 = size(vKS2,2);
kerKS2 = vKS2(:,f2-n2+1:f2);
for i = 1:size(kerKS2,1)
    kerKS2(i,:) = kerKS2(i,:) ./ norm(kerKS2(i,:));
end

[group2,c2] = kmeans(kerKS2,n2,'start','sample','maxiter',MAXiter,'replicates',REPlic,'EmptyAction','singleton');