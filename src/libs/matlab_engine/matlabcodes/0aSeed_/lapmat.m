function [Lap,evals,n] = lapmat(adj, option )
%--------------------------------------------------------------------------
% This function takes a NxN matrix adj as adjacency of a graph and 
% computes its Laplacian matrix.
% CKSym: NxN adjacency matrix

%--------------------------------------------------------------------------
% Matrices concluded by Hua-Wei Shen and Xue-Qi Cheng in the paper //Spectral
% methods for the detection of network community structure: a comparative
% analysis//

% Modified version of SpectralClustering written by Lin Xin
%--------------------------------------------------------------------------

if norm(adj-adj')~=0
    adj=normc(adj);
    adj=(adj+adj');
end%make the matrix symetric;
adj=adj-diag(diag(adj));%make the diagonal=0

N = size(adj,1);

if nargin==1
    option=1;
end

switch option
    case 1
        % Method 1: Random Walk Method - Normalized Laplacian matrix
        DKN=( diag( sum(adj+eps) ) )^(-1);
        Lap = speye(N) - DKN * adj;
        
        [~, evals] = eig( Lap );
        evals=diag(evals);
        
        evals = sort(evals);
        [~, ind] = max(diff(evals(2:end)));
        n = ind+1;
        
    case 2
        % Method 2: Normalized Symmetric for Similarity matrix
        DKS = ( diag( sum(adj)+eps ) )^(-1/2);
        Lap  = speye(N) - DKS * adj * DKS;
        [~,evals] = eig(Lap );
        evals=diag(evals);
        evals=sort(evals);
        [~, ind] = max(diff(evals(2:end)));
        n = ind + 1;
             
    case 3
        N = size(adj,1);
        DKS = ( diag( sum(adj)+eps ) )^(-1/2);
        Lap  = speye(N) - DKS * adj * DKS;
        
        [~,sKS,~] = svd(Lap );
        svals = diag(sKS);
        [ ~ , ind_min ] = min( diff( svals(1:end-1) ) ) ;  
        n = N-ind_min ;
        
    case 4
        % Method 4: Standard Laplacian matrix
        DKU = diag( sum(adj) );
        Lap  = DKU - adj;
        
        [~,evals] = eig(Lap );
        
        evals = diag(evals);
        std_evals=log(evals);
        [ ~ , max_ind ] = max( diff( std_evals(2:end)) )  ;  
        n=max_ind + 1;

    case 5
        % Method 5: Adjacency matrix
        [~,evals] = eig(adj );
        evals = diag(evals);
        
        [ ~ , max_ind ] = max( diff( evals(2:end) ) ) ;  
        n= N - max_ind + 1;
end 