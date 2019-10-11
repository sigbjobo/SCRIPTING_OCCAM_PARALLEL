#!/bin/bash -l

CURRENT_DIREC=$(pwd)
 
#COMPILE OCCAM AND IOPC
if [ "$COMPILE" == "1" ]
then
    echo "COMPILING OCCAM"
    cd ${OCCAM_PATH}
    rm -f *.o
    rm -f *.mod
    bash compile_extra.sh
    make -j$NPROC
    
    echo "COMPILING IOPC"
    cd  ${IOPC_PATH}/IOPC_input
    bash compile.sh 
    make -j$NPROC
    
    export COMPILE=0
fi

cd ${CURRENT_DIREC}/

#REMOVE FILES THAT CAN INTERFERE WITH OCCAM
rm -f fort.[1-9][0-9]
rm -f fort.7 fort.2  fort.8 

cp ${OCCAM_PATH}/occamcgmpi ${CURRENT_DIREC}/
cp $IOPC_PATH/iopc ${CURRENT_DIREC}/

#PREPARE IOPC FORWARD
cp fort.5 fort.10
bash ${SHELL_PATH}/prep_iopc1.sh

#RUN IOPC FORWARD
${OCCAM_PATH}/IOPC_input/iopc
rm -f fort.10 fort.7


#Run OCCAM in parallel 
start=`date +%s`
rm -f srun.err
srun --mpi=pmi2 -K  --error=srun.err occamcgmpi 
end=`date +%s`
t1=$((end-start))
echo "SIMULATION-TIME: $t1 SECONDS"


#PREPARE IOPC BACK
bash ${SHELL_PATH}/prep_iopc2.sh

#RUN IOPC BACK
${OCCAM_PATH}/IOPC_input/iopc

#MAKE A NEW FORT.9 FILE 
python3 ${PYTHON_PATH}/remake_fort9.py

#REMOVE START FILES FOR PARALLEL VERSION
rm -f fort.[1-9][0-9][0-9][0-9]
rm -f fort.[1-9][0-9][0-9]
rm -f fort.[2-9][0-9]
rm -f fort.15 


end2=`date +%s`
t2=$((end2-end))
echo "IOPC-TIME: $t2 SECONDS"
