#! /bin/sh

#                               -*- Mode: Ksh -*-
# piechart.sh --- Creation of pie charts in (La)TeX + PostScript with PSTricks
# Author          : Denis GIROU (CNRS/IDRIS - France) <Denis.Girou@idris.fr>
# Created the     : Fri Oct 16 21:53:41 1992
# Last mod. by    : Frank BENNETT (SOAS - UK) <fbennett@rumple.soas.ac.uk>
# Last mod. the   : Thu Mar 28 20:10:54 1996
# Version         : 2.2a
#
# Description     :   piechart.sh is a simple SHELL and AWK program to
#                   realize hight quality, greatly customizable, grayscaled
#                   or colored pie charts in PostScript.
#                     It uses (La)TeX and the splendid PSTricks package of
#                   Timothy Van Zandt <tvz@princeton.edu>, available on CTAN
#                   in graphics/pstricks directory.
#                     It creates the (La)TeX (+ PSTricks) code for direct
#                   insertion in a (La)TeX document of the pie chart generated.
#                   It use a data file which describe the parts and the labels
#                   for them.
#                     You always can modify the generated code for more
#                   personal and sophisticated result.
#
# Syntax          : piechart.sh [scale_factor] ([PLAIN] | [FIGURE] [BOXIT]) \
#                                <data_file >output_file
#                     Default scale factor is 1.
#                     Default mode is LaTeX. In this case, use the FIGURE
#                   option if you want to define the figure LaTeX environment
#                   for the pie chart, and use the BOXIT option if you want
#                   a box around this figure.
#                     Use the PLAIN option if you want to generate a plain TeX
#                   code (in this case, you cannot used the FIGURE and BOXIT
#                   options).
#
# Input file      :   The fill styles are: none, solid, vlines, vlines*,
#                   hlines, hlines*, crosshatch, crosshatch*
#                     The predefined colors are : black, darkgray, gray,
#                   lightgray, white, red, green, blue, cyan, magenta, yellow
#                     You can easily define new gray or colors, or access to a
#                   rgb palette with the palette.sty file of PSTricks.
#                     You can also change a lot of parameters. See the
#                   documentation of PSTricks for more customization.
#
# Input file format:  You can add blanks lines and comments (beginning by #).
#                     The default field separator is | You can change it at
#                   the AWK level.
#                     The first non-comment line has 3 fields for titles
#                   (only the first is required), and after you must have one
#                   line by part of the pie chart, with 5 or 6 fields each
#                   (percentage, inside label, outside label, filling, color,
#                   explode). The last one is optional and must be "yes" if
#                   you want that this part will be explode in the pie chart.
#                     Obviously, the total of the percentages must be 100, or
#                   less.
#                     You can add (La)TeX commands in the labels (\em, \small,
#                   etc.), and separate lines by \\ in LaTeX and \cr in TeX.
#                   The text attributes cannot act on multiple lines : you
#                   must type {\em Paris}\\{\em France} for example in LaTeX.
#                     Be careful of some (La)TeX special characters (see $
#                   and % in the examples).
#                     Here are two examples, using a LaTeX syntax (suppress
#                   the first 2 characters of each line):
#
# # Data for the first example of pie charts
#
# # Title of the figure      | Title for the table of figures | Label
# Example 1 of pie chart
#
# # Value | Inside label  | Outside label                 | Type of    | Color
# #                                                       |  filling   |  fill
#      20 | \small\$9.0M  | {\em Paris}\\{\em France}     | hlines     | black
#      35 | \small\$16.7M | {\em London}\\Great Britain   | vlines     | black
#      45 | {\small\$23.1M}\\1991 | {\em Berlin}\\Germany | crosshatch | black
#
#
# # Data for the second example of pie charts
#
# # Title of the figure      | Title for the table of figures | Label
# \bf Example 2 of pie chart | Pie Chart 2                    | piechart2
#
# # Value | Inside | Outside label | Type of    | Color of | Explode part
# #       |  label |               |  filling   |  filling |
#       2 |        |  2\% \\ Last  | solid      | red      | yes
#      28 |        | 28\%          | solid      | blue
#       4 |        |  4\%          | solid      | green
#      47 |        | 47\% \\ First | solid      | magenta  | yes
#      19 |        | 19\%          | solid      | cyan
#
#
# Examples        :   If you name these files piechart1.dat and piechart2.dat,
#                   you can simply type:
#                   piechart.sh 1.5 <piechart1.dat >piechart1.tmp
#                   piechart.sh 0.7 figure boxit <piechart2.dat >pie2.tmp
#                   and just insert the two result files in a LaTeX document
#                   at the right place...
#                     There are no difference if you want to produce plain TeX
#                   code. You only must put valid plain TeX commands in the
#                   data files.
#
# Portability     :   Expected great. Tested on RS6000 under AIX 3.2 and
#                   DECStation 3100 under Ultrix 4.3
#
# Known problems  :   - Obviously, take care of the labels for the small
#                   parts. If they are too long or in a too big font, the
#                   result will not be pretty...
#                     - You must have the LANG environment variable to En_US
#                   if your UNIX has the National Language Support (NLS)
#                   (by instance, amusing problems arrive with LANG=Fr_FR ...)
#
# Thanks          :   Timothy Van Zandt for the great work of PSTricks, tests
#                   and ideas for the plain TeX mode.
#
# History         : (10/16/92) - rev. 1.0
#                   (10/20/92) - rev. 1.1:
#                      * increase the portability by suppression of the usage
#                        of the sub builtin function of AWK
#                      * better tracking of blank/null and comments lines
#                   (12/04/92) - rev. 2.0:
#                      * increase the portability by transformation of the
#                        unique AWK program in a SHELL script calling an
#                        AWK program :
#                          - the program is renamed form piecharts.awk to
#                            piechart.sh
#                          - input data file now given as parameter, not as
#                            standard input
#                          - the parameters are obtained in the SHELL script
#                          - the options (SCALE, FIGURE and BOXIT) are now
#                            treated by post-processing the AWK output file by
#                            SED (ugly but it's because some AWK versions
#                            doesn't accept the definition of external
#                            variables...)
#                      * change the unit for the values of the parts
#                        from fractions of 360 degrees to percentages
#                      * definition of the figure environment now optional,
#                        using the FIGURE option
#                      * new possibility to declare some explode parts in the
#                        piechart
#                      * use of the new \uput PSTricks macro for easy
#                        treatment of explode parts
#                      * possibility to have multiple (centered) line labels
#                        (inside and outside labels)
#                      * better tracking of syntax errors in the command line
#                   (12/11/92) - rev. 2.1:
#                      * generation of the tabular environment for labels only
#                        if they have multi-lines
#                      * the comment lines which begin with the ## are copied
#                        (without the ##) at the beginning of the result file.
#                        This allow automatic generation of input data file
#                        with a good specification of the colors, by automatic
#                        generation of the \newgray commands. It's to work in
#                        conjonction with the piecharts-data.sh script.
#                      * input data file read on the standard input
#                      * diminution of the width of the minipage to avoid
#                        the "overfull \hbox" problems
#                      * change the test of the sum of percentages from 100 to
#                        100.0001, because it can occurs problem with 100...
#                   (01/26/93) - rev. 2.2:
#                      * suppression of lines longer than 78 characters
#                      * change the obsolete \Polar PSTricks order to
#                        \SpecialCoor
#                      * add the PLAIN option and the possibility to generate
#                        plain TeX code
#                   (03/28/96) - rev. 2.2a:
#                      * changed break to continue in test for comment
#                        lines for compatibility with newer versions of
#                        awk and gawk

# Interpretation of the parameters
if [ $# -gt 3 ]
   then echo "You cannot give more than 3 parameters."
        echo "Syntax: piechart.sh [scale factor] ([PLAIN] | [FIGURE] \
[BOXIT]) <data_file  >out_file"
        exit
fi

SCALE=1
FIGURE="xx"
BOXIT="xx"
TEX="LATEX"
while [ $# -ne 0 ]
  do if [ $1 = "BOXIT" ] || [ $1 = "boxit" ]
        then BOXIT="BOXIT"
        elif [ $1 = "FIGURE" ] || [ $1 = "figure" ]
              then FIGURE="FIGURE"
              elif [ $1 = "PLAIN" ] || [ $1 = "plain" ]
                   then TEX="PLAIN"
                   else SCALE=$1
     fi
     shift
done

# Verifications for the plain TeX mode
if [ $TEX = "PLAIN" ] && [ $BOXIT = "BOXIT" ]
   then echo "You cannot give the BOXIT parameter in PLAIN TEX mode."
        exit
fi
if [ $TEX = "PLAIN" ] && [ $FIGURE = "FIGURE" ]
   then echo "You cannot give the FIGURE parameter in PLAIN TEX mode."
        exit
fi

# Beginning of the AWK program
awk '
BEGIN{FS="|"                              # Fields separator
      PARAM="NO"
      BEGIN_VALUE=0
      END_VALUE=0
      TOTAL_PERCENT=0
      #   Definition of a figure environment (if FIGURE is not use, this line
      # will be remove later - ugly but it is because some AWK versions does
      # not accept the definition of external variables...)
      # if FIGURE
        print "%figure\\begin{figure}[htbp]"
      #   Framebox around the figure, (if BOXIT is not use, this line will be
      # remove later)
      # if BOXIT
        print "%boxit  \\psframebox[framesep=8mm]{"
      print "%latex  {\\addtolength{\\textwidth}{-2.3cm}"
      print "%latex   \\begin{minipage}{\\textwidth}"
      print "%latex    \\begin{center}"
      # if FIGURE
        print "%figure     \\vspace{6mm}"
      print "%latex     {\\setlength{\\tabcolsep}{0cm}"
      print "%tex     {%"
      print "      \\psset{unit=cm,xunit=cm,yunit=cm}"
      print "%latex      \\begin{pspicture}(-2,-2)(2,2)"
      print "        \\SpecialCoor"
      print "%tex      \\pspicture(-2,-2)(2,2)"
      print "%tex      \\def\\PieLabel\#1{\\vbox{\\halign{\\hfil\#\#"\
"\\hfil\\cr\#1\\cr}}}%"
      print "        \\psset{framesep=1.5pt}"
      }

{
 # Suppression of the right and left blanks of the variables
 for (I=1;I<=NF+1;I++) {
     # On the left...
     for (J=1;J<=length($I)+1;J++)
         if (substr($I,1,1) == " ")
            $I=substr($I,2)
          else
            break
     # On the right...
     for (J=length($I);J>0;J--)
         if (substr($I,J,1) == " ")
            $I=substr($I,1,J-1)
          else
            break
 }

 #   Special comments before title (beginning by ##): they are copied
 # at the beginning of the result file, without the ##
 if (substr($1,1,2) == "##")
    print substr($1,3,length($1))

 # Comments, null and blank lines
 if (substr($1,1,1) == "#" || $1 == "" || $1 == " ")
    continue

 if (PARAM == "NO") {
     #   Generic parameters: title, title for the table of figures, label
     # (the last two are optional)
     PARAM="YES"
     TITLE=$1
     TABLE_TITLE=$2
     LABEL=$3}
   else {
     # Verification of the sum of the parts
     TOTAL_PERCENT=TOTAL_PERCENT+$1
     if (TOTAL_PERCENT > 100.0001) {
        print "Error! Total of percentages greater than 100! (" \
              TOTAL_PERCENT ")"
        exit}
     # Transformation of percentages in fractions of 360 degrees
     $1=$1*3.6
     END_VALUE=END_VALUE+$1
     VAL=BEGIN_VALUE+$1/2
     #Explode part
     if ($6 == "YES" || $6 == "yes")
         print "       \\uput{0.3}[" VAL "](0;0){"
     print "        \\pswedge[fillstyle=" $4 ",fillcolor=" $5 "]{2}{" \
           BEGIN_VALUE "}{" END_VALUE "}"
     # Inside label
     if ($2 != "") {
        print "%tex        \\rput(1.2;" VAL "){\\psframebox*{\\PieLabel{" \
$2 "}}}"
        if (index($2,"\\\\") == 0)
           print "%latex        \\rput(1.2;" VAL "){\\psframebox*{" $2 "}}"
         else {
           print "%latex        \\rput(1.2;" VAL \
                 "){\\psframebox*{\\begin{tabular}{c}"
           print "%latex                                      " $2
           print "%latex                                    \\end{tabular}}}"
           }
        }
     # Outside label
     if ($3 != "") {
        print "%tex        \\uput{2.2}[" VAL "](0;0){\\PieLabel{" $3 "}}"
        if (index($3,"\\\\") == 0)
           print "%latex        \\uput{2.2}[" VAL "](0;0){" $3 "}"
         else {
           print "%latex        \\uput{2.2}[" VAL "](0;0){\\begin{tabular}{c}"
           print "%latex                               " $3
           print "%latex                             \\end{tabular}}"
           }
        }
     # End of explode treatment
     if ($6 == "YES" || $6 == "yes")
        print "       }"
     BEGIN_VALUE=END_VALUE}
 $1=""
}

END{
    print "%latex      \\end{pspicture}"
    print "%tex      \\endpspicture"
    print "     }"
    # For the case of a multiple line outside label at the bottom...
    # if FIGURE
      print "%figure     \\vspace{4mm}"
    print "%latex    \\end{center}"
    # if FIGURE
      if (TABLE_TITLE == "")
         print "%figure  \\caption{" TITLE "}"
       else
         print "%figure  \\caption[" TABLE_TITLE "]{" TITLE "}"
      if (LABEL != "")
         print "%figure  \\label{f:" LABEL "}"
    print "%latex   \\end{minipage}"
    print "%latex  }"
    # if BOXIT
      print "%boxit }"
    # if FIGURE
      print "%figure\\end{figure}"
      }' >/tmp/piechart.tmp

#   Post-processing for the "scale factor", PLAIN, FIGURE and BOXIT parameters
# (ugly but it's because some AWK versions doesn't accept the definition
#  of external variables...)
if [ $FIGURE = "FIGURE" ]
   then sed -e /unit=/s/unit=/unit=$SCALE/g -e /\^%figure/s/// \
            /tmp/piechart.tmp >/tmp/piechart.tmp2
   else sed -e /unit=/s/unit=/unit=$SCALE/g -e /\^%figure/d \
            /tmp/piechart.tmp >/tmp/piechart.tmp2
fi
mv /tmp/piechart.tmp2 /tmp/piechart.tmp
if [ $BOXIT = "BOXIT" ]
   then sed -e /\^%boxit/s/// /tmp/piechart.tmp >/tmp/piechart.tmp2
   else sed -e /\^%boxit/d    /tmp/piechart.tmp >/tmp/piechart.tmp2
fi

# plain TeX or LaTeX mode
mv /tmp/piechart.tmp2 /tmp/piechart.tmp
if [ $TEX = "LATEX" ]
   then sed -e /\^%tex/d      /tmp/piechart.tmp >/tmp/piechart.tmp2
        mv /tmp/piechart.tmp2 /tmp/piechart.tmp
        sed -e /\^%latex/s/// /tmp/piechart.tmp >/tmp/piechart.tmp2
   else sed -e /\^%latex/d    /tmp/piechart.tmp >/tmp/piechart.tmp2
        mv /tmp/piechart.tmp2 /tmp/piechart.tmp
        sed -e /\^%tex/s///   /tmp/piechart.tmp >/tmp/piechart.tmp2
fi

# Deliver of the result!
cat /tmp/piechart.tmp2

rm /tmp/piechart.tmp /tmp/piechart.tmp2

