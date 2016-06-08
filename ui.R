
# Copyright (c) 2016 Groundwork GIS
# http://groundworkgis.org.uk/
#

library(shiny)
library(markdown)
library(shinydashboard)
source("ui_config.R")
source("ui_functions.R")


# db.R
if (!DB) {
  shinyUI(fluidPage(fluidRow(column(3,
    includeMarkdown("db.md")
  ))))
} else {
  
  
  # Custom CSS
  CustomCss <- tags$head(tags$style(HTML('

  ')))
  
  
  
  # Sidebar
  sidebar <- dashboardSidebar(
    width = SIDEWIDTH,
    sidebarMenu(
      convertMenuItem(menuItem("CEO Performance", tabName = "tab1",
      
                               icon = icon("bar-chart"),
                               dateRangeInput("ceo_performance_date_ctrl", "Date range", start = STARTDATE, format="dd/mm/yyyy"),
                               selectInput("ceo_performance_borough_ctrl", "Borough", choices = list("All")),
                               radioButtons("ceo_performance_view_ctrl", "Switch View", c("Values"= "values", "Ratios" = "ratios"))
                               #htmlOutput("ceo_performance_borough_filter_server")
                               ),tabName = "tab1"),
      
      convertMenuItem(menuItem("Time Performance", tabName = "tab2",
                               
                               icon = icon("clock-o"),
                               dateRangeInput("time_performance_date_ctrl", "A test control", start = STARTDATE, format="dd/mm/yyyy")                             
                               ),tabName = "tab2"),
  
      
      convertMenuItem(menuItem("Forward Planning", tabName = "tab3",
                               
                               icon = icon("calendar"),
                               dateRangeInput("forward_planning_date_ctrl", "A test control", start = STARTDATE, format="dd/mm/yyyy")                                                          
                               ),tabName = "tab3")                          
    )
  )
  
  
  
  
  # Body
  body <- dashboardBody(
    CustomCss,
    tabItems(
  
      #CEO Performance    
      tabItem(tabName = "tab1",
              fluidRow(
                box(title = "Performance Summary", solidHeader = TRUE, status = "primary", DT::dataTableOutput("ceo_performance_performance_summary"), height=500+62),
                box(title = "Performance Chart", solidHeader = TRUE, status = "primary", plotOutput("ceo_performance_performance_chart", height=500))
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
      title = TITLE),
    sidebar,
    body
  )
  
  
} #db.R  
  
  
  
