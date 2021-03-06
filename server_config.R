
# Copyright (c) 2016 Groundwork GIS
# http://groundworkgis.org.uk/
#

# Server variables (globals)

# Database connection, now in db.R
#PG_HOST     <- "host"
#PG_DBNAME   <- "dbname"
#PG_USER     <- "user"
#PG_PASSWORD <- "password"

# Data from database rV(data, table name)
PMP_PERFORMANCE_HOURLY <- reactiveValues(data=list(), source="pmp_dashboard_performance_hourly")
PMP_PERFORMANCE_DAILY  <- reactiveValues(data=list(), source="pmp_dashboard_performance_daily")

# Data
PMP_BOROUGHS                <- reactiveValues(data=list())
PMP_PERFORMANCE_DAILY_STATS <- reactiveValues(data=list())

# Ceo performance options
CEO_PERFORMANCE_CHART_VALUES_FIELDS <- c( "total_engaged", "total_not_home", "total_no_property")
CEO_PERFORMANCE_CHART_VALUES_LABELS <- c( "Engaged", "Not at home", "No property")

CEO_PERFORMANCE_CHART_RATIOS_FIELDS <- c("rate_engaged",  "rate_not_home", "rate_no_property")
CEO_PERFORMANCE_CHART_RATIOS_LABELS <- c( "Engaged (%)", "Not at home (%)", "No property (%)")

CEO_PERFORMANCE_SUMMARY_VALUES_FIELDS <- c("attempt_user", "total_engaged", "total_not_home", "total_no_property", "total_attempts")
CEO_PERFORMANCE_SUMMARY_VALUES_LABELS <- c("CEO", "Engaged", "Not at home", "No property", "Total")

CEO_PERFORMANCE_SUMMARY_RATIOS_FIELDS <- c("attempt_user", "rate_engaged", "rate_not_home", "rate_no_property", "total_attempts")
CEO_PERFORMANCE_SUMMARY_RATIOS_LABELS <- c("CEO", "Engaged (%)", "Not at home (%)", "No property (%)", "Total")

# Palettes
PALETTE_DEFAULT <- c("#f03b20","#fecc5c","#ffffb2")
PALETTE_REDS    <- c("#f03b20","#fecc5c","#ffffb2")

# Refresh
REFRESH_INTERVAL <- 60 #minutes

# Access
ACCESS <- reactiveValues(data=data.frame(sid=character(), user=character(), role=character(), stringsAsFactors=FALSE))

