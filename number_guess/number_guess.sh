#!/bin/bash

PSQL="psql -X --username=freecodecamp --dbname=ng --tuples-only -c"

MAIN_MENU() {

  for (( ; ; ))
  do
    echo -e "Enter your username:"
    read USERNAME
    if [ ${#USERNAME} -le 22 ]
    then
      break
    fi
  done

  USERDETAILS=$($PSQL "SELECT username,total,best FROM users WHERE username='$USERNAME'")

  if [[ -z $USERDETAILS ]]
  then
    echo "Welcome, $USERNAME! It looks like this is your first time here."
    PLAY_GAME $USERNAME 0
  else
    UT=$($PSQL "SELECT total FROM users WHERE username='$USERNAME'")
    UB=$($PSQL "SELECT best FROM users WHERE username='$USERNAME'")
    echo "$USERDETAILS" | while read USERNAMEB BAR TOTALGAMES BAR BESTGAME
    do
      echo "Welcome back, $USERNAME! You have played $TOTALGAMES games, and your best game took $BESTGAME guesses."
    done
    PLAY_GAME $USERNAME $UT $UB
  fi
}

PLAY_GAME() {
  RANDOM_NUMBER=$(( $RANDOM % 1000 + 1 ))
  TRIES=0
  echo "Guess the secret number between 1 and 1000:"
  for (( ; ; ))
  do
  
    read USERINPUT

    if ! [[ "$USERINPUT" =~ ^[0-9]+$ ]]
    then
      echo "That is not an integer, guess again:"
      continue
    fi

    if [[ $USERINPUT -eq $RANDOM_NUMBER ]]
    then
      TRIES=$(( $TRIES + 1 ))
      break
    fi

    if [[ $USERINPUT -ge $RANDOM_NUMBER ]]
    then
      echo "It's lower than that, guess again:"
      TRIES=$(( $TRIES + 1 ))
    fi

    if [[ $USERINPUT -le $RANDOM_NUMBER ]]
    then
      echo "It's higher than that, guess again:"
      TRIES=$(( $TRIES + 1 ))
    fi    
  done

  UN=$1
  T=$2
  B=$3

  if [[ $T -eq 0 ]]
  then
    INSERTNEW=$($PSQL "INSERT INTO users(username,total,best) VAlUES('$UN',1,$TRIES)")
  else
    if [[ $TRIES -lt $B ]]
    then
      insert=$($PSQL "UPDATE users SET total=$(( $T +  1)),best=$TRIES WHERE username='$UN'")
    else
      insert=$($PSQL "UPDATE users SET total=$(( $T +  1)) WHERE username='$UN'")
    fi
  fi
  
  echo "You guessed it in $TRIES tries. The secret number was $RANDOM_NUMBER. Nice job!"
  exit
}

#PLAY_GAME
MAIN_MENU