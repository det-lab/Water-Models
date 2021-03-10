!************************************************************************
! Calculates <|r_i(t)-r_i(0)|^2>, <|x_i(t)-x_i(0)|^2>, <|y_i(t)-y_i(0)|^2>, and <|z_i(t)-z_i(0)|^2>
! Written by L. Kinnaman, last updated 3/9/17
!
! Input file: water.mdxyzO
! Output files: difr.dat, difx.dat, dify.dat, and difz.dat
! Hardcoded parameters: number of water molecules, number of time steps
!************************************************************************

program diffuse

  implicit none

!PARAMETERS
  !number of water molecules
  integer,parameter::nwater=432
  !number of timesteps
  integer,parameter::ntime=20000
  
!VARIABLES
  real(kind=8)::dif,x,y,z, x0,y0,z0
  real(kind=8)::dxsqr(ntime),dysqr(ntime),dzsqr(ntime),rsqr(ntime)
  integer::i,t

  ! The Einstein relationship gives 6Dt=<|r_i(t)-r_i(0)|^2>
  ! This program calculates dif(t) = <|r_i(t)-r_i(0)|^2>, the average squared displacement at each time step

!FILES
  open(unit=11,file="water.mdxyzO",action="read") !Includes oxygen coordinates only
  open(unit=10,file="difr.dat",action="write")
  open(unit=12,file="difx.dat",action="write")
  open(unit=13,file="dify.dat",action="write")
  open(unit=14,file="difz.dat",action="write")
  
  ! Initializing squared displacements to zero
  do t=1,ntime
     dxsqr(t)=0.d0
     dysqr(t)=0.d0
     dzsqr(t)=0.d0
  enddo

  ! Reading in oxygen atom positions from simulation data
  do i=1,nwater 
     read(11,*)x0
     read(11,*)y0
     read(11,*)z0

     do t=2,ntime
        read(11,*)x
        read(11,*)y
		read(11,*)z

		! For each molecule, adding its contribution to each component of |r_i(t)-r_i(0)|^2
        dxsqr(t)=dxsqr(t)+(x0-x)**2
        dysqr(t)=dysqr(t)+(y0-y)**2
        dzsqr(t)=dzsqr(t)+(z0-z)**2
     enddo
  enddo

  do t=2,ntime 
  	 ! using r^2 = x^2 + y^2 + z^2 to find |r_i(t)-r_i(0)|^2
     dif=dxsqr(t)+dysqr(t)+dzsqr(t)
     ! Dividing by the number of water molecules to get the average squared displacement
     dif=dif/real(nwater)
     write(10,*)dif
     write(12,*)dxsqr(t)/real(nwater)
     write(13,*)dysqr(t)/real(nwater)
     write(14,*)dzsqr(t)/real(nwater)
  enddo

  close(10);close(11);close(12);close(13);close(14)

end program diffuse

