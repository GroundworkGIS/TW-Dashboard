
# Copyright (c) 2016 Groundwork GIS
# http://groundworkgis.org.uk/
#

# Server variables (globals)

# Database connection
#PG_HOST     <- "host"
#PG_DBNAME   <- "dbname"
#PG_USER     <- "user"
#PG_PASSWORD <- "password"

# Data from database (data, table name)
PMP_PERFORMANCE_DAILY  <- reactiveValues(data=list(), source="sde.pmp_performance_daily")
PMP_PERFORMANCE_HOURLY <- reactiveValues(data=list(), source="sde.pmp_performance_hourly")

# Data
PMP_BOROUGHS <- reactiveValues(data=list())
PMP_PERFORMANCE_DAILY_STATS <- reactiveValues(data=list())
#PPD_BY_USER  <- reactiveValues(data=list())

# Labels
#CEO_PERFORMANCE_DATA_HEADER <- data.frame(
#  fieldnames = c("total_engaged", "total_not_home", "total_no_property", "rate_engaged", "rate_not_home", "rate_no_property"),
#  labels     = c("Engaged", "Not at home", "No property", "Engaged", "Not at home", "No property"))
CEO_PERFORMANCE_CHART_LABELS <- reactiveValues(data=c( "Engaged", "Not at home", "No property", "Total"))

# Palettes
PALETTE_DEFAULT = c("#f03b20","#fecc5c","#ffffb2")
PALETTE_REDS = c("#f03b20","#fecc5c","#ffffb2")

# Refresh
REFRESH_INTERVAL <- 60 #minutes
#REFRESH_INTERVAL <- 3600 #seconds

# Access
ACCESS <- reactiveValues(data=data.frame(sid=character(), user=character(), role=character(), stringsAsFactors=FALSE))

