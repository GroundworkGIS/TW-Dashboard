
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
  
  d <- paste(PG_SCHEMA, d, sep=".")
  
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
  # l (vec), fields subset labels
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



applyLabels <- function(d, n) {
  # rename columns to labels
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



setChart <- function(t, p="DEFAULT") {
  # t type
  # p palette name
  
  p <- paste("PALETTE_", toupper(p), sep = "")
  c <- eval(parse(text = p))
  
  if (t == "GROUPED") {
    a = 1
    b = position_dodge()
    c = rev(c)
    
  } else if (t == "STACKED") {
    a = -1
    b = position_stack()
  }
  
  list(type = t, direction = a, position = b, palette = c)
}


getDailyData <- function(hourlyData) {
  #hourly data summarised by date, user, borough
  
  hourlyData %>%
  group_by(attempts_date, attempt_user, borough) %>%
  summarise(
    total_attempts               = sum(total_attempts),
    total_not_home               = sum(total_not_home),
    total_refuses_to_be_engaged  = sum(total_refuses_to_be_engaged),
    total_refuses_meter          = sum(total_refuses_meter),
    total_no_property_exists     = sum(total_no_property_exists),
    total_engaged_not_interested = sum(total_engaged_not_interested),
    total_engaged_form_completed = sum(total_engaged_form_completed),
    total_f2f                    = sum(total_f2f)) %>%
  as.data.frame()
}


getBoroughs <- function(data) {
  (data %>%
    select(borough) %>%
    distinct()
   )$borough
} 