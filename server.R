
# Copyright (c) 2016 Groundwork GIS
# http://groundworkgis.org.uk/
#

library(RPostgreSQL)
library(reshape2)
library(ggplot2)
library(shiny)
library(dplyr)
library(DT)

source("server_config.R")
source("server_functions.R")

# db.R
if (!DB) {
  shinyServer(function(input, output) {})
} else {

  
  # Data 
  refresh_reactive_data <- observe({
    invalidateLater(REFRESH_INTERVAL * 1000 * 60)  #interval in minutes
    #invalidateLater(REFRESH_INTERVAL * 1000)      #interval in seconds
    
    # PMP_PERFORMANCE_DAILY
    PMP_PERFORMANCE_DAILY$data <<- pg_select(PMP_PERFORMANCE_DAILY$source)
  
    # PMP_PERFORMANCE_HOURLY
    #PMP_PERFORMANCE_HOURLY$data <<- pg_select(PMP_PERFORMANCE_HOURLY$source)
    
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
        
        ppd_daterange <- input$ceo_performance_date_ctrl
        ppd_borough   <- input$ceo_performance_borough_ctrl
        
        filter_clause <- list(~attempts_date >= ppd_daterange[1], ~attempts_date <= ppd_daterange[2])
        if (ppd_borough != "All") filter_clause <- append(filter_clause, ~borough == ppd_borough)
        
        ppd_filtered <- filter_(PMP_PERFORMANCE_DAILY$data, .dots = filter_clause) #Standard Evaluation
        
        ppd_grouped <- group_by(ppd_filtered, attempt_user)

        summarise(ppd_grouped,
                  total_attempts    = sum(total_attempts),
                  total_engaged     = sum(total_f2f),
                  total_not_home    = sum(total_not_home),
                  total_no_property = sum(total_no_proerty_exists),
                  rate_engaged      = percentage(sum(total_f2f)/sum(total_attempts)),
                  rate_not_home     = percentage(sum(total_not_home)/sum(total_attempts)),
                  rate_no_property  = percentage(sum(total_no_proerty_exists)/sum(total_attempts)))
      })


      # Chart: Performance Chart
      output$ceo_performance_performance_chart <- renderPlot({

          rows_to_show <- rev(input$ceo_performance_performance_summary_rows_current)
          data <- ceo_performance_data()[rows_to_show,]

          labels <- CEO_PERFORMANCE_CHART_LABELS$data

          if (input$ceo_performance_view_ctrl == "values") {
            xlimit <- xlimit(ceo_performance_data()$total_attempts)
            fields <- c( "total_engaged",  "total_not_home", "total_no_property")
            position = position_dodge()
            chart = "GROUPED"
            direction = 1

          } else {

            # ratios
            xlimit <- 100
            fields <- c("rate_engaged",  "rate_not_home", "rate_no_property")
            position = position_stack()
            chart = "STACKED"
            direction = -1
          }

          data <- prep_barchart_data(data, "attempt_user", fields, labels, chart=chart)

        ggplot(data, aes(x=attempt_user, y=value, fill=reorder(type, order))) +
          geom_bar(stat="identity", show.legend = TRUE, position = position)+
          scale_fill_brewer(direction = direction, breaks = labels)+
          scale_y_continuous(limits = c(0, xlimit), expand = c(0,0))+
          theme_minimal()+
          theme(axis.title.x=element_blank())+
          theme(axis.title.y=element_blank())+
          theme(legend.position="top")+
          labs(fill="")+
          coord_flip()
          
      })
      
      # Table: Performance summary
      output$ceo_performance_performance_summary <- DT::renderDataTable({
          
          if (input$ceo_performance_view_ctrl == "values") {
            data <- rename(select(ceo_performance_data(), attempt_user, total_engaged, total_not_home, total_no_property, total_attempts),
                           CEO=attempt_user, Engaged=total_engaged, "Not at home"=total_not_home, "No property"=total_no_property, "Total"=total_attempts)
          } else {
            data <- rename(select(ceo_performance_data(), attempt_user, rate_engaged, rate_not_home, rate_no_property),
                           CEO=attempt_user, Engaged=rate_engaged, "Not at home"=rate_not_home, "No property"=rate_no_property)
          }
        
          #rename(ceo_performance_data(),
          #       CEO = attempt_user,
          #       Engaged = total_engaged,
          #       "Not at home" = total_not_home,
          #       "No property" = total_no_property,
          #       Engaged = rate_engaged,
          #       "Not at home" = rate_not_home,
          #       "No property" = rate_no_property)
        },
        options = list(pageLength = TABLE_MAX_ROWS,
                       searching = FALSE,
                       bLengthChange = FALSE,
                       scrollY = 500,
                       scrollCollapse = TRUE,
                       bInfo = FALSE,
                       columnDefs = list(list(visible = FALSE, targets = 0))),
        server = FALSE
      )
  
      # Dynamic option lists
      observe({
        c <- generate_choices(PMP_BOROUGHS$data)
        updateSelectInput(session, "ceo_performance_borough_ctrl", choices = c)
        cat("updated option list ", c, "\n")
      })
      
  })

} #db.R