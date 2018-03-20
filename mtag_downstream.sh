#/bin/bash!

#PBS -l walltime=06:00:00
#PBS -l select=1:ncpus=4:mem=64gb
#PBS -q med-bio
#PBS -k oe

module load anaconda3/personal

DIR=/home/ds711/Heart_mtag/mtag_results/

INT=($(find ${DIR} -type f -name "mtag_res_trait*.txt"))

DOC1=${INT[0]}
DOC2=${INT[1]}

DOC1=$(realpath $DOC1)
DOC2=$(realpath $DOC2)

echo "${DOC1}"
echo "${DOC2}"


python /home/ds711/mtag/mtag_downstream1.py -n "${DOC1}" -d ${DIR}
python /home/ds711/mtag/mtag_downstream1.py -n "${DOC2}" -d ${DIR}

##module load R/3.4.0
source activate R342

Rscript -e "chooseCRANmirror(graphics=FALSE,ind=53);source('https://bioconductor.org/biocLite.R');biocLite('biomaRt',suppressUpdates=FALSE,suppressAutoUpdate=FALSE,ask=F)"

IN=${DIR}/mtag_res_trait_1.csv
OUT=${DIR}/mtag_res_trait_1_annot.csv
Rscript /home/ds711/mtag/annot_mtag.r ${IN} ${OUT} 


IN=${DIR}/mtag_res_trait_2.csv
OUT=${DIR}/mtag_res_trait_2_annot.csv
Rscript /home/ds711/mtag/annot_mtag.r ${IN} ${OUT}

