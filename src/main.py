from argparse import ArgumentParser, ArgumentDefaultsHelpFormatter
from libs.struc2vec import struc2vec
from libs.struc2vec import graph

def parse_args():
    parser = ArgumentParser(formatter_class=ArgumentDefaultsHelpFormatter,
                            conflict_handler='resolve')
    parser.add_argument('--method', required=True, choices=['node2vec', 'deepwalk', 'line', 'struc2vec', 'graphwave'],
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

    args = parser.parse_args()
    return args


def main(args):
    if args.method == 'struc2vec':
        struc2vec.exec_struc2vec(args)
    elif args.method == 'node2vec':
        print "node2vec is comming soon..."
    elif args.method == 'deepwalk':
        print "deepwalk is comming soon..."
    elif args.method == 'line':
        print "line is comming soon..."
    elif args.method == 'graphwave':
        print "grapgwave is comming soon..."


if __name__ == "__main__":
    args = parse_args()
    main(args)
