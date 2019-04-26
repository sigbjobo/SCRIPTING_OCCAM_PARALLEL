TIME_STEP=$(awk '/time_step:/{getline; print}' fort.1)
TRJ_PRINT=$(awk '/trj_print:/{getline; print}' fort.1)
STEPS=$(awk '/number_of_steps:/{getline; print}' fort.1)
NCONF=$(python -c "print(int(${STEPS}//${TRJ_PRINT}+2))")

rm input.txt
echo "2"          >>input.txt
echo "$NPROC"     >> input.txt
echo "0"          >> input.txt
echo "$TIME_STEP" >> input.txt
echo "${NCONF}"   >> input.txt