PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

#check for element via atomic number
if [[ $1 =~ ^[0-9]+$ ]]; then
  ELEMENT=$($PSQL "SELECT atomic_number FROM elements WHERE atomic_number = $1")
else
  #check for element via symbol or name
  if [[ ${#1} -le 2 ]]; then
    ELEMENT=$($PSQL "SELECT atomic_number FROM elements WHERE symbol = '$1'")
  else
    ELEMENT=$($PSQL "SELECT atomic_number FROM elements WHERE name = '$1'")
  fi
fi

#retrieve resources with ELEMENT and failed input message
if [[  -z $ELEMENT ]]; then
    echo "I could not find that element in the database."
    exit
else
  #ELEMENT Variables here
  A_NUM=$($PSQL "SELECT atomic_number FROM elements WHERE atomic_number = $ELEMENT")
  SYMBOL=$($PSQL "SELECT symbol FROM elements WHERE atomic_number = $ELEMENT")
  NAME=$($PSQL "SELECT name FROM elements WHERE atomic_number = $ELEMENT")
  TYPE_ID=$($PSQL "SELECT type_id FROM properties WHERE atomic_number = $ELEMENT")
  TYPE=$($PSQL "SELECT type FROM types WHERE type_id = $TYPE_ID")
  A_MASS=$($PSQL "SELECT atomic_mass FROM properties WHERE atomic_number = $ELEMENT")
  MELTING_CELSIUS=$($PSQL "SELECT melting_point_celsius FROM properties WHERE atomic_number = $ELEMENT")
  BOILING_CELSIUS=$($PSQL "SELECT boiling_point_celsius FROM properties WHERE atomic_number = $ELEMENT")
  #Display element message
  echo "The element with atomic number $A_NUM is $NAME ($SYMBOL). It's a $TYPE with a mass of $A_MASS amu. $NAME has a melting point of $MELTING_CELSIUS celsius and a boiling point of $BOILING_CELSIUS celsius."
fi
