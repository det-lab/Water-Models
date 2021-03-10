#!/usr/bin/perl 

#************************************************************************
# Parses AMBER trajectory (mdcrd) file to create the formatted input for parse_mdxyz.f90 code
# Written by L. Kinnaman and C. Miller, last updated 7/5/17
#
# Input files: water.mdcrd
# Output files: water.mdxyz, water.mdxyz_copy
# Hardcoded parameters: name of input file, number of water molecules
# Output has x, y, z coordinates of one atom per line
# Order of coordinates in output is O, H1, H2
#************************************************************************


# Defining first set of files
$filename = "water.mdcrd";
$output = "water.mdxyz";
$outputbox = "water_box.mdxyz";

# Open files
open (INFILE, "<$filename")||die "sorry: $!";
open (OUTFILE, ">$output")||die "sorry: $!";
open (OUTFILE2, ">$outputbox")||die "sorry: $!";

# Parameters
$nmol=431; #number of MOLECULES in simulation -1 (because Perl starts counting at zero)
$natom=$nmol*3; #number of ATOMS in simulation: # of molecules x3 (because H2O)
$ncoord=$natom*3; #number of COORDINATES in simulation: # of atoms x3 (because x,y, and z)


# Read in the mdcrd file line by line, splitting each column into a variable 
LINE: while (<INFILE>){
    $coordinates=$_;
    chomp($coordinates);

    ($null0, $null1, $null2, $null3, $null4, $null5, $null6,$null7,$null8,$null9,$null10) = split(/\s+/,$coordinates);

# Parse script will only print the value if it's from a coordinate line (first line of mdcrd & any line containing box lengths have $null4 = blank space)
# WARNING: If you change the number of water molecules, you might break this part of the parsing code, if the coordinates printed in water.mdcrd have a last line per time step with 3 or fewer numbers
if ($null4 =~ /\d+/){ 

	print OUTFILE "$null1 \n";
	print OUTFILE "$null2\n";
	print OUTFILE "$null3\n";
	print OUTFILE "$null4\n";
	if ($null5 =~ /\d+/){ 
		print OUTFILE "$null5\n";
	}
	if ($null6 =~ /\d+/){ 
		print OUTFILE "$null6\n";
	}
	if ($null7 =~ /\d+/){ 
		print OUTFILE "$null7\n";
	}
	if ($null8 =~ /\d+/){ 
		print OUTFILE "$null8\n";
	}
	if ($null9 =~ /\d+/){ 
		print OUTFILE "$null9\n";
	}
	if ($null10 =~ /\d+/){ 
		print OUTFILE "$null10 \n";
	}
} elsif ($null1 =~ /\d+/) {
	print OUTFILE2 "$null1\n";
	print OUTFILE2 "$null2\n";
	print OUTFILE2 "$null3\n";
}

}
close(OUTFILE);
close(OUTFILE2);

# Clean up files
system("cp water.mdxyz water.mdxyz_copy");
