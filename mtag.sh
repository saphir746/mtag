#!/bin/bash
#PBS -l walltime=06:00:00
#PBS -l select=1:ncpus=4:mem=64gb
#PBS -q med-bio
###############PBS -k oe

######################################################

DOCS=/home/ds711/Heart_mtag
FILE1=cad_data.txt
FILE2=allstroke.txt
MYDIR=/home/ds711/mtag

###########################################################

module load anaconda3/personal
source activate py27
PY27=$?
if [ $PY27 -eq 1 ]; then
	conda create -n py27 python=2.7 anaconda
	source activate py27
	yes | conda install -c anaconda numpy
	yes | conda install -c anaconda scipy
	yes | conda install -c anaconda pandas
	yes | conda install -c anaconda argparse
	yes | conda install -c anaconda bitarray
	yes | conda install -c anaconda joblib
fi

DOC1=${DOCS}/${FILE1}
DOC2=${DOCS}/${FILE2}		

cp -r ${MYDIR}/* ${TMPDIR}

mkdir -p ${DOCS}/mtag_results

python mtag.py -h 
source mtag_sub.sh > mtag_sub.log
#
cp -r $TMPDIR/mtag_res* ${DOCS}/mtag_results

