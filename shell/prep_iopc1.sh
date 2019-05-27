# SHELL SCRIPT FOR PREPARING input.txt FOR IOPC

# TO USE SCRIPT EXPORT THE FOLLOWING VARIABLES IN JOBSCRIPT
# NPROC

# OPTIONS TAKEN FROM fort.5 and fort.1

# FINDING NUMBER OF MOLECULES AND ATOMS


# NMOL=$(head  fort.5 -n 5 | tail -n 1 | awk '{print $1}')
# NATOM=$(tail fort.5 -n 1 | awk '{print $1}')

# FINDING PRINT OPTIONS
TRJ_PRINT=$(awk '/trj_print:/{getline; print}' fort.1)
STEPS=$(awk '/number_of_steps:/{getline; print}' fort.1)
NCONF=$(python -c "int(${STEPS}//${TRJ_PRINT}+2)")

# WRITING input.txt
rm -f input.txt

echo "1"       >> input.txt
python ${PYTHON_PATH}/find_mol_nr.py 4 #python
# echo "$NMOL"   >> input.txt
# echo "$NATOM"  >> input.txt
# echo "$NMOLA"  >> input.txt
# echo "$NATOMA" >> input.txt
# echo "$NMOLB"  >> input.txt
# echo "$NATOMB" >> input.txt
# echo "$NMOLC"  >> input.txt
# echo "$NATOMC" >> input.txt
# echo "$NMOLD"  >> input.txt
# echo "$NATOMD" >> input.txt
echo "1"       >> input.txt
echo "$NPROC"  >> input.txt



# echo "$NPROC" 
# echo "1"      
# echo "$NMOL"  
# echo "$NATOM" 
# echo "$NMOLA" 
# echo "$NATOMA"
# echo "$NMOLB" 
# echo "$NATOMB"
# echo "$NMOLC" 
# echo "$NATOMC"
# echo "$NMOLD" 
# echo "$NATOMD"
# echo "1"      
# echo "$NPROC" 
 
