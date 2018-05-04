import networkx as nx 
import pandas as pd
import sys
if sys.getdefaultencoding() != 'gbk':
    reload(sys)
    sys.setdefaultencoding('gbk')
import matplotlib.pyplot as plt
import sklearn as sk
import seaborn as sb
import datetime
from sklearn.decomposition import PCA
from sklearn.preprocessing import StandardScaler



from heat_diffusion import *

from characteristic_functions import *
import pygsp
import numpy as np
import networkx as nx 
from heat_diffusion import *
from characteristic_functions import *

def exec_graphwave(input,output,dime,isweighted):
    Starttime = datetime.datetime.now()
    print "Start Running Graphwave~~"+str(Starttime)
    MyGragh = getGragh(input,isweighted)
    outputEmbFile(MyGragh,output,dime)
    print "Completint Graphwave embding~~" + str(datetime.datetime.now())

def getGragh(url,isweighted):
    file = open(url,"r")
    G = nx.Graph()
    for line in file:
        newlien = line.split(" ")
        if isweighted == False:
            G.add_edge(newlien[0], newlien[1])
        elif isweighted == True:
            G.add_edge(newlien[0], newlien[1], weight=int(newlien[2]))

    file.close()
    return G
# output Embiding file
def outputEmbFile(Gragh,url,dime):
    inputfile = open(url, 'w+')
    nodes = Gragh.number_of_nodes()
    inputfile.write(str(nodes)+" "+ str(dime)+'\n')
    t = []
    nodename=list(Gragh.nodes())
    for i in range(int(dime)):
        t.append(i*nodes/int(dime))
    chi, heat_print, taus = graphwave(Gragh, t, verbose=False)
    pca = PCA(n_components=int(dime))
    data = pca.fit_transform(StandardScaler().fit_transform(chi))

    for i in range(len(data)):
        datada = str(nodename[i])
        for j in range(len(data[i])):
            datada = datada+" "+str(data[i][j])
        inputfile.write(datada+'\n')
    inputfile.close()

def graphwave(G, taus, t=range(0,100,2), type_graph="nx",verbose=False,**kwargs):
    ''' wrapper function for computing the structural signatures using GraphWave
    INPUT
    --------------------------------------------------------------------------------------
    G          :  nx or pygsp Graph 
    taus       :  list of scales that we are interested in. Alternatively, 'automatic'
	               for the automatic version of GraphWave
	type_graph :   type of the graph used (either one of 'nx' or 'pygsp')
    verbose    :   the algorithm prints some of the hidden parameters as it goes along
    OUTPUT
    --------------------------------------------------------------------------------------
    chi        :  embedding of the function in Euclidean space
    heat_print :  returns the actual embeddings of the ndoes
    taus       :  returns the list of scales used.
    '''
    if type(taus)==str:
        taus=[0.5,0.7,0.8,0.9,1.0,1.1,1.3,1.5,1.7,1.9,2.0,2.1,2.3,2.5,2.7]+range(3,5)
        #### Compute the optimal embedding
        Gg=pygsp.graphs.Graph(nx.adjacency_matrix(G),lap_type='normalized')
        Gg.compute_fourier_basis(recompute=True)
        l1=np.where(Gg.e>0.1/Gg.N) ### safety check to ensure that the graph is indeed connected
        l1=Gg.e[l1[0][0]]
        smax=-np.log(0.90)*np.sqrt(Gg.e[-1]/l1)
        smin=-np.log(0.99)*np.sqrt(Gg.e[-1]/l1)
        if np.sum(taus>smax)>0:
            smax=np.where(taus>smax)[0][0]
        else:
            smax=len(taus)
        if np.sum(taus<smin)>0:
            smin=np.where(taus<smin)[0][-1]
        else:
            smin=0
        if verbose: print "smax=",smax, " and smin=", smin
        taus=taus[smin:smax]
    ### Compute the heat wavelets
    heat_print=heat_diffusion(G,taus,diff_type="immediate",type_graph=type_graph)
    chi=featurize_characteristic_function(heat_print,t)
    return chi,heat_print, taus


