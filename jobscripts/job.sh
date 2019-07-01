#!/bin/bash
#SBATCH --job-name=JOB_NAME
#SBATCH --account=nn4654k
#SBATCH --time=0-1:0:0
#SBATCH --mem-per-cpu=2G
#SBATCH --nodes=4 --ntasks-per-node=40
##SBATCH --qos=devel

# MANDATORY SETTINGS

export INPUT_PATH=$(pwd) # FOLDER CONTAINING ONLY fort.1, fort.3 and fort.5
export NPROC=${SLURM_NTASKS}
export LMOD_DISABLE_SAME_NAME_AUTOSWAP=no

######################################################################
# OPTIONAL SETTINGS (COMMENT OUT IF NOT DESIRED)

NEQUIL=1500        # NUMBER OF EQUILIBRATION STEPS
NSTEPS=15000       # NUMBER OF SAMPLING STEPS
NTRAJ=2500         # SAMPLING PERIOD FOR TRAJECTORY 
FIX_INPUT=1        # FIX CELLS AND 
LAT_UPD=20         # NUMBER OF STEPS BETWEEN LATTICE UPDATES
POT_UPD=10000      # NUMBER OF STEPS BETWEEN POTENTIAL UPDATE
OUT_PRINT=10000    # NUMBER OF STEPS BETWEEN fort.7 PRINTOUT
######################################################################

# EXPORTED DIRECTORIES, EITHER SET MANUALLY OR USE bash set_paths.sh


export SHELL_PATH="/cluster/home/sigbjobo/SCRIPTING_OCCAM_PARALLEL/shell"
export PYTHON_PATH="/cluster/home/sigbjobo/SCRIPTING_OCCAM_PARALLEL/python"
export OCCAM_PATH="/cluster/home/sigbjobo/SCRIPTING_OCCAM_PARALLEL/../occam_parallel/"


# OPTION FOR COMPILATION OF OCCAM AND IOPC

export COMPILE=0


# PATHS FOR SIMULATION AND SUBMIT DIRECTORY

SCRATCH_DIRECTORY=${SCRATCH}
SLURM_SUBMIT_DIR=$(pwd)


#LOADED MODULES
#module purge
module load intel/2018b
module load FFTW/3.3.8-intel-2019a
module load Python/3.6.6-intel-2018b

#################################################
# EXTRA ARGUMENTS CAN EASILY BE INCORPORATED BY:

# parameter1=$1 # etc
#################################################


# PREPARE SIMULATION DIRECTORY

mkdir -p ${SCRATCH_DIRECTORY}
cd ${SCRATCH_DIRECTORY}


#MAKE A SIMULATION-FOLDER 

folder=SIM
mkdir ${SLURM_SUBMIT_DIR}/${folder}
#mkdir ${folder}
#cd ${folder}



#COPY INPUT-FILES
cp -r ${INPUT_PATH}/{fort.3,fort.1} .

# REMOVE COMMENTS TO TEST
python ${PYTHON_PATH}/make_syst.py ${INPUT_PATH}/triton.5 100 10000 10
mv fort_new.5 fort.5


#######################################################
# OPTIONAL, BUT USEFUL COMMANDS FOR FIXING INPUT-FILES

# COMMANDS ARE ONLY PERFORMED IF DEFINIED

#SET NUMBER OF CELLS FOR FORT.3 FILE
if [ ! -z  "$FIX_INPUT"  ]
then
    L=$(head  fort.5 -n 2 | tail -n 1 | awk '{print $1}')
    M=$(python -c "print(int($L / 0.67))")
    sed -i "s/MM/$M/g" fort.3
    N=$(tail fort.5 -n 1 | awk '{print $1}')
    sed -i "s/NATOMS/$N/g"                       fort.1
fi

test ! -z "$NSTEPS"    && sed -i "/number_of_steps:/{n;s/.*/$NSTEPS/}" fort.1
test ! -z "$POT_UPD"   && sed -i "/pot_calc_freq:/{n;s/.*/$POT_UPD/}" fort.1
test ! -z "$LAT_UPD"   && sed -i "/SCF_lattice_update:/{n;s/.*/$LAT_UPD/}"   fort.1
test ! -z "$NTRAJ"     && sed -i "/trj_print:/{n;s/.*/$NTRAJ/}"        fort.1
test ! -z "$OUT_PRINT" && sed -i "/out_print:/{n;s/.*/$OUT_PRINT/}"         fort.1

# INITIAL SIMULATION FOR EQUILIBRATING

if [ ! -z "$NEQUIL" ]
then
    echo   "Running equilibration simulation"
    sed -i "/number_of_steps:/{n;s/.*/$NEQUIL/}" fort.1
    bash ${SHELL_PATH}/run_para.sh
    mv fort.8 equil.xyz
    cp fort.5 pre_equil.5
    cp fort.9 fort.5
    sed -i "/number_of_steps:/{n;s/.*/$NSTEPS/}" fort.1
fi

########################################################

# RUN SIMULATION

bash ${SHELL_PATH}/run_para.sh
mv fort.8 sim.xyz

# MOVE SIMULATION DATA BACK TO SUBMIT FOLDER

cp -r ${SCRATCH_DIRECTORY}/* ${SLURM_SUBMIT_DIR}/${folder}/

exit 0
