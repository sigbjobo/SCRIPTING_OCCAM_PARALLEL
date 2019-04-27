#SCRIPT FOR MAKING A FORT.9 FILE OUT OF FORT.4**-5***

import glob
import numpy as np
#READ START FILE
fort5_lines = open('fort.5').readlines()
L=[float(li.replace('D','E'))  for li in fort5_lines[1].split()]
#MAKE A COPY
fort9_lines  = fort5_lines[:]
fp_out=open('fort.9','w')

#INFORMATION ABOUT MOLECULES AND CPU
fort15_lines = open('fort.15')

#FILES CONTAINING THE FINAL CONFIGUARTION
final_configs = glob.glob('./fort.[4-5][0-9][0-9]')

#MAKE INDEX LIST FOR ATOMS in fort.5
index=[]
i=0
for i in range(len(fort5_lines)):
    ls = fort5_lines[i].split()
    if(len(ls) > 10):
        index.append(i)


for fn in final_configs:
    fp=open(fn)
    while(1):
        ls=fp.readline().split()
        if(len(ls)>0):
            if(len(ls)>10):
                
                atomid=int(ls[1])-1
                id_fort5=index[atomid]
 
                lfort5=fort5_lines[id_fort5].split()
                ls=ls[5:11]
                ls[:len(ls)//2]=['%f'%(np.mod(float(ls[i].replace('D','E')),L[i])) for i in range(3)]
                lfort5[4:10]=ls

                fort9_lines[id_fort5]='%s'%(' '.join(lfort5))
        else:
            break
       
    fp.close()
for l in fort9_lines:
    ls=l.split()
    fp_out.write('%s\n'%(' '.join(ls)))

fp_out.close()


