%--------------------------------------------------------------------------
% This function takes a NxN matrix CKSym as adjacency of a graph and 
% computes the segmentation of data from spectral clustering. It estimates
% the number of subspaces using eigengap heuristic
% CKSym: NxN adjacency matrix
% Grps: [grp1,grp2,grp3] for three different forms of Spectral Clustering
% eigvals: [ev1,ev2,ev3] singular values for three different forms of SC
% LapKernel(:,:,i): n last columns of kernel of laplacian to apply KMeans
%--------------------------------------------------------------------------
% Matrices concluded by Hua-Wei Shen and Xue-Qi Cheng in the paper //Spectral
% methods for the detection of network community structure: a comparative
% analysis//
%   1. The normalized Laplacian matrix and the correlation matrix significantly
%   outperform the other three matrices(the adjacency matrix, the modularity
%   matrix and the standard laplacian matrix). So we comment out the codes.
%   2. The correlation matrix is similar to the normalized symmetric matrix, so
%   we do not display the codes for the correlation matrix.
%   3. The key point is that the index of the largest eigengap stands for
%   the number of clusters(the eigengap heuristic)

% Modified version of SpectralClustering written by Lin Xin
%--------------------------------------------------------------------------

function [n, group ,vKS, kerKS,evals, Lap] = SpectralClustering(CKSym, option )

CKSym=CKSym-diag(diag(CKSym));
N = size(CKSym,1);
MAXiter = 1000; % Maximum iteration for KMeans Algorithm
REPlic = 100;   % Replication for KMeans Algorithm

if nargin==1
    option=1;
end

switch option
    case 1
        % Method 1: Random Walk Method - Normalized Laplacian matrix
        DKN=( diag( sum(CKSym) ) )^(-1);
        Lap = speye(N) - DKN * CKSym;
        
        [evec, evals] = eig( Lap );
        evals=diag(evals);
        
        evals = sort(evals);
       [~, ind] = max(diff(evals(2:end)));
       n = ind+1;
        [ max_val , n ] = max( diff( evals(2:end) ) ) ;  
        
        kerKN = evec(:,1:n);
        group = kmeans(kerKN,n,'start','sample','maxiter',MAXiter,'replicates',REPlic,'EmptyAction','singleton');
        
        vKS=evec;
        kerKS=kerKN;

    case 2
        % Method 2: Normalized Symmetric for Similarity matrix
        DKS = ( diag( sum(CKSym)+eps ) )^(-1/2);
        Lap  = speye(N) - DKS * CKSym * DKS;
        [evec,evals] = eig(Lap );
        evals=diag(evals);
        evals=sort(evals);
        [~, ind] = max(diff(evals(2:end)));
        n = ind+1;
        
        kerKS = evec(:,1:n);
        for i = 1:N
            kerKS(i,:) = kerKS(i,:) ./ norm(kerKS(i,:));
        end
        
        group = kmeans(kerKS,n,'start','sample','maxiter',MAXiter,'replicates',REPlic,'EmptyAction','singleton');
        
        vKS=evec;
        
    case 3
    N = size(CKSym,1);
    DKS = ( diag( sum(CKSym)+eps ) )^(-1/2);
     Lap  = speye(N) - DKS * CKSym * DKS;
        
    [uKS,sKS,vKS] = svd(Lap );
    evals = diag(sKS);
    [ min_val , ind_min ] = min( diff( evals(1:end-1) ) ) ;  
    n = N-ind_min ;
    
    f = size(vKS,2);
    kerKS = vKS(:,f-n+1:f);
    for i = 1:N
        kerKS(i,:) = kerKS(i,:) ./ norm(kerKS(i,:));
    end
    [group,c] = kmeans(kerKS,n,'start','sample','maxiter',MAXiter,'replicates',REPlic,'EmptyAction','singleton');

%     case4
%         % Method 1: Adjacency matrix
%         [evec,evals] = eig(CKSym );
%         evals = diag(evals);
%         
%         [ max_val , max_ind ] = max( diff( evals ) ) ;  
%         n= N - max_ind;
%         
%         kerKA = evec(:,1:n+1);
%         
%         group = kmeans(kerKA,n,'start','sample','maxiter',MAXiter,'replicates',REPlic,'EmptyAction','singleton');
    
%     case 5
%         % Method 1: Standard Laplacian matrix
%         DKU = diag( sum(CKSym) );
%         Lap  = DKU - CKSym;
%         
%         [evec,evals] = eig(Lap );
%         
%         evals = diag(evals);
%         std_evals=log(evals);
%         [ max_val , max_ind ] = max( diff( std_evals(2:end)) )  ;  
%         n=max_ind+1;
%         
%         kerKU = evec(:,1:n);
%         group = kmeans(kerKU,n,'start','sample','maxiter',MAXiter,'replicates',REPlic,'EmptyAction','singleton');
        

end 