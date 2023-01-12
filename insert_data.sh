#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
echo "$($PSQL "TRUNCATE TABLE games, teams")"
echo "$($PSQL "ALTER SEQUENCE teams_team_id_seq RESTART WITH 1")"
echo "$($PSQL "ALTER SEQUENCE games_game_id_seq RESTART WITH 1")"
cat games.csv | while IFS=',' read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  #inserting winner into teams
  if [[ $WINNER != 'winner' ]]
  then
      #get winner id
      WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$WINNER'")
      #check if winner id in teams
      if [[ -z $WINNER_ID ]]
      then
        echo "$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")"
      fi
  fi
  #inserting opponent into teams
  if [[ $OPPONENT != 'opponent' ]]
  then
      #get opponent id
      OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$OPPONENT'")
      #check if winner id in teams
      if [[ -z $OPPONENT_ID ]]
      then
        echo "$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")"
      fi
  fi
#inserting games into games
#get winner and opponent id
WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$WINNER'")
OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$OPPONENT'")
#inserting values
echo "$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES('$YEAR', '$ROUND', '$WINNER_ID', '$OPPONENT_ID', '$WINNER_GOALS', '$OPPONENT_GOALS')")"

 
done



