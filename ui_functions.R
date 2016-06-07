
# Copyright (c) 2016 Groundwork GIS
# http://groundworkgis.org.uk/
#


# Client functions (global scope)

#convertMenuItem
convertMenuItem <- function(mi,tabName) {
  mi$children[[1]]$attribs['data-toggle']="tab"
  mi$children[[1]]$attribs['data-value'] = tabName
  mi
}

