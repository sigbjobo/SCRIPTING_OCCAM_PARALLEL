# BASH SCRIPT FOR SETTING PATHS ON A CLUSTER

#Sets path for scripts
A=$(pwd)
SHELL_PATH="${A}/shell"
PYTHON_PATH="${A}/python"

OCCAM_PATH="${A}/../occam_parallel/"
JOB_PATH="${A}/jobscripts"
IOPC_PATH="${A}/IOPC"

#FIX SHELL SCRIPTS
sed -i 's|PYTHON_PATH=.*|PYTHON_PATH="'"$PYTHON_PATH"'"|g' ${SHELL_PATH}/*.sh
sed -i 's|SHELL_PATH=.*|SHELL_PATH="'"$SHELL_PATH"'"|g' ${SHELL_PATH}/*.sh
sed -i 's|OCCAM_PATH=.*|OCCAM_PATH="'"$OCCAM_PATH"'"|g' ${SHELL_PATH}/*.sh
sed -i 's|IOPC_PATH=.*|IOPC_PATH="'"$IOPC_PATH"'"|g' ${SHELL_PATH}/*.sh


#FIX JOB SCRIPTS
sed -i 's|PYTHON_PATH=.*|PYTHON_PATH="'"$PYTHON_PATH"'"|g' ${JOB_PATH}/*.sh
sed -i 's|SHELL_PATH=.*|SHELL_PATH="'"$SHELL_PATH"'"|g' ${JOB_PATH}/*.sh
sed -i 's|OCCAM_PATH=.*|OCCAM_PATH="'"$OCCAM_PATH"'"|g' ${JOB_PATH}/*.sh
sed -i 's|IOPC_PATH=.*|IOPC_PATH="'"$IOPC_PATH"'"|g' ${JOB_PATH}/*.sh
sed -i '/\export NPROC=/c\\export NPROC=${SLURM_NTASKS}' ${JOB_PATH}/*.sh



#FIX PYTHON SCRIPTS
sed -i 's|PYTHON_PATH=.*|PYTHON_PATH="'"$PYTHON_PATH"'"|g' ${PYTHON_PATH}/*.py
sed -i 's|SHELL_PATH=.*|SHELL_PATH="'"$SHELL_PATH"'"|g' ${PYTHON_PATH}/*.py
sed -i 's|OCCAM_PATH=.*|OCCAM_PATH="'"$OCCAM_PATH"'"|g' ${PYTHON_PATH}/*.py


#SPECIFIC TO FIXING JOBSCRIPT ON STALLO AND FRAM

#SAGA
if [ $(uname -n) = "login-2" ] 
then
    sed -i '/module load FFTW*/c\module load FFTW/3.3.8-intel-2019a' ${JOB_PATH}/*.sh
    sed -i '/module load intel*/c\module load intel/2018b' ${JOB_PATH}/*.sh
    sed -i '/\#SBATCH --ntasks=/c\\#SBATCH --nodes=4 --ntasks-per-node=40' ${JOB_PATH}/*.sh
    sed -i '/\#SBATCH --nodes=/c\\#SBATCH --nodes=4 --ntasks-per-node=40' ${JOB_PATH}/*.sh
    sed -i '/module load Python*/c\module load Python/3.6.6-intel-2018b' ${JOB_PATH}/*.sh 
    sed -i '/module load python*/c\module load Python/3.6.6-intel-2018b' ${JOB_PATH}/*.sh 
fi

#STALLO
if [ "$(uname -n)" = "stallo-1.local" ] 
then
    sed -i '/module load FFTW*/c\module load FFTW/3.3.7-intel-2018a' ${JOB_PATH}/*.sh
    sed -i '/module load intel*/c\module load intel/2018b' ${JOB_PATH}/*.sh
    sed -i '/\#SBATCH --nodes=/c\\#SBATCH --ntasks=192' ${JOB_PATH}/*.sh
    sed -i '/module load Python*/c\module load Python/3.7.0-intel-2018b' ${JOB_PATH}/*.sh 
    sed -i '/module load python*/c\module load Python/3.7.0-intel-2018b' ${JOB_PATH}/*.sh 
fi
   
# if [ $(pwd | grep /usit/abel | wc | awk '{print $1}') -gt 0 ] 
# then
#     sed -i '/module load FFTW*/c\module load FFTW' ${JOB_PATH}/*.sh
#     sed -i '/module load intel*/c\module load intel/2019.1' ${JOB_PATH}/*.sh
#     sed -i '/\#SBATCH --ntasks=/c\\#SBATCH --nodes=3 --ntasks-per-node=16' ${JOB_PATH}/*.sh
#     sed -i '/\#SBATCH --nodes=/c\\#SBATCH --nodes=3 --ntasks-per-node=16' ${JOB_PATH}/*.sh
#     sed -i '/module load Python*/c\module load python3/3.7.0' ${JOB_PATH}/*.sh
#     sed -i '/module load python*/c\module load python3/3.7.0' ${JOB_PATH}/*.sh 
# fi
