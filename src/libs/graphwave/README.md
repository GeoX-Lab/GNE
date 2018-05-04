
### Prerequisites

GraphWave was written for __Python 2.7__ and requires the installation of the following Python libraries:

+ __pygsp__: module for computing the wavelets (from the  [EPFL website](https://pygsp.readthedocs.io/en/stable/)  ). 
To install, simply run in your local terminal:
+ __networkx__: allows easy manipulation and plotting of graph objects (more information in the [Networkx website](https://networkx.github.io)).
+ __pyemd__: module for computing Earth Mover distances (for trying out other distances between diffusion distributions. More information in the [pyemd website](https://github.com/wmayner/pyemd))

Can install these using `pip install -r requirements.txt`

Also, need standard packages: __scipy, sklearn, seaborn__ for analyzing and plotting results


### Runinig GraphWave

+ intput :the filedirectory of networkx  edgelist
+ output :the filedirectory of emding file
+ dime : embedded dimension

An example for using GraphWave
   getGraphwave(input,output,dime,isweighted)
   input :"****/**.edgelist"
   output :"****/**/emb"
   dime : A number like 2,3 etc
   isweighted :A Boolean value (true or false)


## Acknowledgements

We would like to thank the authors of [struc2vec](https://arxiv.org/abs/1704.03165) for the [open access of the implementation of their method](https://github.com/leoribeiro/struc2vec), as well as [Lab41](http://lab41.github.io/blog/2014/12/18/rolx-discovering-individuals-roles-in-a-social-network/) for its open-access implementation of [RolX](https://dl.acm.org/citation.cfm?id=2339723).

## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details



=======
# graphwave
