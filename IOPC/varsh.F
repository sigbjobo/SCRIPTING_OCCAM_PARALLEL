       module varsh 

       implicit none

CCCCCCCCCCCC the variables for the input program   CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC

       integer nmol                 ! the total number of molecules 
       integer natom                ! the total number of particles 
       integer molA                 ! the number of molecules A
       integer npartA               ! the number of particles in molecule A
       integer molB                 ! the number of molecules B
       integer npartB               ! the number of particles in molecule B
       integer molC                 ! the number of molecules C 
       integer npartC               ! the number of particles in molecule C
       integer molD                 ! the number of molecules D 
       integer npartD               ! the number of particles in molecule D
       integer numprocs             ! the number of CPU 
       integer l,ll,n,nl,sumnum
       integer i,j,k,is,js,ks,keep 
   
       real*8 b(3,3)                ! the length of box 
       real*8 binc                  ! the changes of the length of the box

       integer, allocatable :: nat(:)               ! the number of atoms in every molecule 
       integer, allocatable :: itype(:)             ! the index of types of particles
       integer, allocatable :: nbonds(:)            ! the number of bonds of one particle
       integer, allocatable :: ibond(:,:)           ! the connectivity of bonds 
       integer, allocatable :: ibond1(:,:)          ! the connectivity of bonds for wtring 

       integer, allocatable :: molApara(:)          ! the number of molecule A in every CPU 
       integer, allocatable :: molBpara(:)          ! the number of molecule B in every CPU 
       integer, allocatable :: molCpara(:)          ! the number of molecule C in every CPU 
       integer, allocatable :: molDpara(:)          ! the number of molecule C in every CPU 
       integer, allocatable :: Ntotalpara(:)        ! the number of total molecules in every CPU 


       real*8, allocatable :: x(:), y(:), z(:)
       real*8, allocatable :: vx(:), vy(:), vz(:)   ! the positions and velocities of particles 
     
       character*5,allocatable:: clab(:)            ! the lab of every particles

       integer istop                                ! check the I/O files
       integer mode                                 ! select the program
       integer vmode                                ! select the velocity reading

CCCCCCCCCCCCCCCC the variables for the  output program  CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
 
       integer nconf                                ! the number of configurations 
       integer nattotal                             ! the number of total particles 
       integer natpara                              ! the number of particles in every CPU 
       integer, allocatable:: natmpia(:)            ! the number of particles in every CPU
       integer intsteps
       real*8  rx,ry,rz,vvx,vvy,vvz
       real*8  wrdt,dLx,dLy,dLz
       real*8  dt 
       character*5 aa 
       
       end module

