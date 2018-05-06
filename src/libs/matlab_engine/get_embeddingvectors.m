function [embs,para]=get_embeddingvectors(input1,input2,datatype,method,para,output)
%The main step of GNE
%-------------------------Input--------------------------
%input1 -data: an N*D matrix, rows of data are observations. The first column might be IDs.
%input2 -grid: an array, the spatial units ID, which could be 0, empty or a file path.
%data type:an string
%          'od':the orientation-destination-value, 
%          'tf':the visit frequency of each spatial units
%method: a string, the chosed embedding algorithm
%       <method: name - parameters>
%       'pca'(default): Principle Component Analysis - d
%       'mds': Multiple Dimensional Scaling - d, distance, criterion
%       'sc':  Spectral Clustering - d(not necessary), Laplacian Matrix type
%       'svd_sc': Spectral Clustering based on SVD - d(not necessary)
%       'ssc': Sparse Subspace Clustering - d(not necessary)
%       'isomap': ISOMAP - d, k, distance
%       'lle': Linear Locally Embedding - d, k
%       'le': Laplacian Embedding - d, k, gaussian sigma
%       'tsne': t-SNE - d, initial_dims, perplexity
%parameters: a struct of method parameters.
%           dimensions: an integer, embedded dimension, d=3(default)
%           window_size: an integer, the neighbourhood size, k=50(default)
%           distance: -a string, 'Euclidean'(default),'seuclidean' or 'cosine' 
%                     -a distance matrix: In the matrix, the larger the
%                     value is, more dissimilar the samples are.
%           crtierion: MDS criterion, 'stress' or 'sstress'(default)
%           lapmat:an integer referring to the Laplacian Matrix type concluded in the paper
%                  //Spectral methods for the detection of network community structure: a comparative analysis//
%                  1: The normalized Laplacian matrix and the correlation matrix significantly
%                  outperform the other three matrices(the adjacency matrix, the modularity
%                  matrix and the standard laplacian matrix)
%                  2: The correlation matrix is similar to the normalized symmetric matrix, so
%                  we do not display the codes for the correlation matrix.
%                  3(default): The key point is that the index of the largest eigengap stands for
%                  the number of clusters(the eigengap heuristic)
%           sigma:gausin sigma used in Lalapcian Eigen, default=1
%           initial_dims: in t-SNE, the data is preprocessed using PCA, reducing the dimensionality to initial_dims 
%                         dimensions (default = 30)
%           perplexity: an interger, the perplexity of the Gaussian kernel that is employed 
%                       can be specified through perplexity (default = 30).
%output: the output file path
%-------------------------Output--------------------------
%embs: an N*(d+1) matrix, each row is an embedding vector and the first
%      column refers to the grid.
%-------------------------Example--------------------------
%load('sampledata/taxi_tf.mat')
%tf=data.tf;
%grid=data.grid;
%datatype='tf';
%method='isomap';
%parameter.d=5;
%parameter.k=50;
%parameter.distance='Euclidean';
%output='D:/data_embeddingvectors.emb'
%embs=get_embeddingvectors(tf,grid,datatype,method,parameter);


%embs=get_embeddingvectors(data,grid,datatype,method,parameters)

data=xlsread(input1);
if ~exist('input2','var')
    disp('auto-assign the object ID')
    grid=1:size(data,1);
end

if exist('input2','var') && ~strcmp(input2,'')
    grid=xlsread(input2);
else
    if input==1
        grid=data(:,1);
        data=grid(:,2:end);
    end
end

if ~exist('datatype','var')
    error('Please input the datatype')
end
datatype=lower(datatype);

if ~exist('method','var')
    method='pca';
end

if exist('datatype','var') && strcmpi(datatype,'od')
    if size(data,2)==3
		tempdata=sparse(data(:,1),data(:,2),data(:,3));
		tempdata=full(tempdata);
		data=tempdata;
	end
    if size(data,2)==2
		temp=ones(size(data,1),1);
		tempdata=sparse(data(:,1),data(:,2),temp);
		tempdata=full(tempdata);
		data=tempdata;
	end
clear tempdata temp
end

if ~exist('parameters','var')
    para.dimensions=3;
end

if ~isfield(para,'dimensions') && isempty(strfind('sc ssc svd_sc', method))
    para.dimensions=3;
end

if ~isfield(para,'window_size') && ~isempty(strfind('isomap lle le tsne', method))
    para.window_size=30;
end

if ~isfield(para,'distance') && ~isempty(strfind('isomap mds', method))
    para.distance='Euclidean';
end

if ~isfield(para,'Criterion') && strcmp('mds', method)
    para.Criterion='sstress';
end

%change the variables and charaters to be lower
method=lower(method);
tempfields=fieldnames(para);
for i=1:length(tempfields)
    tempval{i}=getfield(para,tempfields{i});
    if ischar(tempval{i})
        tempval{i}=lower(tempval{i});
    end
    eval(['temppara.',lower(tempfields{i}),'=tempval{i};'])
end
para=temppara;
clear temppara i tempfields tempval

disp(['Embedding algorithm: ',method])
disp('Embedding...')

switch method
    case 'pca' 
        [~,score]=pca(data);
        embs=score(:,1:para.dimensions);
    
    case 'mds'
		if ischar(para.distance)
        tempD=squareform(pdist(data,para.distance));
        embs=mdscale(tempD,para.dimensions,'Criterion','sstress');
		else
		embs=mdscale(para.distance,para.dimensions,'Criterion','sstress');
		end
    
    case 'sc'
        if ~isfield(para,'metric') && strcmp(datatype,'tf')
            para.metric='cosine';
        end
        if ~strcmp(datatype,'od')
            if ~isfield(para,'rg')
                rg=get_relationgraph(input1,input2,[],para.metric);
            else
                temprg=csvread(para.rg);
            end
		else
			temprg=data;
        end
        if exist('temprg','var') 
            if size(temprg,2)==3
                newrg=full(sparse(temprg(:,1),temprg(:,2),temprg(:,3)));
                newrg=newrg+newrg.';
                newrg(newrg<0)=0;
                rg=newrg(any(newrg,1),any(newrg,2));
            else
                rg=temprg;
            end
        end
        
        if ~isfield(para,'lapmat')
            para.lapmat=3;
        end
        [n, group, vKS,kerKS]=SpectralClustering(rg, para.lapmat);
        if isfield(para,'dimensions')
            embs=vKS(:,(end-para.dimensions+1):end);
        else
            embs=kerKS;
        end
        
    case 'svd_sc'       
        [w, n, vKS,kerKS, c, group]=svd_sc(data');
        if isfield(para,'dimensions')
            embs=vKS(:,(end-para.dimensions+1):end);
        else
            embs=kerKS;
        end
        
    case 'ssc'
        [w, n, vKS, kerKS, c, group]=SSC(data');
        if isfield(para,'dimensions')
            embs=vKS(:,(end-para.dimensions+1):end);
        else
            embs=kerKS;
        end           
        
    case 'isomap'
        tempD=squareform(pdist(data,para.distance));
        tempoptions.dims=para.dimensions;
        tempoptions.display=0;
        [tempY, ~, ~] = Isomap(tempD,'k', para.window_size, tempoptions); 
        embs=tempY.coords{1,1}';
        
    case 'lle'
        disp('Embedding...') 
        embs=lle(data',para.window_size,para.dimensions)';
        
    case 'le'
        if ~isfield(para,'sigma')
            para.sigma=1;
        end
        [embs, ~] = laplacian_eigen(data, para.dimensions, para.window_size, para.sigma);
        
    case 'tsne'
        if ~isfield(para, 'initial_dims')
            [~,~,~,~,explained]=pca(data);
            for i=1:length(explained)
                if sum(explained(1:i))>0.95
                    para.initial_dims=i;
                    break
                end
            end
        end
        if ~isfield(para, 'perplexity')
            para.perplexity=30;
        end
        embs=tsne(data,[],para.dimensions, para.initial_dims, para.perplexity);
end

para.method=method;

disp('Embedding is done')
disp('The algorithm parameters is')
disp(para)

embs=[grid embs];
if exist('output','var')
    disp('writing the emb file')
    csvwrite(output,embs)
end
end