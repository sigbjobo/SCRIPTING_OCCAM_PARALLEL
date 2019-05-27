CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C This subroutine is used to read the configuration from input file fort.5 C
C of serial OCCAM.                                                         C
C                                                                          C
C Author:Ying Zhao and Antonio De Nicola                                   C
C Modified Time:7/10/2010                                                  C
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC

      subroutine rdconf
      use varsh
      implicit none
      integer nmolfile

      open(10)

      read (10,*)
      read (10,*) b(1,1),b(2,2),b(3,3),binc
      read (10,*)
      read (10,*) nmolfile

!CCCCCCCCCCCCCC checking the number of molecules CCCCCCC
      if (nmol.ne.nmolfile) then
        write(5,*) ' the number of molecules is not correct'
        stop
      endif

      write (20,*)'box:'
      write (20,*) b(1,1),b(2,2),b(3,3),binc
      write (20,*) 'molecules_total_number:'
      write (20,*) nmol


!c    l is the particle counter

      l = 0

!      print*,b(1,1),b(2,2),b(3,3),binc,numa
!c    loop over molecules num is number of molecules
! 

      do 120  n = 1,nmol

         read (10,*)
         read (10,*) nat(n)
         write(20,*) 'atoms_in_molecule:'
         write(20,*) nat(n)

      do 110 nl = 1,nat(n)
            l = l + 1
            read (10,*) ll,clab(l), itype(l),
     $  nbonds(l)
     $, x(l),y(l),z(l) ,
!     $  vx(l), vy(l), vz(l),
     $  (ibond(l,j),j=1,6)     ! insert the max number of connectivity [default: (ibond(l,j),j=1,4) ]

c           write (20,500) ll,clab(l), itype(l),
           write (20,*) ll,clab(l), itype(l),
     $  nbonds(l)
     $, x(l),y(l),z(l) ,
!     $  vx(l),vy(l),vz(l),
     $  (ibond(l,j),j=1,6)    ! insert the max number of connectivity [default: (ibond(l,j),j=1,4) ]

 110  continue
 120  continue
 500  format(i8,2x, a5, 2i3, 6d15.6, 6i8)   ! the default value of this format is: (i8,2x, a5, 2i3, 6d15.6, 4i8)


      close(10)
      return
      end subroutine

