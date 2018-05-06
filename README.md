# GNE: A toolkit for Network Embedding

This repository provides some methods for network embedding.Including node2vec, struc2vec, graphwave, pca, mds, sc, ssc, svd_sc, isomap, lle, le, tsne


## Requirements
#### 1.
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

#### 2.

install [**matlab engine for python**](http://ww2.mathworks.cn/help/matlab/matlab_external/install-the-matlab-engine-for-python.html)

## Basic Usage

### General Options

You can check out all details of parameters by using:

```
python src/main.py --help
```
### supported parameters

<table>
<thead>
<tr>
<th>struc2vec</th>
<th style="text-align:center">node2vec</th>
<th style="text-align:right">graphwave</th>
</tr>
</thead>
<tbody>
<tr>
<td>input</td>
<td style="text-align:center">input</td>
<td style="text-align:right">input</td>
</tr>
<tr>
<td>output</td>
<td style="text-align:center">output</td>
<td style="text-align:right">output</td>
</tr>
<tr>
<td>dimensions</td>
<td style="text-align:center">dimensions</td>
<td style="text-align:right">dimensions</td>
</tr>
<tr>
<td>walk-length</td>
<td style="text-align:center">walk-length</td>
<td style="text-align:right">weighted</td>
</tr>
<tr>
<td>num-walks</td>
<td style="text-align:center">num-walks</td>
<td style="text-align:right">unweighted</td>
</tr>
<tr>
<td>window-size</td>
<td style="text-align:center">window-size</td>
<td style="text-align:right"></td>
</tr>
<tr>
<td>until-layer</td>
<td style="text-align:center">iter</td>
<td style="text-align:right"></td>
</tr>
<tr>
<td>iter</td>
<td style="text-align:center">workers</td>
<td style="text-align:right"></td>
</tr>
<tr>
<td>workers</td>
<td style="text-align:center">p</td>
<td style="text-align:right"></td>
</tr>
<tr>
<td>weighted</td>
<td style="text-align:center">q</td>
<td style="text-align:right"></td>
</tr>
<tr>
<td>unweighted</td>
<td style="text-align:center"></td>
<td style="text-align:right"></td>
</tr>
<tr>
<td>directed</td>
<td style="text-align:center"></td>
<td style="text-align:right"></td>
</tr>
<tr>
<td>undirected</td>
<td style="text-align:center"></td>
<td style="text-align:right"></td>
</tr>
<tr>
<td>OPT1</td>
<td style="text-align:center"></td>
<td style="text-align:right"></td>
</tr>
<tr>
<td>OPT2</td>
<td style="text-align:center"></td>
<td style="text-align:right"></td>
</tr>
<tr>
<td>OPT3</td>
<td style="text-align:center"></td>
<td style="text-align:right"></td>
</tr>
</tbody>
</table>
<table>
<thead>
<tr>
<th>PCA</th>
<th style="text-align:center">MDS</th>
<th style="text-align:right">Spectral Clustering</th>
<th style="text-align:right">SSC</th>
<th style="text-align:right">svd_sc</th>
</tr>
</thead>
<tbody>
<tr>
<td>input1</td>
<td style="text-align:center">input1</td>
<td style="text-align:right">input1</td>
<td style="text-align:right">input1</td>
<td style="text-align:right">input1</td>
</tr>
<tr>
<td>input2</td>
<td style="text-align:center">input2</td>
<td style="text-align:right">input2</td>
<td style="text-align:right">input2</td>
<td style="text-align:right">input2</td>
</tr>
<tr>
<td>output</td>
<td style="text-align:center">output</td>
<td style="text-align:right">output</td>
<td style="text-align:right">output</td>
<td style="text-align:right">output</td>
</tr>
<tr>
<td>dimensions</td>
<td style="text-align:center">dimensions</td>
<td style="text-align:right">dimensions</td>
<td style="text-align:right">dimensions</td>
<td style="text-align:right">dimensions</td>
</tr>
<tr>
<td></td>
<td style="text-align:center">distance</td>
<td style="text-align:right">metric</td>
<td style="text-align:right"></td>
<td style="text-align:right"></td>
</tr>
<tr>
<td></td>
<td style="text-align:center">criterion</td>
<td style="text-align:right">lapmat</td>
<td style="text-align:right"></td>
<td style="text-align:right"></td>
</tr>
</tbody>
</table>
<table>
<thead>
<tr>
<th>ISOMAP</th>
<th style="text-align:center">LLE</th>
<th style="text-align:right">LE</th>
<th style="text-align:right">tsne</th>
</tr>
</thead>
<tbody>
<tr>
<td>input1</td>
<td style="text-align:center">input1</td>
<td style="text-align:right">input1</td>
<td style="text-align:right">input1</td>
</tr>
<tr>
<td>input2</td>
<td style="text-align:center">input2</td>
<td style="text-align:right">input2</td>
<td style="text-align:right">input2</td>
</tr>
<tr>
<td>output</td>
<td style="text-align:center">output</td>
<td style="text-align:right">output</td>
<td style="text-align:right">output</td>
</tr>
<tr>
<td>dimensions</td>
<td style="text-align:center">dimensions</td>
<td style="text-align:right">dimensions</td>
<td style="text-align:right">dimensions</td>
</tr>
<tr>
<td>window-size</td>
<td style="text-align:center">window-size</td>
<td style="text-align:right">window-size</td>
<td style="text-align:right">initial_dims</td>
</tr>
<tr>
<td>distance</td>
<td style="text-align:center"></td>
<td style="text-align:right">sigma</td>
<td style="text-align:right">perplexity</td>
</tr>
</tbody>
</table>




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
or
```
nodeX_int_id nodeY_int_id weight_float
```

### input1
...
### input2
...

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

## citing
...