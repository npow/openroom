#!/bin/bash
ROOT=~npow/public_html/code/openroom/src
CURL=`which curl`
JAVA=`which java`
TIDY=$ROOT/bin/tidy
SAXON=$ROOT/bin/saxon9.jar
XSL_FILE=$ROOT/etc/parse.xsl

# TODO:
# - Use mktemp for $TMPDIR
# - Get $SESS and $LEVEL via cmdline args
# - Check if $TMPDIR or $OUT_FILE exists before removing
# - Cleanup $TMPDIR upon exit
# - Fetch "grad" schedules as well

##### VARIABLES #####
SESS="1099"
LEVEL="under"
OUT_FILE="$ROOT/$SESS.scm"
TMPDIR=/tmp/npow/uwrf/$SESS/$LEVEL

##### CONSTANTS #####
URL="http://www.adm.uwaterloo.ca/cgi-bin/cgiwrap/infocour/salook.pl"
COURSES="
AB
ACC
ACTSC
ADMGT
AFM
AMATH
ANTH
APPLS
ARBUS
ARCH
ARCHL
ARTS
BET
BIOL
BUS
CHE
CHEM
CHINA
CIVE
CLAS
CM
CMW
CO
COGSCI
COMM
COMST
COOP
CROAT
CS
CT
DAC
DM
DRAMA
DUTCH
EARTH
EASIA
ECE
ECON
ELPE
ENBUS
ENGL
ENVE
ENVS
ERS
ESL
FILM
FINE
FR
GENE
GEOE
GEOG
GER
GERON
GLOBAL
GRK
GS
HIST
HLTH
HRM
HSG
HUMSC
INDEV
INTEG
INTST
INTTS
IS
ISS
ITAL
ITALST
JAPAN
JS
KIN
KOREA
KPE
LAT
LED
LS
MATH
ME
MSCI
MTE
MTHEL
MUSIC
NATST
NE
NES
OPTOM
PACS
PD
PDENG
PHARM
PHIL
PHS
PHYS
PLAN
PMATH
POLSH
PORT
PSCI
PSYCH
REC
REES
RELC
RS
RUSS
SCBUS
SCI
SE
SMF
SOC
SOCWK
SPAN
SPCOM
SPD
STAT
STV
SWREN
SYDE
TAX
TOUR
TPM
TS
UN
WHMIS
WKRPT
WS
"

##### MAIN #####
rm -rf $TMPDIR
mkdir -p $TMPDIR

echo "(define classes '(" > $OUT_FILE
for course in $COURSES; do
    $CURL -s -d "sess=$SESS&subject=$course&level=$LEVEL" $URL > $TMPDIR/$course.html
    grep 'query had no matches' $TMPDIR/$course.html > /dev/null
    if [[ $? -eq 1 ]]; then
        $TIDY -asxhtml -m -q -f /dev/null $TMPDIR/$course.html 
        $JAVA -jar $SAXON -xsl:$XSL_FILE -s:$TMPDIR/$course.html >> $OUT_FILE
    fi
done
echo "))" >> $OUT_FILE

echo "Output file: $OUT_FILE"

#rm -rf $TMPDIR
