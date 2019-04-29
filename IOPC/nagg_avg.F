        program asphericity

        implicit none

        real*8 temp,boxx,boxy,boxz,boxxi,boxyi,boxzi,
     &  X(400000),Y(400000),Z(400000),RCL,atm_x(16000,4),
     & atm_y(16000,4),atm_z(16000,4),xref,yref,zref,xcom(16000),
     & ycom(16000),zcom(16000),xtemp(16000),ytemp(16000),ztemp(16000),
     &  dx,dy,dz,RXJ,RYJ,RZJ,indx(16000),indy(16000),indz(16000),
     & clx,cly,clz,S(3,3),Q(3,3),W(3),rg,temp1,temp2,
     &kappa,time,avgnit,avgkappa

      integer*8 noa,nop,noam,i,j,k,ii,jj,L(16000),LIT,NIT,LK,ind(16000)
       integer*8 kk,nof

       character*8 label
        
        open(unit=1,file='fort.8',status='unknown')
c        open(unit=2,file='fort7.8',status='unknown')
c        open(unit=3,file='fort8.8',status='unknown')
c        open(unit=4,file='fort9.8',status='unknown')
c        open(unit=5,file='fort10.8',status='unknown')
c	open(unit=6,file='fort11.8',status='unknown')
    
        open(unit=13,file='navg1.dat',status='unknown')  
                 
           nof = 100
          nop = 4480
       	  RCL = 5.0d0
	  time = 200.0

  	   do kk = 1,nof

	       avgnit = 0.0
	       avgkappa = 0.0

           time = time + 0.3


          read(1,*)noa
          read(1,*)temp,boxx,boxy,boxz
          
          do j = 1,noa
          read(1,*)label,X(j),Y(j),Z(j)
          enddo

	  boxxi = 1.0/boxx
	  boxyi = 1.0/boxy
	  boxzi = 1.0/boxz

     

cccccccccccccccccccccccccc
c  sort the cluster
cccccccccccccccccccccccccc
            
             do i = 1,nop
             L(i) = i
             enddo


        DO  I = 1, nop - 1

           IF ( I .EQ. L(I) ) THEN

              J   = I

              RXJ = X(J)
              RYJ = Y(J)
              RZJ = Z(J)


              DO K = I + 1, nop

                 LK = L(K)

                 IF ( LK .EQ. K ) THEN

Ccccccccccccccccccccccc
C     Nearest Image   C
Ccccccccccccccccccccccc

                     Dx = RXJ - X(K)
                     Dy = RYJ - Y(K)
                     Dz = RZJ - Z(K)


         dx = dx - boxx * nint (boxxi * dx)
         dy = dy - boxy * nint (boxyi * dy)
         dz = dz - boxz * nint (boxzi * dz)

           
      IF(sqrt(dx**2+dy**2+dz**2).le.RCL)then

	    
                       L(K) = L(J)
                       L(J) = LK

                    ENDIF

                 ENDIF

                 enddo

              J   = L(J)

              RXJ = X(J)
              RYJ = Y(J)
              RZJ = Z(J)

   

 20            IF ( J .NE. I ) THEN

                 DO  K = I + 1, nop

                    LK = L(K)

                    IF ( LK .EQ. K ) THEN

Ccccccccccccccccccccccc
C     Nearest Image   C
Ccccccccccccccccccccccc

                     Dx = RXJ - X(K)
                     Dy = RYJ - Y(K)
                     Dz = RZJ - Z(K)

            dx = dx - boxx * nint (boxxi * dx)
            dy = dy - boxy * nint (boxyi * dy)
            dz = dz - boxz * nint (boxzi * dz)
		     


   
          IF(sqrt(dx**2+dy**2+dz**2).le.RCL)then

                          L(K) = L(J)
                          L(J) = LK

                       ENDIF

                    ENDIF

               enddo

                 J   = L(J)
                 RXJ = X(J)
                 RYJ = Y(J)
                 RZJ = Z(J)

                 GO TO 20

              ENDIF

           ENDIF

          enddo



ccccccccccccccccccccccccccccccccccccccccccccccccccc
c  counting clusters using molecule center of mass 
cccccccccccccccccccccccccccccccccccccccccccccccccccc

	        do ii = 1,nop
        
        NIT = 1
        LIT = L(ii)

	ind(NIT)  = ii
	indx(NIT) = X(ii)
	indy(NIT) = Y(ii)
	indz(NIT) = Z(ii)
   
       
 10      IF(LIT .NE. ii) THEN

           NIT = NIT + 1

             ind(NIT)  = LIT
	     indx(NIT) = X(LIT)
	     indy(NIT) = Y(LIT)
             indz(NIT) = Z(LIT)
        
               LIT = L(LIT)

           GO TO 10

          ENDIF
ccccccccccccccccccccccccccccccccccccccccc
c  center of mass of the cluster
cccccccccccccccccccccccccccccccccccccccccc

        xref = indx(1)
        yref = indy(1)
        zref = indz(1)

        clx = xref
        cly = yref
        clz = zref

        Xtemp(1) = xref
        Ytemp(1) = yref
        Ztemp(1) = zref 


        do j = 2, NIT

        dx = indx(j) - xref
        dy = indy(j) - yref
        dz = indz(j) - zref

        
        Xtemp(j) = indx(j)-nint(dx*boxxi)*boxx
        Ytemp(j) = indy(j)-nint(dy*boxyi)*boxy
        Ztemp(j) = indz(j)-nint(dz*boxzi)*boxz

        clx = clx + Xtemp(j)
        cly = cly + Ytemp(j)
        clz = clz + Ztemp(j)
        

        xref = Xtemp(j)
        yref = Ytemp(j)
        zref = Ztemp(j)
        
        enddo

        clx = clx/NIT
        cly = cly/NIT
        clz = clz/NIT


ccccccccccccccccccccccccccccccccccccccccccccc
c  asphericity parameter for the molecule
ccccccccccccccccccccccccccccccccccccccccccccc
	  
	 S(1,1) = 0.0
	 S(1,2) = 0.0	
	 S(1,3) = 0.0
	 S(2,1) = 0.0
	 S(2,2) = 0.0
	 S(2,3) = 0.0
	 S(3,1) = 0.0
	 S(3,2) = 0.0
	 S(3,3) = 0.0

	do j = 1,NIT

	S(1,1) = S(1,1) + (xtemp(j)-clx)**2
	S(1,2) = S(1,2) + (xtemp(j)-clx)*(ytemp(j)-cly)
	S(1,3) = S(1,3) + (xtemp(j)-clx)*(ztemp(j)-clz)
	S(2,1) = S(2,1) + (xtemp(j)-clx)*(ytemp(j)-cly)
	S(2,2) = S(2,2) + (ytemp(j)-cly)**2
	S(2,3) = S(2,3) + (ytemp(j)-cly)*(ztemp(j)-clz)
	S(3,1) = S(3,1) + (xtemp(j)-clx)*(ztemp(j)-clz)
	S(3,2) = S(3,2) + (ytemp(j)-cly)*(ztemp(j)-clz)
	S(3,3) = S(3,3) + (ztemp(j)-clz)**2

	enddo

	call eigen(S,Q,W)

	 rg = sqrt(W(1) + W(2) + W(3))

	  temp1 = W(1)+W(2)+W(3)
	  temp2 = W(1)*W(2)+W(2)*W(3)+W(1)*W(3)

	kappa = 1 - 3.0*(temp2/temp1**2)
	

          avgnit = avgnit + NIT
          avgkappa = avgkappa + kappa


        enddo

	  avgnit = int(avgnit/(nop*4))
	  avgkappa = avgkappa/float(nop)

          write(13,*)time,avgnit
	   

	 enddo

	   

  




	stop
	end


* ----------------------------------------------------------------------------
      SUBROUTINE eigen(A, Q, W)
* ----------------------------------------------------------------------------
* Calculates the eigenvalues and normalized eigenvectors of a symmetric 3x3
* matrix A using the Jacobi algorithm.
* The upper triangular part of A is destroyed during the calculation,
* the diagonal elements are read but not destroyed, and the lower
* triangular elements are not referenced at all.
* ----------------------------------------------------------------------------
* Parameters:
*   A: The symmetric input matrix
*   Q: Storage buffer for eigenvectors
*   W: Storage buffer for eigenvalues
* ----------------------------------------------------------------------------
*     .. Arguments ..
      DOUBLE PRECISION A(3,3)
      DOUBLE PRECISION Q(3,3)
      DOUBLE PRECISION W(3)

*     .. Parameters ..
      INTEGER          N
      PARAMETER        ( N = 3 )
    
*     .. Local Variables ..
      DOUBLE PRECISION SD, SO
      DOUBLE PRECISION S, C, T
      DOUBLE PRECISION G, H, Z, THETA
      DOUBLE PRECISION THRESH
      INTEGER          I, X, Y, R

*     Initialize Q to the identitity matrix
*     --- This loop can be omitted if only the eigenvalues are desired ---
      DO  X = 1, N
        Q(X,X) = 1.0D0
        DO 11, Y = 1, X-1
          Q(X, Y) = 0.0D0
          Q(Y, X) = 0.0D0
   11   CONTINUE
      ENDDO

*     Initialize W to diag(A)
      DO 20 X = 1, N
        W(X) = A(X, X)
   20 CONTINUE

*     Calculate SQR(tr(A))  
      SD = 0.0D0
      DO 30 X = 1, N
        SD = SD + ABS(W(X))
   30 CONTINUE
      SD = SD**2
 
*     Main iteration loop
      DO 40 I = 1, 50
*       Test for convergence
        SO = 0.0D0
        DO 50 X = 1, N
          DO 51 Y = X+1, N
            SO = SO + ABS(A(X, Y))
   51     CONTINUE
   50   CONTINUE
        IF (SO .EQ. 0.0D0) THEN
          RETURN
        END IF

        IF (I .LT. 4) THEN
          THRESH = 0.2D0 * SO / N**2
        ELSE
          THRESH = 0.0D0
        END IF

*       Do sweep
        DO 60 X = 1, N
          DO 61 Y = X+1, N
            G = 100.0D0 * ( ABS(A(X, Y)) )
            IF ( I .GT. 4 .AND. ABS(W(X)) + G .EQ. ABS(W(X))
     $                    .AND. ABS(W(Y)) + G .EQ. ABS(W(Y)) ) THEN
              A(X, Y) = 0.0D0
            ELSE IF (ABS(A(X, Y)) .GT. THRESH) THEN
*             Calculate Jacobi transformation
              H = W(Y) - W(X)
              IF ( ABS(H) + G .EQ. ABS(H) ) THEN
                T = A(X, Y) / H
              ELSE
                THETA = 0.5D0 * H / A(X, Y)
                IF (THETA .LT. 0.0D0) THEN
                  T = -1.0D0 / (SQRT(1.0D0 + THETA**2) - THETA)
                ELSE
                  T = 1.0D0 / (SQRT(1.0D0 + THETA**2) + THETA)
                END IF
              END IF

              C = 1.0D0 / SQRT( 1.0D0 + T**2 )
              S = T * C
              Z = T * A(X, Y)
              
*             Apply Jacobi transformation
              A(X, Y) = 0.0D0
              W(X)    = W(X) - Z
              W(Y)    = W(Y) + Z
              DO 70 R = 1, X-1
                T       = A(R, X)
                A(R, X) = C * T - S * A(R, Y)
                A(R, Y) = S * T + C * A(R, Y)
   70         CONTINUE
              DO 80, R = X+1, Y-1
                T       = A(X, R)
                A(X, R) = C * T - S * A(R, Y)
                A(R, Y) = S * T + C * A(R, Y)
   80         CONTINUE
              DO 90, R = Y+1, N
                T       = A(X, R)
                A(X, R) = C * T - S * A(Y, R)
                A(Y, R) = S * T + C * A(Y, R)
   90         CONTINUE

*             Update eigenvectors
*             --- This loop can be omitted if only the eigenvalues are desired ---
              DO 100, R = 1, N
                T       = Q(R, X)
                Q(R, X) = C * T - S * Q(R, Y)
                Q(R, Y) = S * T + C * Q(R, Y)
  100         CONTINUE
            END IF
   61     CONTINUE
   60   CONTINUE
   40 CONTINUE

      PRINT *, "eigen: No convergence."
        
            
      END SUBROUTINE
* End of subroutine eigen

