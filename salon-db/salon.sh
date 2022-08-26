#!/bin/bash

PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"


MAIN_MENU() {

  echo -e "\n~~~~ Salon ~~~~\n"

  LIST_OF_SERVICES=$($PSQL "SELECT service_id, name FROM services")
  echo "$LIST_OF_SERVICES" | while read SERVICE_ID BAR NAME
  do
    echo "$SERVICE_ID) $NAME"
  done

  SERVICE_MENU

}
SERVICE_MENU() {
  echo -e "\nEnter service_id"
  read SERVICE_ID_SELECTED

  SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id=$SERVICE_ID_SELECTED")
  if [[ -z $SERVICE_NAME ]]
  then
    MAIN_MENU
  else
    echo -e "\nEnter phone number"
    read CUSTOMER_PHONE
    CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'")
    if [[ -z $CUSTOMER_ID ]]
    then
      echo -e "\nEnter Name"
      read CUSTOMER_NAME
      ENTER_CUSTOMER=$($PSQL "INSERT INTO customers(phone,name) VALUES('$CUSTOMER_PHONE','$CUSTOMER_NAME')")
      CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'")
    fi
    CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone='$CUSTOMER_PHONE'")
    echo -e "\nEnter appointment time"
    read SERVICE_TIME
    APPOINTMENT_CREATED=$($PSQL "INSERT INTO appointments(customer_id,service_id,time) VALUES($CUSTOMER_ID,$SERVICE_ID_SELECTED,'$SERVICE_TIME')")
    if [[ $APPOINTMENT_CREATED == "INSERT 0 1" ]]
    then
      echo -e "\nI have put you down for a $(TRIM "$SERVICE_NAME") at $SERVICE_TIME, $(TRIM $CUSTOMER_NAME)."
    fi
  fi
}
TRIM() {
  echo $1 | sed -E 's/^ *| *$//'
}
MAIN_MENU
