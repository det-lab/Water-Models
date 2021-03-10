!************************************************************************
! Parses coordinate output from parse_mdcrd.pl for the specific use of diffusion.f90 and grOO.f90
! Written by L. Kinnaman, last updated 3/9/17
!
! Input files: water.mdxyz
! Output files: water.mdxyzO, water_box.mdxyz
! Hardcoded parameters: number of water molecules, number of time steps, number of histogram bins, 3 dimensions
!************************************************************************

program parsexyz

  implicit none

  !number of waters
  integer,parameter::nwater=432
  !number of timesteps
  integer,parameter::ntime=20000

  
  real(kind=8)::x(ntime,nwater),y(ntime,nwater),z(ntime,nwater),dummy

  integer::i,t,j


  open(unit=11,file="water.mdxyz",action="read")
  open(unit=10,file="water.mdxyzO",action="write") 		!Oxygen coordinates
    
  timeloop: do t=1,ntime
     moleculeloop: do i=1,nwater
        read(11,*)x(t,i)
        read(11,*)y(t,i)
		read(11,*)z(t,i)
	
		hydrogenloop: do j = 1, 6 !read hydrogen lines into dummy variable
			read(11,*)dummy
		enddo hydrogenloop
	
    enddo moleculeloop
	
  enddo timeloop
  
  !write out oxygen coordinates
  do i = 1,nwater
  	do t = 1, ntime
  		write(10,*)x(t,i)
		write(10,*)y(t,i)
		write(10,*)z(t,i)
	enddo
  enddo

  close(10);close(11);close(12)

end program parsexyz

