!************************************************************************
! Calculates the oxygen-oxygen RDF for water
! Written by L. Kinnaman, last updated 3/9/17
! Based on RDF algorithm in M. Allen and D. Tildesley, Computer Simulations of Liquids. Oxford University Press (1987)
!
! Input files: water.mdxyz, water.mdxyz_copy, water_box.mdxyz
! Output file: grOO.dat (value of g(r) at each radial distance r)
! Hardcoded parameters: number of water molecules, number of time steps, number of histogram bins, 3 dimensions
!************************************************************************

program main_gofr

  implicit none

!PARAMETERS
  !number of waters
  integer,parameter::nwater=432
  !number of timesteps
  integer,parameter::ntime=20000
  !number of histogram bins
  integer,parameter::knum=200
  !3 dimensional space
  integer,parameter::dim=3

!VARIABLES
  real(kind=8)::posO(dim),pos(dim,nwater),delta(dim),gr(knum),Lsum(dim)
  real(kind=8)::epsilon,rho,const,H1,H2,Lavex,Lavey,Lavez, L(dim)
  real(kind=8)::nideal,rlower,rupper,drsqr,dr,r
  integer::hist(knum),i,j,k,t,m,d

!FILES
  open(unit=11,file="water.mdxyz",action="read",status="old") 
  open(unit=12,file="water.mdxyz_copy",action="read",status="old") 
  open(unit=14,file="water_box.mdxyz",action="read",status="old")
  open(unit=13,file="grOO.dat",action="write")

!INITIALIZATIONS
  do k=1,knum
     hist(k)=0
  enddo
  
  do d=1,3
  	Lsum(d) = 0
  enddo

 
  over_time:do t=1,ntime
  
    ! Reads in box dimensions
  	do d=1,3
  	 	read(14,*)L(d)
  	 	Lsum(d) = Lsum(d) + L(d)
	enddo
	
    ! Determine size of histogram bin based on length of the box and number of bins
	if(t==1)then
		 epsilon=L(1)/(2.d0*real(knum))
  	endif
  
    ! Reads in simulation data, saving the x, y, z positions of one oxygen atom for each molecule m
     read_m:do m=1,nwater

        !oxygen:
        do d=1,3
           read(12,*)pos(d,m)
        enddo

        !hydrogen 1:
        do d=1,3
           read(12,*)H1
        enddo

        !hydrogen 2:
        do d=1,3
           read(12,*)H2
        enddo

     enddo read_m
     
     ! Reads in simulation data, saving the x, y, z positions of one oxygen atom for all other water molecules
     over_i:do i=1,nwater-1

        !oxygen:
        do d=1,3
           read(11,*)posO(d)
        enddo

        !hydrogen 1:
        do d=1,3
           read(11,*)H1
        enddo

        !hydrogen 2:
        do d=1,3
           read(11,*)H2
        enddo


        over_m:do m=i+1,nwater
          
           !find delta x, delta y, delta z
           drsqr=0.d0
           do j=1,3 ! j = 1 for x, j = 2 for y, j = 3 for z
           	  ! The distance between the centered oxygen and all other oxygens
              delta(j)=posO(j)-pos(j,m)
              ! Placing this distance back into the original box, if the water molecule has wandered past the edges
              delta(j)=delta(j)-L(j)*anint(delta(j)/L(j))
              ! Using r^2 = x^2 + y^2 + z^2
              drsqr=drsqr+delta(j)**2
           enddo
           ! Using r = Sqrt(r^2) to find distance
           dr=sqrt(drsqr)
           ! Adding to the histogram value for the bin that the distance r fits into
           k=int(dr/epsilon)+1

           if(k.le.knum) hist(k)=hist(k)+2
       
        enddo over_m
     enddo over_i
     
       !oxygen:
        do d=1,3
           read(11,*)posO(d)
        enddo

        !hydrogen 1:
        do d=1,3
           read(11,*)H1
        enddo

        !hydrogen 2:
        do d=1,3
           read(11,*)H2
        enddo

  enddo over_time
  
  ! Find the average box length in each dimension
  Lavex=Lsum(1)/real(ntime)
  Lavey=Lsum(2)/real(ntime)
  Lavez=Lsum(3)/real(ntime)
  
  ! Find the density of water using the volume of the box
  rho=real(nwater)/(Lavex*Lavey*Lavez)

  ! Normalization constant for the function g(r)
  const=4.d0*acos(-1.d0)*rho/3.d0

  ! Calculating g(r) from the histogram
  do k=1,knum
     r=(k+0.5d0)*epsilon
     rlower=real(k-1)*epsilon
     rupper=rlower+epsilon
     nideal=const*(rupper**3-rlower**3)
     gr(k)=real(hist(k))/real(ntime)/real(nwater)/nideal
     write(13,*)r,gr(k)
  enddo

  close(12);close(11);close(13)
end program main_gofr