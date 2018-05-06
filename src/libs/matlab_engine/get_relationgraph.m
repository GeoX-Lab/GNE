function relation_graph=get_relationgraph(input1,input2,output,metric)
%-------------------------Input--------------------------
%input1 file path-data: an N*D matrix, rows of data are observations. The first column might be IDs.
%input2 file path-grid: an array, the spatial units ID, which could be 0, empty or a file path.
%output: file path of relation graph
%metric: an string, the method of computing the relation graph, such as Euclidean metric, cosine metric, sparse representation and so on.
%        'cosine': cosine metric
%        'sr': sparse representation
%        'gaussiankernel'(default): Gaussian Kernel Function
%-------------------------Output--------------------------
%relation_graph: N*3 matrix, object1-object2-relation

data=xlsread(input1);
if ~exist('input2','var')
    disp('auto-assign the object ID')
    grid=1:size(data,1);
end

if input2==0
    grid=data(:,1);
    data=grid(:,2:end);
else
    grid=xlsread(input2);
end

if ~exist('metric','var')
    metric='gaussiankernel';
end    

switch metric
	
	case 'cosine'
	tempRG=squareform(pdist(data,metric));
	tempRG=1-tempRG;
	
	case 'sr'
	X=normc(data');
	N=size(data,2);
	Z =zeros ( N, N) ;
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
	tempRG = abs( Z ) + abs( Z.' ) ;
	
	case 'gaussiankernel'
	perplexity=30;
	tempD=squareform(pdist(normr(data)));
	tempRG = d2p(tempD, perplexity, 1e-5);

end

tempRG=tempRG-diag(diag(tempRG));
tempRG(tempRG<eps)=0;

relation_graph=tempRG;

if ~isempty(output)
	if ~exist('input2','var')
		[i,j,v]=find(tempRG);
	else
		newRG=zeros(max(grid));
		newRG(grid,grid)=tempRG;
		[i,j,v]=find(newRG);
	end
	csvwrite(output,[i,j,v])
end

end

