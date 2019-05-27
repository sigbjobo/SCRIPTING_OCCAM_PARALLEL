import sys, os
import numpy as np

# THIS SCRIPTS COUNTS THE NUMBER OF ATOMS AND MOLECULES

# WARNING:
# WORKS ONLY FOR FORT.5 WITH PREDEFINED VELOCITIES
# AND MOLECULES PUT IN CONCEQUITIVE ORDER  


fp5 = open('fort.5', 'r')

# FIRST GET TO LINE 6
fp5.readline()
fp5.readline()
fp5.readline()
fp5.readline()
fp5.readline()


# ARRAY CONTAINING ALL THE MOLECULES
mols=[]

#LOOP FOR READING ALL MOLECULES
while(1):
    try:
        line5=fp5.readline()
        line5=fp5.readline()
        natoms = int(line5)
        labels=''
        for j in range(natoms):
            line5 = fp5.readline()
            labels = "%s%s"%(labels, line5.split()[2])  
        mols.append(labels)
    except:
        break
fp5.close()

#MOLECULES OF SAME LENGTH CAN BE GROUPED TOGETHER, THIS IS DONE HERE
mols      = np.array([len("%s"%(moli)) for moli in mols])
def f7(seq):
    seen = set()
    seen_add = seen.add
    return [x for x in seq if not (x in seen or seen_add(x))]
mols=np.array(mols)
mols_unique = f7(mols)
mols_unique = np.array(mols_unique)

nmols=[]
for i in range(len(mols_unique)):
    nmols.append(sum(mols_unique[i]==mols))
nmols=np.array(nmols)

NATOM=sum(nmols*mols_unique)
NMOL=sum(nmols)





# EXPORT VARIABLES TO SHELL FOR prep_iopc1.sh
fp=open('input.txt','a')
fp.write('%d\n'%(np.sum(NMOL)))
fp.write('%d\n'%(np.sum(NATOM)))
# os.environ['NATOM'] = "%d"%np.sum(NATOM)
# os.environ['NMOL']  = "%d"%np.sum(NMOL)



l="ABCDEFGHIJK"
mols_out  = np.zeros(len(l))
nmols_out = np.zeros(len(l))
mols_out[:len(mols_unique)]  = mols_unique
nmols_out[:len(nmols)] = nmols
mols_out=["%d"%(a) for a in mols_out]
nmols_out=["%d"%(a) for a in nmols_out]
for i in range(int(sys.argv[1])):
    # os.environ['NATOM%s'%(l[i])] =  mols_out[i]
    # os.environ['NMOL%s' %(l[i])] = nmols_out[i]
    fp.write('%d\n'%(int(nmols_out[i])))
    fp.write('%d\n'%(int(mols_out[i])))

