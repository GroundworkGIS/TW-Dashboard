
# Copyright (c) 2016 Groundwork GIS
# http://groundworkgis.org.uk/
#

if (file.exists('db.R')) {
  DB <- TRUE
  source('db.R')
} else {
  DB <- FALSE
}