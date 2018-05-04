# GNE: A toolkit for Network Embedding

This repository provides some methods for network embedding.Including node2vec,deepwalk,line,struc2vec,graphwave.


## Requirements

```
pip install ***
```

* futures
* fastdtw
* gensim
* networkx
* pandas
* pygsp
* pyemd
* sklearn
* seaborn
* scipy

## Basic Usage

### General Options

You can check out all options by using:

```
python src/main.py --help
```

* -h, --help    <br>        show this help message and exit
* --method<br> {node2vec,deepWalk,line,struc2vec,graphwave}
                        The learning method (default: None)
* --input [INPUT]  <br>     Input graph path
*  --output [OUTPUT]   <br>  Embeddings path
* --dimensions DIMENSIONS
                        <br>Number of dimensions. Default is 128. (default: 128)
* --walk-length WALK_LENGTH<br>
                        Length of walk per source. Default is 80. (default:
                        80)
* --num-walks NUM_WALKS<br>
                        Number of walks per source. Default is 10. (default:
                        10)
* --window-size WINDOW_SIZE<br>
                        Context size for optimization. Default is 10.
                        (default: 10)
* --until-layer UNTIL_LAYER<br>
                        Calculation until the layer. (default: None)
* --iter ITER           <br>Number of epochs in SGD (default: 5)
* --workers WORKERS     <br>Number of parallel workers. Default is 8. (default: 4)
* --weighted Boolean<br> specifying (un)weighted. Default is unweighted. (default: False)
* --unweighted
* --directed<br>            Graph is (un)directed. Default undirected.
                        (default: False)
* --undirected
* --OPT1 Boolean   <br>        optimization 1 (default: False)
* --OPT2 Boolean   <br>        optimization 2 (default: False)
* --OPT3 Boolean   <br>        optimization 3 (default: False)
* --p   <br>    Return hyperparameter. Default is 1.
* --q   <br>    Inout hyperparameter. Default is 1.


### Example

To run "struc2vec" on some network, please using the following command in the home directory of this project:

```
python src/main.py --method struc2vec --input inputFile.edgelist --output outputFile.emb
```

### input

The support input format is an edgelist:
```
nodeX_int_id nodeY_int_id
```

### output

The output file has n+1 lines for a graph with n vertices. The first line has the following format:

```
num_of_nodes dim_of_representation
```

The next n lines are as follows:

```
nodeX_id dim1 dim2 dim3 ... dimd
```

dim1 ... dimd is the d-dimensional representation