# -*- coding: utf-8 -*-
"""
Created on Tue May 01 13:34:14 2018
For comprehensive experiments of embedding algorithms with urban sensing data
@author: OK
"""

import matlab.engine
#import sys  
#reload(sys)  
#sys.setdefaultencoding('utf8')
def exec_matlab(args):
    eng = matlab.engine.start_matlab('MATLAB_R2016b')

    eng.addpath(eng.genpath('matlabcodes\\'))

    #get embedding vectors
    print "input1='%s';"%(args.input1)
    eng.eval("input1='%s';"%(args.input1),nargout=0) #file path
    print "input2='%s';"%(args.input2)
    eng.eval("input2='%s';"%(args.input2),nargout=0) #file path
    eng.eval("data=xlsread(input1);",nargout=0) 
    eng.eval("grid=xlsread(input2);",nargout=0)
    print "datatype='%s';"%(args.datatype)
    eng.eval("datatype='%s';"%(args.datatype),nargout=0) #tf or od
    print "method='%s';"%(args.method)
    eng.eval("method='%s';"%(args.method),nargout=0)
    print "para.dimensions=%d;"%(args.dimensions)
    eng.eval("para.dimensions=%d;"%(args.dimensions),nargout=0)
    eng.eval("para.window_size=%d;"%(args.window_size),nargout=0)
    eng.eval("para.distance='%s';"%(args.distance),nargout=0)
    eng.eval("para.sigma=%d;"%(args.sigma),nargout=0)
    if type(args.initial_dims) == int:
        eng.eval("para.initial_dims=%d;"%(args.initial_dims),nargout=0)
    eng.eval("para.perplexity=%d;"%(args.perplexity),nargout=0)
    eng.eval("para.criterion='%s';"%(args.criterion),nargout=0)
    eng.eval("para.metric='%s';"%(args.metric),nargout=0)
    eng.eval("para.rg='%s';"%(args.rg),nargout=0)
    eng.eval("para.lapmat='%s';"%(args.lapmat),nargout=0)
    print "output_embs='%s';"%(args.output)
    eng.eval("output_embs='%s';"%(args.output),nargout=0)#set the path of output
    eng.eval("embs=get_embeddingvectors(input1,input2,datatype,method,para,output_embs);",nargout=0)
    return
    '''#doing clustering
    eng.eval("n=6",nargout=0)
    eng.eval("output_grps='E:\\result\\data_grps'",nargout=0)
    eng.eval("clusters=get_cluster(embs(:,2:end),grid,n,output_grps);",nargout=0)
    #evaluate the clustering results
    eng.eval("output_evas='E:\\result\\data_clustereval.csv';",nargout=0)#set the path of output
    eng.eval("evas=get_clustereval(data,clusters,output_evas)",nargout=0)
    # get the POI vectors in the region
    eng.eval("poitab=readtable('poitab.csv');",nargout=0) #file path
    eng.eval("output_regionpoi='E:\\result\\data_regionpoi.csv';",nargout=0)#set the path of output
    eng.eval("output_poi='E:\\result\\data_poi.csv';",nargout=0)#set the path of output
    eng.eval("[regionpoi,vclust]=get_poi_region(poitab,clusters,grid,output_poi);",nargout=0)
    # if the data is time-feature type, conduct function annotation of each region
    eng.eval("sepvis=funcannot(data,clusters)",nargout=0)
    '''
