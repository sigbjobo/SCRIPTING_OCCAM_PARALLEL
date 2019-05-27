      subroutine input
      use varsh
      implicit none
      
      write(*,*) '> Insert the total number of molecules: '
      read(6,*) nmol

      write(*,*) '> Insert the total number of particles: '
      read(6,*) natom

      write(*,*) '> Insert the total number of molecule A: '
      read(6,*) molA

      write(*,*) '> Insert the number of particles in molecule A: '
      read(6,*) npartA

      write(*,*) '> Insert the total number of molecule B: '
      read(6,*) molB

      write(*,*) '> Insert the number of particles in molecule B: '
      read(6,*) npartB

      write(*,*) '> Insert the total number of molecule C: '
      read(6,*) molC

      write(*,*) '> Insert the number of particles in molecule C: '
      read(6,*) npartC

      write(*,*) '> Insert the total number of molecule D: '
      read(6,*) molD

      write(*,*) '> Insert the number of particles in molecule D: '
      read(6,*) npartD

      write(*,*) '> Velocity read [1] yes, [2] no: '
      read(6,*) vmode

      write(*,*) '> Insert the number of CPU: '
      read(6,*) numprocs

      write(*,*) '----------------------------------------'


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
