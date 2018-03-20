# -*- coding: utf-8 -*-
"""
Created on Mon Feb 26 17:21:13 2018

@author: Deborah
"""

import pandas as pd
import numpy as np
import sys, getopt

argv=sys.argv[1:]
Input=''
directory=''
try:
    opts, args = getopt.getopt(argv,"hn:d:",["nametag=","directory="])
except getopt.GetoptError:
  print('post_process_BOLT.py -n <name>')
  sys.exit(2)
for opt, arg in opts:
    if opt == '-h':
        print('post_process_BOLT.py -n <name>')
        sys.exit()
    elif opt in ("-n", "--nametag"):
        Input = arg
    elif opt in ("-d", "--directory"):
        directory = arg


print(Input)
df1=pd.read_csv(Input,sep='\t')

thr = 10**(-10)
df1 = df1[df1['mtag_pval']<thr]
df1.sort_values(by='mtag_pval',inplace=True)

#### keep top snp in each loci
chrs = list(set(df1['chr']))
df2 = pd.DataFrame(columns=df1.columns.tolist())
for chrom in chrs:
    sub = df1[df1['chr']==chrom]
    sub.sort_values(by='mtag_pval',inplace=True)
    dist = [float(abs(x-y)) for (x,y) in zip(sub['bpos'][:-1],sub['bpos'][1::])]
    dist.insert(0,10000)
    sub['dist'] =  pd.Series(dist, index=sub.index)
    #Loci = [x>5000 for x in dist]
#    for i in range(len(sub)):
#        bp_0 = sub['bpos'].iloc[i]
#        loci = [x<bp_0-5000 or x>bp_0+5000 for x in sub['bpos']]
#        loci[i]=True
#    Loci = [min(x,y) for (x,y) in zip(Loci,loci)]
    sub1=sub[sub.eval('dist > 5000')]
    df2=pd.concat([df2,sub1])
    
df2.sort_values(by='mtag_pval',inplace=True)
newfile=str(directory)+'mtag_res_'+Input[-11:-4]+'.csv'
print(newfile)

df2.to_csv(newfile,sep=',',index=None)
