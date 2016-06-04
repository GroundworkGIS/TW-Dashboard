
# Copyright (c) 2016 Groundwork GIS
# http://groundworkgis.org.uk/
#

library(RPostgreSQL)
library(shiny)
library(dplyr)
library(ggplot2)
source('db.R')
source("server_config.R")
source("server_functions.R")


# Data 
refresh_reactive_data <- observe({
  invalidateLater(REFRESH_INTERVAL * 1000 * 60)  #interval in minutes
  #invalidateLater(REFRESH_INTERVAL * 1000)      #interval in seconds
  
  # PMP_PERFORMANCE_DAILY
  PMP_PERFORMANCE_DAILY$data <<- pg_select(PMP_PERFORMANCE_DAILY$source)

  # PMP_PERFORMANCE_HOURLY
  PMP_PERFORMANCE_HOURLY$data <<- pg_select(PMP_PERFORMANCE_HOURLY$source)
  
  # BOROUGHS
  boroughs = distinct(select(PMP_PERFORMANCE_DAILY$data, borough))
  PMP_BOROUGHS$data <<- boroughs$borough
  
  # LAST_UPDATE
  REFRESH_LAST <<- Sys.time()
  
  cat(paste(REFRESH_LAST, "Data has been refreshed", "\n"))
})



# Shinyserver
shinyServer(function(input, output, session) {
  
  # Check first run
  check_firstrun <- reactiveValues(data = TRUE)
  session$onFlushed(function() {check_firstrun$data <- FALSE}, once = TRUE)

  
  # CEO Performance
    
    # Data
    ceo_performance_data <- reactive({
    
      ppd_daterange <- input$ceo_performance_date_filter
      ppd_borough   <- input$ceo_performance_borough_filter
      
      filter_clause <- list(~attempts_date >= ppd_daterange[1], ~attempts_date <= ppd_daterange[2])
      if (ppd_borough != "All") filter_clause <- append(filter_clause, ~borough == ppd_borough)
      
      ppd_filtered <- filter_(PMP_PERFORMANCE_DAILY$data, .dots = filter_clause) #Standard Evaluation
      
      ppd_grouped <- group_by(ppd_filtered, attempt_user)
      
      ppd_by_user <- summarise(ppd_grouped,
                               total_attempts    = sum(total_attempts),
                               total_engaged     = sum(total_f2f),
                               total_not_home    = sum(total_not_home),
                               total_no_property = sum(total_no_proerty_exists),
                               rate_engaged      = sum(total_f2f)/sum(total_attempts),
                               rate_not_home     = sum(total_not_home)/sum(total_attempts),
                               rate_no_property  = sum(total_no_proerty_exists)/sum(total_attempts))

    })
    
    # Chart: ceo_performance_chart
    output$ceo_performance_chart <- renderPlot({
      ceos <- ceo_performance_data()$attempt_user
      total_attempts <- ceo_performance_data()$total_attempts

      ggplot(data=ceo_performance_data(), aes(x=attempt_user, y=total_attempts)) +
        geom_bar(stat="identity", colour="white") +
        xlab("Total Attempts") + ylab("User") +
        theme_minimal #+ coord_flip()
    })
    
    # Table: Values
    output$ceo_performance_values_table <- renderDataTable({
      select(ceo_performance_data(), attempt_user, total_engaged, total_not_home, total_no_property)},
      options = list(pageLength = 10, searching = FALSE, lengthMenu = list(c(10)))
    )
    
    # Table: Ratios
    output$ceo_performance_ratios_table <- renderDataTable({
      select(ceo_performance_data(), attempt_user, rate_engaged, rate_not_home, rate_no_property)},
      options = list(pageLength = 10, searching = FALSE, lengthMenu = list(c(10)))
    )
    
    # Dynamic option lists
    observe({
      c <- generate_choices(PMP_BOROUGHS$data)
      updateSelectInput(session, "ceo_performance_borough_filter", choices = c)
      cat("updated option list ", c, "\n")
    })
    
})
