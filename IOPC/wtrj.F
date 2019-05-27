CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C This subroutine is used to organize the trajoctory from parallel files   C
C (fort.10*) of many CPU to serial file fort.8 and fort.9.                 C
C                                                                          C
C Author:Ying Zhao                                                         C
C Modified Time:8/10/2010                                                  C
C Modified Time:2/11/2010                                                  C
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC

        
        subroutine wtrj
        use varsh
        implicit none
       
        integer os, ios
        istop = 0
 
C        open(*)
C        open(6,FILE='input.txt') 
C        read(6,*)
Copen(6)
        open(8)
        open(9) 

        open (unit = 15, file = 'fort.15', status = 'OLD',
     $        iostat = ios, access='SEQUENTIAL', form ='FORMATTED')
        if (ios.ne.0) then
           write(6,*)'*** FATAL fort.15 does not exist ***'
           istop=1
        endif

        write(*,*) ' * * * Writing Parallel Trajectory * * * '
        write(*,*) '-----------------------------------------'
        write(*,*)
        write(*,*) '> Insert the number of CPU: '

        read(6,*) numprocs
         
        allocate(natmpia(numprocs))

        do i = 1, numprocs
           open(200+i)   ! ATTENTION THE NEW VERSION OF OCCAMPI READ THE INPUT FORM FORT.21 UNTIL FORT.199 
           natmpia(i) = 0 
        enddo

ccccccc read the number of particles in every CPU from fort.15 cccccccc

        do i = 1, numprocs 
 
          read(15,*) natmpia(i) 

        enddo 

!ying  08/05/2011
        write(*,*) '> Insert the initial steps: '
        read (6,*) intsteps
        write(*,*) '> Insert the time step dt:'
        read (6,*) dt 
!ying  08/05/2011
        
        write(*,*) '> Insert the number of configurations:   ' 
        read(6,*) nconf
        write(*,*) '> the end of insert                      '

        write(*,*) '-----------------------------------------'

 
        do i = 1, nconf     

         nattotal = 0 

        do j = 1, numprocs
 
         read(200+j,*) natpara
         read(200+j,*) wrdt,dLx,dLy,dLz
      
         nattotal=nattotal+natmpia(j) 

        enddo

        if((intsteps.eq.0).or.((intsteps.ne.0).and.(i.ge.3))) then 
        write(8,*) nattotal
        write(8,101) wrdt+intsteps*dt,dLx,dLy,dLz
        endif 

        if(i.eq.nconf) then 
         write(9,*) nattotal
         write(9,101) wrdt+intsteps*dt,dLx,dLy,dLz
        endif 

        do j = 1, numprocs
         do k = 1, natmpia(j) 
   
          read(200+j,110)aa,rx,ry,rz,vvx,vvy,vvz  !!! WARNING !!!
         
          if((intsteps.eq.0).or.((intsteps.ne.0).and.(i.ge.3))) then
          write(8,100) aa,rx,ry,rz
          endif 

         if(i.eq.nconf) then 
          write(9,100) aa,rx,ry,rz
         endif
         enddo 
        enddo 
       enddo

100   format(a5, 3f18.10)
110   format(a5, 6f18.10) 
101   format(4f18.10)

      return 
      end subroutine 
