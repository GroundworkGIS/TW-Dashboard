
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
  
  #return
  append("All", l)
}



prep_barchart_data <- function(d, x, s=c(), l=C(), chart='GROUPED') {
  # prep_barchart_data(d, f, s=list())
  # perpare data for barchart plot
  # d (data.frame), the data
  # x (string), x axis column name
  # s (vec), fields subset - must NOT include x
  # d (vec), fields subset labels
  # chart (string), type of chart: GROUPED, STACKED
  # returns data.frame(type,value)
  
  d[[x]] <- gsub(" ", "\r\n", d[[x]])
  d[[x]] <- factor(d[[x]], levels = d[[x]]) #lock sorting

  if (chart == "STACKED") {
    o <- s
  } else {
    o <- rev(s)
  }
  
  if (length(s) > 0) {
    d <- select(d, one_of(c(x,s)))
  }

  d <- melt(d, id.vars = c(x),
        variable.name = "type")
  
  if (length(s) > 0) {
    d <- mutate(d, order = match(type, o))
  }
  
  if (length(l) > 0) {
    d <- mutate(d, type = l[match(type, s)])
  } 
  
  return(d)
}



rename_columns <- function(d, n) {
  # rename column
}



percentage <- function(n, d=2) {
  # percentage maker
  round(n*100, digits=d)
}


xlimit <- function(c, v=0) {
  # finds max or returns v
  # c(vec)
  # v(int)
  
  r <- max(c)
  if (!is.finite(r)) r <- v
  
  #returns
  r
}


