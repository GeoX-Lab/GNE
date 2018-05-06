from argparse import ArgumentParser, ArgumentDefaultsHelpFormatter
from libs.struc2vec import struc2vec
from libs.node2vec import node2vec #node2vec
from libs.graphwave import graphwave
from libs.struc2vec import graph
from libs.matlab_engine import matlab_engine
import networkx as nx #node2vec
import os

def parse_args():
    parser = ArgumentParser(formatter_class=ArgumentDefaultsHelpFormatter,
                            conflict_handler='resolve')
    parser.add_argument('--method', required=True, choices=['node2vec', 'deepwalk', 'line', 'struc2vec', 'graphwave','poincare','pca','mds','sc','ssc','svd_sc','isomap','lle','le','tsne'],
                        help='The learning method')

    # struc2vec
    parser.add_argument('--input', nargs='?', default='../data/barbell.edgelist',
                        help='Input graph path')

    parser.add_argument('--output', nargs='?', default='../data/result/barbell.emb',
                        help='Embeddings path')
    parser.add_argument('--dimensions', type=int, default=128,
	                    help='Number of dimensions. Default is 128.')

    parser.add_argument('--walk-length', type=int, default=80,
	                    help='Length of walk per source. Default is 80.')

    parser.add_argument('--num-walks', type=int, default=10,
	                    help='Number of walks per source. Default is 10.')

    parser.add_argument('--window-size', type=int, default=10,
                    	help='Context size for optimization. Default is 10.')

    parser.add_argument('--until-layer', type=int, default=None,
                    	help='Calculation until the layer.')

    parser.add_argument('--iter', default=5, type=int,
                      help='Number of epochs in SGD')

    parser.add_argument('--workers', type=int, default=4,
	                    help='Number of parallel workers. Default is 8.')

    parser.add_argument('--weighted', dest='weighted', action='store_true',
	                    help='Boolean specifying (un)weighted. Default is unweighted.')
    parser.add_argument('--unweighted', dest='unweighted', action='store_false')
    parser.set_defaults(weighted=False)

    parser.add_argument('--directed', dest='directed', action='store_true',
	                    help='Graph is (un)directed. Default is undirected.')
    parser.add_argument('--undirected', dest='undirected', action='store_false')
    parser.set_defaults(directed=False)

    parser.add_argument('--OPT1', default=False, type=bool,
                      help='optimization 1')
    parser.add_argument('--OPT2', default=False, type=bool,
                      help='optimization 2')
    parser.add_argument('--OPT3', default=False, type=bool,
                      help='optimization 3')
    # struc2vec

    #node2vec added
    parser.add_argument('--p', type=float, default=0.04,
                        help='Return hyperparameter. Default is 0.04.')

    parser.add_argument('--q', type=float, default=1,
                        help='Inout hyperparameter. Default is 1.')
    # node2vec ended

    #matlab added
    parser.add_argument('--input1',nargs='?',default='',
                        help='Input data path')
    parser.add_argument('--input2',nargs='?',default='',
                        help='0 or grid path. If the grid ID (objects ID) is contained in the data, input2=0. Otherwise, input2=file path')
    parser.add_argument('--datatype',nargs='?',default='tf',
                        help="'tf': Time-feature matrix\
                        'od': Origin-Destination matrix")
    parser.add_argument('--distance',nargs='?',default='euclidean',
                        help="'euclidean'(default): Euclidean distance\
                        'seuclidean': Standardized Euclidean distance\
                        'cosine': One minus the cosine of the included angle between points\
                        (treated as vectors)")
    parser.add_argument('--criterion',nargs='?',default='sstress',
                        help="The goodness-of-fit criterion to minimize.\
                         This also determines the type of scaling, either\
                          non-metric or metric, that mdscale performs. Choices\
                           for non-metric scaling are\
                           'stress' - Stress normalized by the sum of squares of the inter-point distances, also known as stress1.\
                           'sstress' - Squared stress, normalized with the sum of 4th powers of the inter-point distances.(default)"
                           )
    parser.add_argument('--metric',nargs='?',default='gaussiankernel',
                        help="The metric used to form a relation graph for TF matrix\
                         'cosine': the cosine of the included angle between points (treated as vectors)\
                         'sr': Sparse Representation\
                         'gaussiankernel'(default): Gaussian Kernel Function")
    parser.add_argument('--rg',nargs='?',default='',
                        help='The file path of Relation Graph for TF matrix.')
    parser.add_argument('--lapmat',type=int,default='3',
                        help="an integer referring to the Laplacian Matrix type concluded in the paper//Spectral methods for the detection of network community structure: a comparative analysis//\
                            1: The normalized Laplacian matrix and the correlation matrix significantly outperform the other three matrices(the adjacency matrix, the modularity matrix and the standard laplacian matrix)\
                            2: The correlation matrix is similar to the normalized symmetric matrix, so we do not display the codes for the correlation matrix.\
                            3(default): The key point is that the index of the largest eigengap stands for the number of clusters(the eigengap heuristic)")
    parser.add_argument('--sigma',type=float,default=1,
                        help='gausin sigma used in Lalapcian Eigen, default=1')
    parser.add_argument('--initial-dims',type=int,
                        help="in t-SNE, the data is preprocessed using PCA, reducing the dimensionality to initial_dims dimensions")
    parser.add_argument('--perplexity',type=int,default=30,
                        help='the perplexity of the Gaussian kernel that is employed. (default = 30)')
    #matlab ended

    args = parser.parse_args()
    return args


def main(args):
    if args.method == 'struc2vec':
        struc2vec.exec_struc2vec(args)
    elif args.method == 'node2vec':
        node2vec.exec_node2vec(args)
    elif args.method == 'deepwalk':
        print "deepwalk is comming soon..."
    elif args.method == 'line':
        print "line is comming soon..."
    elif args.method == 'graphwave':
        graphwave.exec_graphwave(args.input,args.output,args.dimensions,args.weighted)
    elif args.method in ('pca','mds','sc','ssc','svd_sc','isomap','lle','le','tsne'):
        print os.getcwd()
        os.chdir('.\\src\\libs\\matlab_engine\\')
        print os.getcwd()
        matlab_engine.exec_matlab(args)


if __name__ == "__main__":
    args = parse_args()
    main(args)
