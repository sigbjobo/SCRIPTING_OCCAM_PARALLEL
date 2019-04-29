      subroutine ofile
      use varsh
      implicit none

      integer ios, id 
      istop = 0 ! check on I/O Files

      open (unit = 10, file = 'fort.10', status = 'OLD',
     $     iostat = ios, access='SEQUENTIAL', form = 'FORMATTED')
      if (ios.ne.0) then
         write(6,*) '*** FATAL fort.10 input file does not exist ***'
         istop = 1
      endif 

      open (unit = 15, file = 'fort.15', status = 'UNKNOWN',
     $     iostat = ios, access='SEQUENTIAL', form = 'FORMATTED')
      if (ios.ne.0) then
         write(6,*) '*** FATAL fort.15 ***'
         istop = 1
      endif 

      open (unit = 20, file = 'fort.20', status = 'UNKNOWN',
     $      iostat = ios, access='SEQUENTIAL', form = 'FORMATTED')
      if (ios.ne.0) then
         write(6,*) '*** FATAL fort.20 ***'
         istop = 1
      endif 

      do id = 1, numprocs
         open (unit = (20+id), status = 'UNKNOWN',
     $       access = 'SEQUENTIAL', form = 'FORMATTED')
      enddo
      end subroutine
