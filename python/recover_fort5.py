import sys
import numpy as np

#Read all positions
def read_frame(fp):
    r=[]
    L=[]
    try:
        line = fp.readline()
        nAtoms=int(line)
    
        L=np.array([float(d) for d in fp.readline().split()[1:]])
        for i in range(nAtoms):
            l = fp.readline().split()
            d = [float(d) for d in l[1:]]
            r.append(d)
        return [fp, np.squeeze(r), L, 1]
    except:
        return [fp, np.squeeze(r), L, 0]

            
#Files for storing data
lines5 = open('fort.5', 'r').readlines()
fp8    = open('fort.8', 'r')
fp_rec = open('fort_recover.5', 'w')

#Time between frames
dt     = float(sys.argv[1])
print('time_between_frames: %f ps'%(dt))

#Check if your fort.5 has velocities or not
if(len(lines5[1].split())==3):
    #Has velocties
    vel_prior=1    
else:
    #Does not have velocties
    vel_prior=0
    lines5[1]=' '.join(lines5[2].split[1:])
    lines5.insert(2,'0.0')

#Finding positions of last frame
read = 1
r=1
while(read):
    r1=r+1
    [fp,r,L,read] = read_frame(fp8)
    if(read):
        r_last = r+0
        r_second_last=r1+0
        L_last=L
        
#Finding velocity between the two last frames, correcting for periodicity
L  = L_last
dr = r_last - r_second_last
dr = dr - L[np.newaxis,:]*np.around(dr/L[np.newaxis,:]) 
v = dr/dt

#Using old fort.5 to insert velocities
atom_nr=0
for l in lines5:
    ls = l.split()
    if(len(ls)>7):
        ls[4:7]  = ["%f" % (0.1*ri) for ri in r_last[atom_nr]]
        if(vel_prior):
            #replace old velocties
            ls[7:10]  = ["%f" % (0.1*vi) for vi in v[atom_nr]] 
        else:
            #insert new velocities
            for i in range(3):
                
                ls.insert(7+i,"%f" % (0.1*v[atom_nr,i]))
                atom_nr += 1
    fp_rec.write('%s\n'%(' '.join(ls)))

fp8.close()
fp_rec.close()

