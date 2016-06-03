
# Copyright (c) 2016 Groundwork GIS
# http://groundworkgis.org.uk/
#

# Server functions (global scope)

pg_select <- function(d, w="") {
  # pg_select(d, w)
  # get data from pg table
  # d (text), data table name
  # w (text, optional), where clause, eg.: "NAME='Thomas'"
  # returns data.frame
  
  pg_connection <- dbConnect(dbDriver("PostgreSQL"),
                             host=PG_HOST,
                             dbname=PG_DBNAME,
                             user=PG_USER,
                             password = PG_PASSWORD)
  
  if (nchar(w) > 0) {
    w <- paste(" WHERE ", w, sep="")
  }
  
  sql = paste("SELECT * FROM ", d, w, sep="")
  result = dbGetQuery(pg_connection, sql)
  
  dbDisconnect(pg_connection)
  
  return(result)
}



generate_choices <- function(l) {
  # generate_choices()
  # add All on top of option lists
  # returns list
  
  append("All", l)
}

