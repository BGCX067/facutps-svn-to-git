#! /bin/sh

#                               -*- Mode: Ksh -*-
# piecharts-data.sh --- Automatic generation of data file for piecharts.sh
# Author          : Denis GIROU (CNRS/CIRCE - France) <girou@circe.fr>
# Created the     : Fri Dec 11 19:44:47 1992
# Last mod. by    : Denis GIROU (CNRS/CIRCE - France) <girou@circe.fr>
# Last mod. the   : Tue Jan 26 22:06:10 1993
# Version         : 1.1
#
# Description     :   piecharts-data.sh is a simple SHELL and AWK program to
#                   generate data files expected by the associated
#                   piecharts.sh script, to realize hight quality, greatly,
#                   customizable grayscaled or colored pie charts in (La)TeX +
#                   PostScript, with the PSTricks package of Timothy Van Zandt
#                   <tvz@princeton.edu>.
#                     The labels are written to be the outside labels of
#                   the parts of the pie chart (with the numbers itself
#                   below) and the percentages will be the inside labels
#                   of the parts (see the description of piecharts.sh).
#                     The parts will have gray colors, equally calculated
#                   between black and white in function of the number
#                   of the parts.
#                     The variable LABEL_OTHERS contains the label used
#                   to describe the part for the sum of the rest of the
#                   value ("Others" by default).
#
# Syntax          : piecharts-data.sh title nb_parts [PLAIN] <data_file \
#                                     >output_file
#                     If the title has several words, they must be enclose
#                   by the " symbol.
#                     nb_parts is the number of the parts requested for the
#                   pie chart. If they are more than nb_parts lines of data
#                   (generally the case), the last part is the sum of all
#                   the last parts. It must be less than 27.
#                     By default, some LaTeX commands (\small, \\) are
#                   inserted. If you want to generate plain TeX code,
#                   use the TEX option.
#                     You also can directly generate the pie chart, if you
#                   pipe the result with the piecharts.sh script (see the
#                   examples section):
#
# Input file format:  Each line must contains two fields: a label and a
#                   quantity. The quantities can be in non increase order.
#                     Here is an example (suppress the first 2 characters
#                   of each line):
# LUU 3094
# SOL 1438
# LMD 365
# LEG 267
# PPM 248
# MEF 236
# ASF 122
# DRT 57
# AMB 33
# TPR 18
# RRS 9
#
# Examples        :   If you name these file vpusers.dat, you can simply type:
#                   piecharts-data.sh "My title" 5 <vpusers.dat >vp.tmp
#                     or directly:
#                   piecharts-data.sh "My title" 5 <vpusers.dat \
#                                     | piecharts.sh 2 figure boxit >pie.tmp
#                     If you want to generate plain TeX code:
#                   piecharts-data.sh "My title" 5 plain <vpusers.dat \
#                                     | piecharts.sh 2 plain >pie.tmp
#
# Portability     :   Expected great. Tested on RS6000 under AIX 3.2 and
#                   DECStation 3100 under Ultrix 4.3
#
# Known problems  : None for the moment!
#
# History         : (12/23/92) - rev. 1.0
#                   (01/26/93) - rev. 1.1:
#                      * suppression of lines longer than 78 characters
#                      * add the PLAIN option to generate plain TeX code


LABEL_OTHERS="Others"		# For english people
# LABEL_OTHERS="Autres"		# For french people

# Verification of the parameters
if [ $# -lt 2 ]
   then echo "You must give 2 or 3 parameters."
        echo "Syntax: piecharts-data.sh title number_of_parts [PLAIN] \
<data_file >out_file"
        exit
fi
if [ $2 -lt 2 ]
   then echo "The number_of_parts must be greater than 2."
        exit
fi
if [ $2 -gt 26 ]
   then echo "The number_of_parts must be less than 27."
        exit
fi
if [ $# -eq 3 ] && [ $3 != "PLAIN" ] && [ $3 != "plain" ]
   then echo "Syntax: piecharts-data.sh title number_of_parts [PLAIN] \
<data_file >out_file"
        exit
fi

# As some AWK versions doesn't accept the definition of external variables,
# we create a temporary file with a first line containing the parameters,
# and we copied the data after this line

# The temporary files
FILENAME1=/tmp/file1-pie.tmp
FILENAME2=/tmp/file2-pie.tmp
if [ -f $FILENAME1 ]
   then rm $FILENAME1
fi
if [ -f $FILENAME2 ]
   then rm $FILENAME2
fi

# The first line is : the title, the number of parts, the label for the others
# parts ("Others" by default) and the total of the quantities (the second
# fields of the data file)

(echo $1 "|" $2 "|" $LABEL_OTHERS "|" `tee $FILENAME1 | awk '{TOT += $2} \
  END{print TOT}'` ; cat $FILENAME1) >$FILENAME2

# Beginning of the AWK program
awk '
BEGIN{FS="|"
      ALPHABET="ABCDEFGHIJKLMNOPQRSTUVWXYZ"
      PARAM="NO"
      }

{
 if (PARAM == "NO") {
     #   Parameters: title, nb_parts, label for "others parts and total of
     # the quantities
     PARAM="YES"
     TITLE=$1
     NB_PARTS=$2
     LABEL_OTHERS=$3
     TOTAL=$4
     #   Generation of the gray colors that the pie chart will use
     # (equally calculated between the first black and the last white)
     for (I=1 ; I<=NB_PARTS ; I++)
         print "##        \\newgray{mygray" substr(ALPHABET,I,1) "}{" \
               1 / (NB_PARTS-1) * (I-1) "}"
     printf("\n%s\n\n",TITLE)
     }
    else {FS=" "
          NB_DATA++
          if (NB_DATA < NB_PARTS)
             {PERCENTAGE = $2 / TOTAL * 100
              printf("%s%s%3.1f%s%s%s%s%s%s\n",PERCENTAGE, \
                     " | {\\small ",PERCENTAGE,"\\%} | ",$1,"\\\\{\\small ", \
                     $2, "} | solid | mygray",substr(ALPHABET,NB_DATA,1))
             }
           else
             TOTAL_REST += $2
          LAST_LABEL = $1
         }
}

# We must take care of the last part (the total for the last data lines if
# nb_parts is less than the number of lines, the part for the last line only
# otherwise)
END{PERCENTAGE = TOTAL_REST / TOTAL * 100
    if (NB_DATA == NB_PARTS)
       printf("%s%s%3.1f%s%s%s%s%s%s\n",PERCENTAGE, \
             " | {\\small ",PERCENTAGE,"\\%} | ",LAST_LABEL, \
             "\\\\{\\small ",TOTAL_REST,"} | solid | mygray", \
             substr(ALPHABET,NB_DATA,1))
    else if (NB_DATA > NB_PARTS)
            printf("%s%s%3.1f%s%s%s%s%s%s\n",PERCENTAGE, \
                  " | {\\small ",PERCENTAGE,"\\%} |",LABEL_OTHERS, \
                  "\\\\{\\small ",TOTAL_REST,"} | solid | mygray", \
                  substr(ALPHABET,NB_PARTS,1))
    }' <$FILENAME2 >$FILENAME1


# Check plain TeX mode
if [ $# -eq 3 ]
   then sed -e /\\\\\\\\/s//\\\\cr\ /g -e /\\\\small\ /s///g $FILENAME1
   else cat $FILENAME1
fi

# Clean up the temporary files
if [ -f $FILENAME1 ]
   then rm $FILENAME1
fi
if [ -f $FILENAME2 ]
   then rm $FILENAME2
fi
