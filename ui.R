
# Copyright (c) 2016 Groundwork GIS
# http://groundworkgis.org.uk/
#

library(shiny)
library(shinyjs)
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
  CustomCss <- tags$head(
    tags$link(rel = "stylesheet", type = "text/css", href = "tw-dashboard.css"))

  # Custom JS
  CustomJs <- tags$head(
    tags$script(type = "text/javascript", src = "tw-dashboard.js"))
  
  
  # Sidebar
  sidebar <- dashboardSidebar(
    width = SIDEWIDTH,
    sidebarMenu(
      convertMenuItem(menuItem("Overview", tabName = "tab0", 
                               
                               icon = icon("line-chart"), 
                               div()
                               ),tabName = "tab0"),
      
      convertMenuItem(menuItem("CEO Performance", tabName = "tab1",
      
                               icon = icon("bar-chart"),
                               dateRangeInput("ceo_performance_date_ctrl", "Date Range", start = STARTDATE, format="dd/mm/yyyy"),
                               selectInput("ceo_performance_borough_ctrl", "Filter Borough", choices = list("All")),
                               radioButtons("ceo_performance_view_ctrl", "Switch View", c("Values"= "values", "Ratios" = "ratios"))
                               ),tabName = "tab1"),
      
      convertMenuItem(menuItem("Time Performance", tabName = "tab2",
                               
                               icon = icon("clock-o"),
                               dateRangeInput("time_performance_date_ctrl", "Date Range", start = STARTDATE, format="dd/mm/yyyy"),
                               selectInput("time_performance_dow_ctrl", "Filter Day of the Week", choices = DAYS_OF_WEEK),
                               sliderInput("time_performance_hrs_ctrl", "Hours Range", min = MIN_HRS, max = MAX_HRS, value = DEFAULT_HRS),
                               selectInput("time_performance_borough_ctrl", "Filter Borough", choices = list("All"))
                               ),tabName = "tab2"),
  
      
      convertMenuItem(menuItem("Forward Planning", tabName = "tab3",
                               
                               icon = icon("calendar"),
                               div()
                               ),tabName = "tab3")                          
    )
  )
  
  
  
  
  # Body
  body <- dashboardBody(
    CustomCss,
    CustomJs,
    useShinyjs(),
    tabItems(

      #Forward Planning
      tabItem(tabName = "tab0"
              
      ),
      
      #CEO Performance    
      tabItem(tabName = "tab1",
              fluidRow(tags$div(class = "box-transparent",
                  "CEO Performance"
              )),
              fluidRow(
                box(title = "Summary", 
                    solidHeader = FALSE, status = "primary", DT::dataTableOutput("ceo_performance_performance_summary"), height=650+62),
                
                box(title = "Chart",
                    solidHeader = FALSE, status = "primary", plotOutput("ceo_performance_performance_chart", height=650))
              )
      ),

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
  
  
  
