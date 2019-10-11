# SHELL SCRIPT FOR PREPARING input.txt FOR IOPC

# OPTIONS TAKEN FROM fort.5 and fort.1

# NMOL=$(head  fort.5 -n 5 | tail -n 1 | awk '{print $1}')
# NATOM=$(tail fort.5 -n 1 | awk '{print $1}')

# FINDING PRINT OPTIONS
TRJ_PRINT=$(awk '/trj_print:/{getline; print}' fort.1)
STEPS=$(awk '/number_of_steps:/{getline; print}' fort.1)
NCONF=$(python3 -c "int(${STEPS}//${TRJ_PRINT}+2)")

rm -f input.txt
# WRITING input.txt
echo "1"       >> input.txt
python3 ${PYTHON_PATH}/find_mol_nr.py 4 #python
echo "1"       >> input.txt
echo "$NPROC"  >> input.txt
