CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C This subroutine is used to write the configuration for parallel input    C
C files (fort.2*),which is the same function with fort.5 of serial OCCAM.  C
C                                                                          C
C Author:Ying Zhao and Antonio De Nicola                                   C
C Modified Time:8/5/2011                                                  C
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC

      subroutine wrconf

      use varsh 
      implicit none

      integer Atom,Atomtotal,Lkind,Numb
      character Lab


       do i = 1, numprocs
          
          molApara(i) = molA/numprocs     ! the number of molecule A in every CPU 
          molBpara(i) = molB/numprocs    
          molCpara(i) = molC/numprocs 
          molDpara(i) = molD/numprocs 
        
      enddo

c      print*,mod(molB,numprocs) 

      if (mod(molA,numprocs).gt.0) then

         do i = 1, mod(molA,numprocs)
           molApara(i) = molApara(i) + 1
         enddo
 
      endif 

      if (mod(molB,numprocs).gt.0) then 
C           print*,mod(molB,numprocs) 

         do i = 1, mod(molB,numprocs)
           molBpara(numprocs-i+1) = 
     $     molBpara(numprocs-i+1)+1
         enddo

       endif 

       if (mod(molC,numprocs).gt.0) then 

         do i = 1, mod(molC,numprocs)
           molCpara(i) = molCpara(i) + 1
         enddo 

       endif 

       if (mod(molD,numprocs).gt.0) then 

         do i = 1, mod(molD,numprocs)
           molDpara(i) = molDpara(i) + 1
         enddo 

       endif


C       write(*,*)' > the number of mol. A, B, C and total in every CPU:'
C       write(*,*)'           proc         mol.A       mol.B   
C     $    mol.C      mol.D        total '

           do i = 1, numprocs

            Ntotalpara(i) = molApara(i)+molBpara(i)+molCpara(i)
     $ +molDpara(i) 

C            write(*,*)'CPU', i, molApara(i),molBpara(i),molCpara(i),
C     $                   molDpara(i),  Ntotalpara(i)

            write(15,*)molApara(i)*npartA
     $      +molBpara(i)*npartB+molCpara(i)*npartC+molDpara(i)*npartD,
     $             molApara(i), molBpara(i), molCpara(i), molDpara(i)

            write(20+i,*)'box'
            write(20+i,*) b(1,1),b(2,2),b(3,3),'0.000'
            write(20+i,*)'molecules_total_number'
            write(20+i,*) Ntotalpara(i),molApara(i)*npartA
     $      +molBpara(i)*npartB+molCpara(i)*npartC+molDpara(i)*npartD

           enddo 

!CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
!     This is for molecule A 
!CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC

        sumnum = 0
         

       do i = 1, numprocs

             if (i.ge.2) then

                 sumnum = sumnum+molApara(i-1)

             endif


        do js = 1, molApara(i)

             ks = sumnum + js

             write(20+i,*) 'atoms_in_molecule:',js
             write(20+i,*) ks
             write(20+i,*) npartA

         do is = 1, npartA 

                Atom=(js-1)*npartA+is                  ! the index of atoms in processor
                Atomtotal=(ks-1)*npartA+is             ! the index of atoms in total atoms        
                keep = sumnum*npartA

                Lab=clab(Atomtotal)                    ! the label of atom
                Lkind=itype(Atomtotal)                 ! the index of type of atom
                Numb= nbonds(Atomtotal)                ! the number of bond 
          
           
           do j = 1, 6 !4 default

            if (ibond(Atomtotal,j).ne.0) then
               ibond1(Atomtotal,j)=ibond(Atomtotal,j)-keep
            else
               ibond1(Atomtotal,j)=ibond(Atomtotal,j) 
            endif 

          enddo

       write(20+i,200) Atom,Atomtotal,Lab,Lkind,Numb,
     $                 X(Atomtotal),Y(Atomtotal),Z(Atomtotal),
     $  (ibond1(Atomtotal,j),j=1,6)      ! default (ibond1(Atomtotal,j),j=1,4)

          enddo
          enddo
          enddo

!CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
!      This is for molecules B 
!CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC

        sumnum = 0

       do i = 1, Numprocs   

          if (i.ge.2) then

           sumnum = sumnum+molBpara(i-1) 

          endif
      

       do js = 1, molBpara(i)

               ks = sumnum + js

              write(20+i,*) 'atoms_in_molecule:',molApara(i)+js
              write(20+i,*) ks+molA
              write(20+i,*) npartB

       do is = 1, npartB

                Atom=(js-1)*npartB+is+molApara(i)*npartA    ! the index of atom in processor
                Atomtotal=(ks-1)*npartB+is+molA*npartA      ! the index of atom in total atoms
                keep = sumnum*npartB+molA*npartA

                Lab= clab(Atomtotal)                   ! the label of atom
                Lkind=itype(Atomtotal)                 ! which kind of atom
                Numb=nbonds(Atomtotal)                 ! the number of bond 


           do j = 1, 6 ! 4 default 

            if (ibond(Atomtotal,j).gt.0) then
             ibond1(Atomtotal,j)=ibond(Atomtotal,j)-keep
     $ +molApara(i)*npartA
            else
               ibond1(Atomtotal,j)=ibond(Atomtotal,j)
            endif

          enddo


       write(20+i,200) Atom,Atomtotal,Lab,Lkind,Numb,
     $             X(Atomtotal),Y(Atomtotal),Z(Atomtotal),
     $  (ibond1(Atomtotal,j),j=1,6)   !default  (ibond1(Atomtotal,j),j=1,4)

       enddo
       enddo
       enddo

!CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
!      This is for molecule C
!CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
    
        sumnum = 0

       do i = 1, Numprocs

          if (i.ge.2) then

           sumnum = sumnum+molCpara(i-1) 

          endif


       do js = 1, molCpara(i)

               ks = sumnum + js

          write(20+i,*) 'atoms_in_molecule:',molApara(i)+molBpara(i)+js
          write(20+i,*) ks+molA+molB
          write(20+i,*) npartC

       do is = 1, npartC

                Atom=(js-1)*npartC+is+molApara(i)*npartA
     $              +molBpara(i)*npartB    ! the index of atom in processor

                Atomtotal=(ks-1)*npartC+is+molA*npartA+molB*npartB    ! the index of atom in total atoms
                keep = sumnum*npartC+molA*npartA+molB*npartB

                Lab= clab(Atomtotal)                   ! the label of atom
                Lkind=itype(Atomtotal)                 ! which kind of atom
                Numb=nbonds(Atomtotal)                 ! the number of bond 


           do j = 1, 6 ! 4 default

            if (ibond(Atomtotal,j).gt.0) then
             ibond1(Atomtotal,j)=ibond(Atomtotal,j)-keep
     $ +molApara(i)*npartA+molBpara(i)*npartB
            else
               ibond1(Atomtotal,j)=ibond(Atomtotal,j)
            endif

          enddo


       write(20+i,200) Atom,Atomtotal,Lab,Lkind,Numb,
     $             X(Atomtotal),Y(Atomtotal),Z(Atomtotal),
     $  (ibond1(Atomtotal,j),j=1,6)  ! 4 default

       enddo
       enddo
       enddo
!CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
!      This is for molecule D
!CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
    
        sumnum = 0

       do i = 1, Numprocs

          if (i.ge.2) then

           sumnum = sumnum+molDpara(i-1) 

          endif


       do js = 1, molDpara(i)

               ks = sumnum + js

          write(20+i,*) 'atoms_in_molecule:',molApara(i)+molBpara(i)
     $    +molCpara(i)+js
          write(20+i,*) ks+molA+molB+molC
          write(20+i,*) npartD

       do is = 1, npartD

                Atom=(js-1)*npartD+is+molApara(i)*npartA
     $           +molBpara(i)*npartB+molCpara(i)*npartC    ! the index of atom in processor

                Atomtotal=(ks-1)*npartD+is+molA*npartA+molB*npartB
     $   +molC*npartC    ! the index of atom in total atoms
               keep = sumnum*npartD+molA*npartA+molB*npartB+npartC*molC

                Lab= clab(Atomtotal)                   ! the label of atom
                Lkind=itype(Atomtotal)                 ! which kind of atom
                Numb=nbonds(Atomtotal)                 ! the number of bond 


           do j = 1, 6 !4 default

            if (ibond(Atomtotal,j).gt.0) then
             ibond1(Atomtotal,j)=ibond(Atomtotal,j)-keep
     $ +molApara(i)*npartA+molBpara(i)*npartB
     $ +molCpara(i)*npartC
            else
               ibond1(Atomtotal,j)=ibond(Atomtotal,j)
            endif

          enddo


       write(20+i,200) Atom,Atomtotal,Lab,Lkind,Numb,
     $             X(Atomtotal),Y(Atomtotal),Z(Atomtotal),
     $  (ibond1(Atomtotal,j),j=1,6) ! 4 default

       enddo
       enddo
200   format(i8,2x,i8,2x,1a5,2x, i5, 2x, i5, 3d15.6, 2x, 6i7)  ! default (i8,2x,i8,2x,1a5,2x, i5, 2x, i5, 3d15.6, 2x, 4i7)
      enddo

      return
      end subroutine
