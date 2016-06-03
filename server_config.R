
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

# Refresh
REFRESH_INTERVAL <- 60 #minutes
#REFRESH_INTERVAL <- 3600 #seconds

# Charts Layout
theme_minimal <- theme(plot.title=element_text(hjust=0),
                       panel.background=element_blank(),
                       panel.grid.minor=element_blank(),
                       panel.grid.major.x=element_line(colour="grey", linetype = "dashed"),
                       panel.grid.major.y=element_blank(),
                       axis.ticks.y=element_blank(),
                       axis.ticks.x=element_blank(),
                       legend.position="none")

# Access
ACCESS <- reactiveValues(data=data.frame(sid=character(), user=character(), role=character(), stringsAsFactors=FALSE))

