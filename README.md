# football_api

This service provides an API used for creating and maintaining football teams and players.

# Functionality

Through this API you can create new Players and Teams, update them, delete them as well as display single Teams or Players or all of them.

# Endpoints

GET /teams --> Displays all Team objects
GET /teams/{team_id} --> Displays a single team object with the given team_ID
GET /players --> Displays all Player objects
GET /players/{player_id} --> Displays a single Player with the given ID

POST /teams --> Stores a new Team in the database
POST /players --> Stores a new Player in the database

PATCH /teams/{team_id} --> Updates a property from the team with the given team_ID
PATCH /players/{player_id} --> Updates a property from the player with the given ID

DELETE /teams/{team_id} --> deletes database entry from the team with the given team_ID
DELETE /players/{player_id} --> deletes database entry from the player with the given ID

# <team object> data:{team_id => int, name => String, league => String}

# <player object> data: {id => int, team_id => int, name => String, goals => int}
