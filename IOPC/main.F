
C-----------------------------------------------------------------------------C
! This program IOPC generates the input files and organize output files for   !
! the paralle version of OCCAM. The program works with fort.5                 !
!                                                                             !
!                                                                             !
! Written by: Ying Zhao and Antonio De Nicola                                 !
! Version 1.7                                                                 !
! develope time 07.10.2010                                                    !
! modify time 29.11.2010                                                      !  
! modify time 08.05.2011                                                      !
! modify time 20.07.2011                                                      !
! modify time 05.08.2011                                                      !
! modify time 28.11.2011                                                      !
! modify time 12.01.2012                                                      !
! Contacts: adenicola.chem@gmail.com - zhaoyingmpi2006@gmail.com              !
C-----------------------------------------------------------------------------C

      Program  main 
      use varsh
      implicit none 

C     ! open(*)
      open(6,FILE='input.txt') 

      write(*,*) '========================================'
      write(*,*) '       * * * I. O. P. C. * * *          '
      write(*,*) ' Input Program for Parallel Occam Code  '
      write(*,*) ' ver. 1.7                               '
      write(*,*) '========================================'
      write(*,*)
10    write(*,*) '> insert [1] for input program'
      write(*,*) '> insert [2] for output program'
      write(*,*) '> insert [3] for help'
      read(6,*) mode

      if (mode.eq.1)then

        call ofile
 
        if (istop.gt.0) then
          write(*,*)' *** FATAL ERROR IN THE I/O FILE ***'
          write(*,*)'    please check your input files   '
          stop
        endif

        call input 
   
       if (vmode.eq.1)then
      
        call rdconf_vel

        call wrconf_vel

       elseif (vmode.eq.2)then

        call rdconf

        call wrconf

       endif


       write(*,*)'---------------------------------------'
       write(*,*)'> End Input Program'

      elseif(mode.eq.2)then

        call wtrj

        write(*,*)'> End Output Program'

      elseif(mode.eq.3)then
        write(*,*)
        write(*,*)'+ Help -------------------------------------------+'
        write(*,*)'| For the input you need of fort.10 (coord.)      |' 
        write(*,*)'| For the output you need of fort.20i and fort.1* |'
        write(*,*)'+-------------------------------------------------+'
        write(*,*)
        go to 10
      elseif(mode.gt.3)then
        write(*,*)'Your choose is not valid, retry'
        go to 10
      endif

  

C     ! close(5) 
      close(6) 
      end program
