
# Copyright (c) 2016 Groundwork GIS
# http://groundworkgis.org.uk/
#

library(shiny)
library(shinydashboard)
source("ui_config.R")
source("ui_functions.R")



# Sidebar
sidebar <- dashboardSidebar(
  width = SIDEWIDTH,
  sidebarMenu(
    convertMenuItem(menuItem("CEO Performance", tabName = "tab1",
    
                             icon = icon("bar-chart"),
                             dateRangeInput("ceo_performance_date_filter", "Filter by Date", start = "2015-12-01", end = Sys.Date(), format="dd/mm/yyyy"),
                             selectInput("ceo_performance_borough_filter", "Filter by Borough", choices = list("All"))
                             #htmlOutput("ceo_performance_borough_filter_server")
                             ),tabName = "tab1"),
    
    convertMenuItem(menuItem("Time Performance", tabName = "tab2",
                             
                             icon = icon("clock-o")
                             ),tabName = "tab2"),

    
    convertMenuItem(menuItem("Forward Planning", tabName = "tab3",
                             
                             icon = icon("calendar")
                             ),tabName = "tab3")                          
  )
)




# Body
body <- dashboardBody(
  tabItems(

    #CEO Performance    
    tabItem(tabName = "tab1",
            fluidRow(
              box(plotOutput("ceo_performance_chart", height=850))
              #box(tableOutput("ceo_performance_table"))
            )
    ),
    # 
    #Time Performance
    tabItem(tabName = "tab2"

    ),
    
    #Forward Planning
    tabItem(tabName = "tab3"

    )
  )  
)




# Page
dashboardPage(
  dashboardHeader(
    titleWidth = SIDEWIDTH,
    title = "TW Dashboard"),
  sidebar,
  body
)






