#!/bin/bash -l

CURRENT_DIREC=$(pwd)
 
#COMPILE OCCAM AND IOPC
if [ "$COMPILE" == "1" ]
then
    echo "COMPILING"
    cd ${OCCAM_PATH}
    rm -f *.o
    rm -f *.mod
    bash compile_extra.sh
    make
    cd  ${OCCAM_PATH}/IOPC_input
    bash compile.sh
    make
fi

cd ${CURRENT_DIREC}/
#REMOVE FILES THAT CAN INTERFERE WITH OCCAM
rm -f fort.[1-9][0-9]
rm -f fort.7 fort.2  fort.8 

cp ${OCCAM_PATH}/occamcgmpi ${CURRENT_DIREC}/
cp ${OCCAM_PATH}/IOPC_input/iopc ${CURRENT_DIREC}/

#PREPARE IOPC FORWARD
cp fort.5 fort.10
bash ${SHELL_PATH}/prep_iopc1.sh

#RUN IOPC FORWARD
${OCCAM_PATH}/IOPC_input/iopc
rm -f fort.10 fort.7

#Run OCCAM in parallel 
start=`date +%s`
srun --mpi=pmi2 -n ${NPROC} occamcgmpi
end=`date +%s`
t1=$((end-start))
echo "SIMULATION-TIME: $t1 SECONDS"


#PREPARE IOPC BACK
bash ${SHELL_PATH}/prep_iopc2.sh

#RUN IOPC BACK
${OCCAM_PATH}/IOPC_input/iopc

#MAKE A NEW FORT.9 FILE 
python ${PYTHON_PATH}/remake_fort9.py

#REMOVE START FILES FOR PARALLEL VERSION
rm -f fort.[1-9][0-9][0-9]
rm -f fort.[2-9][0-9]
rm input.txt
end2=`date +%s`
t2=$((end2-end))
echo "IOPC-TIME: $t2 SECONDS"
