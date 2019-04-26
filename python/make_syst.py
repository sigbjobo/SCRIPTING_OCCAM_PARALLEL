import numpy as np
import sys
def isfloat(value):
  try:
    float(value)
    return True
  except ValueError:
    return False


  
#Loading the fort.5 of a single molecule
lines     = open(sys.argv[1],'r').readlines()
n_solute  = int(sys.argv[2])
n_solvent = int(sys.argv[3])
L         = float(sys.argv[4])
print( "filename:",sys.argv[1])
print( "Number of solute molecules:",n_solute)
print( "Number of solvent molecules:", n_solvent)
print( "Size of box:", L,"nm")



#Total number of molecules
n_mols=n_solute+n_solvent


#Making random starting positions
r=np.zeros((n_mols,3))
M=int(n_mols**(1./3))
k=0
for x in range(M):
    for y in range(M):
        for z in range(M):
            r[k]=[(0.5+x)/M,(0.5+y)/M,(0.5+z)/M]
            k=k+1

r[k:,:]=np.random.random((len(r[k:,0]),3))
ind=np.arange(len(r))
np.random.shuffle(ind)
r=r[ind]
r=r*L




#Extracting number of atoms in solute
n_atoms=int(lines[0])
print( "Number of atoms in a solute molecule:", n_atoms)

data=[]
for i in range(n_atoms):
    data.append(lines[1+i].split())



lines_out=[]
#New fort.5
fp=open('fort_new.5','w')
lines_out.append('box:')
lines_out.append('%f %f %f'%(L,L,L))
lines_out.append('0')
lines_out.append('molecules_total_number:')
lines_out.append('%d'%(n_mols))


max_type=0
for i in range(n_solute):
    lines_out.append("atoms in molecule: %d"%(i+1))
    lines_out.append("%d"%(n_atoms))
    for j in range(n_atoms):
        
        pos=np.array([float(m.replace('D','E')) for m in data[j][4:7]])
        pos=pos+r[i]
        for m in range(len(pos)):
          if(pos[m]<0.0):
            pos[m]=pos[m]+L
          elif(pos[m]>L):
            pos[m]=pos[m]-L
        
        
      #  if(isfloat(data[j][7].replace('D','E'))):
      #    connec=np.array([int(m) for m in data[j][10:]])
      #  else:
        connec=np.array([int(m) for m in data[j][7:]])
        connec[connec>0]=connec[connec>0]+n_atoms*i
        

        
        if(max_type<int(data[j][2])):
          max_type=int(data[j][2])
        
        l=[]
        # atom_id
        l.append("%d"%(int(data[j][0])+i*n_atoms))
        # atom_label 
        l.append("%s"%(data[j][1]))
        # atom_type
        l.append("%s"%(data[j][2]))
        # atom_bonds
        l.append("%s"%(data[j][3]))
        # x_pos
        l.append("%f"%(pos[0]))
        # y_pos
        l.append("%f"%(pos[1]))
        # z_pos
        l.append("%f"%(pos[2]))
        
        l.append("0")
        l.append("0")
        l.append("0")

        # connectivity
        for k in range(len(connec)):
            l.append("%d"%(connec[k]))
        lines_out.append(" ".join(l))


solvent_type=max_type+1 
for i in range(n_solute,n_mols):
  lines_out.append("atoms in molecule: %d"%(i+1))
  lines_out.append("%d"%(1))
  l=[]
  # atom_id 
  l.append("%d"%(i+(n_atoms-1)*n_solute+1))
  # atom_label 
  l.append("W")
  # atom_type
  l.append("%d"%(solvent_type))
  # atom_bonds
  l.append("0")
  # x_pos
  l.append("%f"%(r[i][0]))
  # y_pos
  l.append("%f"%(r[i][1]))
  # z_pos
  l.append("%f"%(r[i][2]))

  l.append("0")
  l.append("0")
  l.append("0")

  # connectivity
  for k in range(len(connec)):
    l.append("0")
  lines_out.append(" ".join(l))


fp_out=open('fort_new.5','w')
for l in lines_out:
    fp_out.write("%s\n"%l)
