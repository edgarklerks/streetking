module Test where 

import Model.General 
import Model.Continent 
import Database.HDBC.PostgreSQL

dbconn ::  IO Connection
dbconn = connectPostgreSQL "host=graf2.graffity.me port=5432 dbname=streetking_dev user=deosx password=#*rl&"


