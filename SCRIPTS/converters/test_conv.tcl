#!/home/wx019276/SHELL_SCRIPTS/converters/convsh1.91.linux
#  Convsh script conv2nc.tcl

#
#  Convert input files into single Netcdf file.
#  All input files must contain the same fields and have 
#  identical dimensions except for the time dimension.
#  For example to convert UM output files into a Netcdf file 
#  use the following command:
#
#      conv2nc.tcl -i xaavaa.pc* -o xaava.nc
#
#
# --------------------------------------------------------------
#  Modified by Ruth Petrie 
#  12-11-2013
#
#  include **OPTIONAL** arguments
#  -p: select parameters to output by index number, 
#      if more than one required separate by comma; e.g -p 1,2,3
#
#  -levs: selected output levels by index
#
#  These modification allow the routine to be called by 
#
#  convpp2nc.tcl -i {filename(s)}.pp -o {fileout}.nc [-p {parameters}] [-levs {levels}]
#
#  The pararmeter number must be known - can not call by parameter name...
#      this could be improved
#
#  The level index is required not the actual level 
#      this could be improved
# --------------------------------------------------------------

#  Get command line arguments:
#      -i input files (can be more than one file)
#      -o output file (single file only)
#      -p parameters
#      -levs selected levels 

set i false
set o false
set params false
set levs false


#  Write out Netcdf file
set outformat netcdf

#  Automatically work out input file type
set filetype 0

foreach arg $argv {
   switch -glob -- $arg {
      -i      {set i true ; set o false; set params false; set levs false}
      -o      {set i false ; set o true; set params false; set levs false}
      -p      {set i false ; set o false ; set params true; set levs false}
      -levs   {set i false ; set o false ; set params false; set levs true}    
      -*      {puts "unknown option $arg" ; set i false; set o false;  set params false; set levs false}
      default {
         if {$i} {
            set infile [lappend infile $arg]
         } elseif {$o} {
            set outfile [lappend outfile $arg]
         } elseif {$params} {
            set paramarg $arg
         } elseif {$levs} {
            set inlevels $arg
         } else {
            puts "unknown option $arg"
         }
      }
   }
}

if {! [info exists infile]} {
   puts "input file name must be given"
   exit
}

if {[info exists outfile]} {
   if {[llength $outfile] > 1} {
      set outfile [lindex $outfile 0]
      puts "Only one output file can be specified, using $outfile"
   }
} else {
   puts "output file name must be given"
   exit
}

#  Read in each of the input files

foreach file $infile {
   readfile $filetype $file
}

if {[info exists paramarg]} {
  set parameters [split $paramarg ,]
  set fieldlist "$parameters"
  } else {
  #  Set all fields if none specified
  set fieldlist -1  
}

# Print the selected parameter numbers
puts "Parameter numbers to output are: $fieldlist"

# select only the specified levels
if {[info exists inlevels]} {
   set outlevels [split $inlevels ,]
   setdim 3 $fieldlist $outlevels 
}

#  Write out all input fields to a single Netcdf file

writefile $outformat $outfile $fieldlist
