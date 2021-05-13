#!/home/wx019276/TRACK-1.4.3/converters/convsh1.91.linux
#  Convsh script conv2nc.tcl

#
#  Convert input files into single Netcdf file.
#  All input files must contain the same fields and have 
#  identical dimensions except for the time dimension.
#  For example to convert UM output files into a Netcdf file 
#  use the following command:
#
#      conv2nc.tcl -i xaavaa.pc* -o xaava.nc
 
#  Write out Netcdf file
set outformat netcdf

#  Automatically work out input file type
set filetype 0

#  Convert all fields in input files to Netcdf
set fieldlist "4 5"

#  Get command line arguments:
#      -i input files (can be more than one file)
#      -o output file (single file only)

set i false
set o false
set levs false; set inlevels "unset"; set subset_z false;

foreach arg $argv {
   switch -glob -- $arg {
      -i      {set i true ; set o false}
      -o      {set i false ; set o true}
      -*      {puts "unknown option $arg" ; set i false; set o false}
      -levs   {set i false; set o false; set levs true; set subset_z true}
      default {
         if {$i} {
            set infile [lappend infile $arg]
         } elseif {$o} {
            set outfile [lappend outfile $arg]
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

# Set the output levels in z
if {$inlevels != "unset"} {
  regexp -- {level code = ([0-9]+)} [printhead] dummy levtype
    puts "The level type is: $levtype.\n"
    set levs [split $inlevels ,]
    foreach level $levs {
      if {[regexp {^[0-9]+\-[0-9]+$} $level]} {
          if {$levtype != 109} { # If NOT model levels
            puts "\nPlease only use level ranges in argument (e.g. a-b) for data on model levels.\n";
            puts "Exiting programme.\n\n"
          exit
          }
          set levrange [split $level -]
          set firstlev [lindex $levrange 0]
          set lastlev [lindex $levrange 1]
          incr lastlev
          for {set lcount $firstlev} {$lcount < $lastlev} {incr lcount} {
            set levels [lappend levels $lcount]
          }
      } else {
        set levels [lappend levels $level]
      }
    }
    foreach level $levels {
      if {$levtype == 109} {
        #Should work for any number of model levels e.g. 1-31, 1-60
        set level [expr $level-1]
        set outlevels [lappend outlevels $level]
      } elseif {$levtype == 100} {
        # Get number of pressure levels
        regexp -- {number of selected points in z direction = ([0-9]+)} [printhead] dummy1 numlevs dummy2
        puts "NUMBER OF LEVS is $numlevs\n"
        # Get start and end levels
        regexp -- {z\[0\] = ([0-9]+\.?[0-9]+) z\[([0-9]+)\] = ([0-9]+\.?[0-9]+)} [printhead] dummy1 firstlev dummy2 lastlev
        # Define levels depending on the amount and order.
        if {$numlevs == 5} {
          if {$firstlev == 925} {
            set levmap "925 850 500 300 200"  
          } else {
            set levmap "10 30 50 70 100 150 200 250 300 400 500 700 850 925 1000"  
          }
        }        if {$numlevs == 15} {
          if {$firstlev == 1000} {
            set levmap "1000 925 850 700 500 400 300 250 200 150 100 70 50 30 10"  
          } else {
            set levmap "10 30 50 70 100 150 200 250 300 400 500 700 850 925 1000"  
          }
        } elseif {$numlevs == 17} {
          if {$firstlev == 1000} {
            set levmap "1000 925 850 775 700 600 500 400 300 250 200 150 100 70 50 30 10"  
          } else {
            set levmap "10 30 50 70 100 150 200 250 300 400 500 600 700 775 850 925 1000"  
          }
        } elseif {$numlevs == 21} {
          if {$firstlev == 1000} {
            set levmap "1000 925 850 700 500 400 300 250 200 150 100 70 50 30 20 10 7 5 3 2 1"
          } else {
            set levmap "1 2 3 5 7 10 20 30 50 70 100 150 200 250 300 400 500 700 850 925 1000"  
          }
        } elseif {$numlevs == 23} {
          if {$firstlev == 1000} {
            set levmap "1000 925 850 775 700 600 500 400 300 250 200 150 100 70 50 30 20 10 7 5 3 2 1"  
          } else {
            set levmap "1 2 3 5 7 10 20 30 50 70 100 150 200 250 300 400 500 600 700 775 850 925 1000"
          }
        }
        set level [lsearch -exact $levmap $level]
        set level [expr $level]
        set outlevels [lappend outlevels $level]
      } elseif {$levtype == 113} {
        # Potential temperature levels are 265,275,285,300,315,330,350,370,395,430,475,530,600,700,850
        lappend levmap 265 275 285 300 315 330 350 370 395 430 475 530 600 700 850
        set level [lsearch -exact $levmap $level]
        set level [expr $level-1]
        set outlevels [lappend outlevels $level]
      }
    }
  puts "Levels to output are: $levels.\n"
  set subset_z true
} else {
  puts "\nNo subsetting in z (vertical co-ordinate)...\n"
}



# Now set the levels in the output [if not defined, set to all]
if {$subset_z} {
  setdim 3 $fieldlist "$outlevels"
}


#  Write out all input fields to a single Netcdf file

writefile $outformat $outfile $fieldlist
