# BASH SCRIPT FOR SETTING PATHS ON A CLUSTER

#Sets path for scripts
A=$(pwd)
SHELL_PATH="${A}/shell"
PYTHON_PATH="${A}/python"
OCCAM_PATH="${A}/../occam_parallel"
JOB_PATH="${A}/jobscripts"
IOPC_PATH="${A}/IOPC"
SCRATCH_DIRECTORY="\${SCRATCH}"

#FIX JOB SCRIPTS
sed -i 's|PYTHON_PATH=.*|PYTHON_PATH="'"$PYTHON_PATH"'"|g' ${JOB_PATH}/*.sh
sed -i 's|SHELL_PATH=.*|SHELL_PATH="'"$SHELL_PATH"'"|g' ${JOB_PATH}/*.sh
sed -i 's|OCCAM_PATH=.*|OCCAM_PATH="'"$OCCAM_PATH"'"|g' ${JOB_PATH}/*.sh
sed -i 's|IOPC_PATH=.*|IOPC_PATH="'"$IOPC_PATH"'"|g' ${JOB_PATH}/*.sh


name_computer=$(uname -n)

# Stallo
if [ "$name_computer" == "stallo-1.local" ] 
then
    echo 'Fixing jobscripts to fit Stallo'
    sed -i '/module load FFTW*/c\module load FFTW/3.3.8-intel-2018b'     ${JOB_PATH}/*.sh
    sed -i '/module load fftw*/c\module load FFTW/3.3.8-intel-2018b'     ${JOB_PATH}/*.sh
    sed -i '/module load intel*/c\module load intel/2018b'               ${JOB_PATH}/*.sh
    sed -i '/module load Python*/c\module load Python/3.6.6-intel-2018b' ${JOB_PATH}/*.sh 
    sed -i '/module load python*/c\module load Python/3.6.6-intel-2018b' ${JOB_PATH}/*.sh 
fi 

# Fram
if [ "$name_computer" == "login-1-2.fram.sigma2.no" ]
then
      
    echo 'Fixing jobscripts to fit Fram'
    
    sed -i '/module load FFTW*/c\module load FFTW/3.3.8-intel-2018b'      ${JOB_PATH}/*.sh
    sed -i '/module load fftw*/c\module load FFTW/3.3.8-intel-2018b'      ${JOB_PATH}/*.sh

    sed -i '/module load intel*/c\module load intel/2018b'                ${JOB_PATH}/*.sh
    sed -i '/module load Python*/c\module load Python/3.6.6-intel-2018b'  ${JOB_PATH}/*.sh 
    sed -i '/module load python*/c\module load Python/3.6.6-intel-2018b'  ${JOB_PATH}/*.sh 
    sed -i '/\#SBATCH --ntasks-per-node=/c\\#SBATCH --ntasks-per-node=40' ${JOB_PATH}/*.sh
fi

# Saga
if [ "$name_computer" == "login-1" ] || [ "$name_computer" == "login-2" ]
then
    echo 'Fixing jobscripts to fit SAGA'
    sed -i '/module load FFTW*/c\module load FFTW/3.3.8-intel-2019a'     ${JOB_PATH}/*.sh
    sed -i '/module load fftw*/c\module load FFTW/3.3.8-intel-2019a'     ${JOB_PATH}/*.sh
    sed -i '/module load intel*/c\module load intel/2018b'               ${JOB_PATH}/*.sh
    sed -i '/module load Python*/c\module load Python/3.6.6-intel-2018b' ${JOB_PATH}/*.sh 
    sed -i '/module load python*/c\module load Python/3.6.6-intel-2018b' ${JOB_PATH}/*.sh 
fi 


#Abel
if [ "$name_computer" == "login-0-0.local" ] || [ "$name_computer" == "login-0-1.local" ]
then
    echo 'Fixing jobscripts to fit Abel'
    sed -i '/module load FFTW*/c\module load fftw/3.3.4' ${JOB_PATH}/*.sh
    sed -i '/module load fftw*/c\module load fftw/3.3.4' ${JOB_PATH}/*.sh
    sed -i '/module load intel*/c\module load intel/2019.2' ${JOB_PATH}/*.sh
    sed -i '/module load Python*/c\module load python3/3.5.0' ${JOB_PATH}/*.sh
    sed -i '/module load python*/c\module load python3/3.5.0' ${JOB_PATH}/*.sh 
    
fi


