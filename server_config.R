
# Copyright (c) 2016 Groundwork GIS
# http://groundworkgis.org.uk/
#

# Server variables (globals)

# Database connection
#PG_HOST     <- "host"
#PG_DBNAME   <- "dbname"
#PG_USER     <- "user"
#PG_PASSWORD <- "password"

# Data variables from database (data, table name)
PMP_PERFORMANCE_DAILY  <- reactiveValues(data=list(), source="sde.pmp_performance_daily")
PMP_PERFORMANCE_HOURLY <- reactiveValues(data=list(), source="sde.pmp_performance_hourly")

# Data variables
PMP_BOROUGHS <- reactiveValues(data=list())
#PPD_BY_USER  <- reactiveValues(data=list())

# Refresh
REFRESH_INTERVAL <- 60 #minutes
#REFRESH_INTERVAL <- 3600 #seconds

# Access
ACCESS <- reactiveValues(data=data.frame(sid=character(), user=character(), role=character(), stringsAsFactors=FALSE))

