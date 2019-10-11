# Inputs                                                                                                                                                                   
option="$1"
value="$2"

# CHECK IF OPTION IS PRESENT                                                                                                                                             
if [[ $(grep "$option" fort.1) ]] ; then
    # IS PRESENT
    sed -i "/${option}/{n;s/.*/$value/}" fort.1
else
    # NOT PRESENT
    sed -i "/^endinput:/i ${option}\n${value}" fort.1
fi



