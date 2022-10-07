#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.


echo $($PSQL "TRUNCATE games, teams")

# Insert into teams

cat games.csv | while IFS=, read -r YEAR ROUND TEAM1 TEAM2 GOAL1 GOAL2
do
  if [[ $TEAM1 != winner ]]
  then
    TEAM1_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$TEAM1';")
    TEAM2_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$TEAM2';")

    if [[ -z $TEAM1_ID ]]
    then
      INSERT_TEAM1_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$TEAM1');")
      if [[ $INSERT_TEAM1_RESULT == "INSERT 0 1" ]]
      then
        echo Inserted into teams, $TEAM1
      fi

    fi
    if [[ -z $TEAM2_ID ]]
    then
      INSERT_TEAM2_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$TEAM2');")
      if [[ $INSERT_TEAM2_RESULT == "INSERT 0 1" ]]
      then
        echo Inserted into teams, $TEAM2
      fi

    fi

    TEAM1_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$TEAM1';")
    TEAM2_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$TEAM2';")
    INSERT_GAME=$($PSQL "INSERT INTO games(year, round, winner_id, winner_goals, opponent_id, opponent_goals) VALUES('$YEAR', '$ROUND', '$TEAM1_ID', '$GOAL1', '$TEAM2_ID', '$GOAL2');")
  fi



      

done
