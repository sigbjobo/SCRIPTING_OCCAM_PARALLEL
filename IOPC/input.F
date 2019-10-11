      subroutine input
      use varsh
      implicit none
      
C     write(*,*) '> Insert the total number of molecules: '
      read(6,*) nmol

C     write(*,*) '> Insert the total number of particles: '
      read(6,*) natom

C     write(*,*) '> Insert the total number of molecule A: '
      read(6,*) molA

C     write(*,*) '> Insert the number of particles in molecule A: '
      read(6,*) npartA

C     write(*,*) '> Insert the total number of molecule B: '
      read(6,*) molB

C     write(*,*) '> Insert the number of particles in molecule B: '
      read(6,*) npartB

C     write(*,*) '> Insert the total number of molecule C: '
      read(6,*) molC

C     write(*,*) '> Insert the number of particles in molecule C: '
      read(6,*) npartC

C     write(*,*) '> Insert the total number of molecule D: '
      read(6,*) molD

C     write(*,*) '> Insert the number of particles in molecule D: '
      read(6,*) npartD

C     write(*,*) '> Velocity read [1] yes, [2] no: '
      read(6,*) vmode

C     write(*,*) '> Insert the number of CPU: '
      read(6,*) numprocs

C     write(*,*) '----------------------------------------'


      allocate(nat(nmol))
      allocate(itype(natom))
      allocate(nbonds(natom)) 
      allocate(ibond(natom,6))
      allocate(ibond1(natom,6))
      allocate(molApara(numprocs)) 
      allocate(molBpara(numprocs))
      allocate(molCpara(numprocs))
      allocate(molDpara(numprocs))
      allocate(Ntotalpara(numprocs)) 
      
      allocate(x(natom))
      allocate(y(natom))
      allocate(z(natom))
      allocate(vx(natom))
      allocate(vy(natom))
      allocate(vz(natom))
      allocate(clab(natom))

      end subroutine
