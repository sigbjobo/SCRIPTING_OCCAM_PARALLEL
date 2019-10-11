# Code for fixing the the cell vectors such that they give around 0.67

import numpy as np
import sys

#Standard choice
b=0.67
if(len(sys.argv)>1):
    b=float(sys.argv[1])
print("Desired cell length: %.3f",b)

fp=open('fort.5')
fp.readline()
L=[float(l) for l in fp.readline().split()]
fp.close()

lines=open('fort.3','r').readlines()
i=0
ierr=0
while(1):
    if(i>len(lines)):
        ierr=1
        break
    
    try:
        l=lines[i].split()
        if('SCF' in l):
            M=[np.around(li/b) for li in L]
            lines[i+2]='%d %d %d\n'%(M[0],M[1],M[2])
            break
    except:
        pass
    i=i+1

#Change fort.3
fp.close()
if(ierr==1):
    print('ERROR: Cell vectors not found')
else:
    open('fort.3','w').writelines(lines)
