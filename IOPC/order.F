        program orga
        implicit none

        integer nsteps,natmpia1,natmpia2,natmpia3,natmpia4
        integer natmpia5,natmpia6,natmpia7,natmpia8
        integer i, j, nat
        character*5 aa
        real*8 rx,ry,rz,vx,vy,vz,dt,dLx,dLy,dLz

        parameter(nsteps=81) 

        open(10) 
        open(8)
 
        do i = 1, nsteps      

         read(10,*) nat
         read(10,*) dt,dLx,dLy,dLz
 
         write(8,*) nat

         write(8,101) dt,dLx,dLy,dLz

          do j = 1, nat
           
          read(10,*)aa,rx,ry,rz,vx,vy,vz
          if (aa.ne.'W') then
          write(8,100) aa,rx,ry,rz,vx,vy,vz
          endif

          enddo

          do j = 1, nat

          read(10,*)aa,rx,ry,rz,vx,vy,vz
          if (aa.eq.'W') then
          write(8,100) aa,rx,ry,rz,vx,vy,vz
          endif

          enddo

         enddo

100   format(a5, 6f18.10)
101   format(4f18.10)

         close(10)
         close(8)

        end
