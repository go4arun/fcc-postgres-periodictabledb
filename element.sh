PSQL="psql --username=freecodecamp --dbname=periodic_table --tuples-only -c"
# this part is the same for every PSQL query, so store it in a variable
PSQL_SELECTOR="SELECT atomic_number, name, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM elements INNER JOIN properties USING (atomic_number) INNER JOIN types USING (type_id)"

DISPLAY_DETAILS() {
  echo "The element with atomic number $1 is $3 ($5). It's a $7, with a mass of $9 amu. $3 has a melting point of ${11} celsius and a boiling point of ${13} celsius."
}

DISPLAY_ERROR() {
  echo I could not find that element in the database.
}

# check if an argument was provided
if [[ -z $1 ]]
then
  # if no argument was provided, show message below and exit
  echo Please provide an element as an argument.
else
  # if an argument was provided, check if it is numeric
  if [[ $1 =~ ^[0-9]+$ ]]
  then
    # if the argument is numeric, search by atomic number 
    NUMBER_SELECT_RESULT=$($PSQL "$PSQL_SELECTOR where atomic_number=$1")
    # check if result (of searching by atomic number) is empty
    if [[ -z $NUMBER_SELECT_RESULT ]]
    then
      # if result (of searching by atomic number) is empty, show error and exit
      DISPLAY_ERROR
    else
      # if result (of searching by atomic number) is not empty, show details and exit
      DISPLAY_DETAILS $NUMBER_SELECT_RESULT
    fi
  else
    # if the argument provided was non-numeric, search by symbol    
    SYMBOL_SELECT_RESULT=$($PSQL "$PSQL_SELECTOR where symbol='$1'")
    # check if result (of searching by symbol) is empty
    if [[ -z $SYMBOL_SELECT_RESULT ]]
    then
      # if result (of searching by symbol) is empty, search by name
      NAME_SELECT_RESULT=$($PSQL "$PSQL_SELECTOR where name='$1'")
      # check if result (of searching by name) is empty
      if [[ -z $NAME_SELECT_RESULT ]]
      then
        # if result (of searching by name) is empty, show error and exit
        DISPLAY_ERROR
      else
        # if result (of searching by name) is not empty, show details and exit
        DISPLAY_DETAILS $NAME_SELECT_RESULT      
      fi      
    else
      # if result (of searching by symbol) is not empty, show details and exit
      DISPLAY_DETAILS $SYMBOL_SELECT_RESULT      
    fi    
  fi
fi
