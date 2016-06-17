
# Copyright (c) 2016 Groundwork GIS
# http://groundworkgis.org.uk/
#

library(RPostgreSQL)
library(data.table)
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
    
    # PMP_PERFORMANCE_HOURLY
    PMP_PERFORMANCE_HOURLY$data <<- pg_select(PMP_PERFORMANCE_HOURLY$source)
    
    # PMP_PERFORMANCE_DAILY
    PMP_PERFORMANCE_DAILY$data  <<- pg_select(PMP_PERFORMANCE_DAILY$source)

    # BOROUGHS
    PMP_BOROUGHS$data <<- getBoroughs(PMP_PERFORMANCE_DAILY$data)
    
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
        
        filterDateRange <- input$ceo_performance_date_ctrl
        filterborough   <- input$ceo_performance_borough_ctrl
        
        filterClause <- list(~attempts_date >= filterDateRange[1], ~attempts_date <= filterDateRange[2])
        if (filterborough != "All") filterClause <- append(filterClause, ~borough == filterborough)
        
        #data
        PMP_PERFORMANCE_DAILY$data %>%
          filter_(.dots = filterClause) %>%
          group_by(attempt_user) %>%
          summarise(
            total_attempts    = sum(total_attempts),
            total_engaged     = sum(total_f2f),
            total_not_home    = sum(total_not_home),
            total_no_property = sum(total_no_property_exists),
            rate_engaged      = percentage(sum(total_f2f)/sum(total_attempts)),
            rate_not_home     = percentage(sum(total_not_home)/sum(total_attempts)),
            rate_no_property  = percentage(sum(total_no_property_exists)/sum(total_attempts)))
      })


      # Chart: Performance Chart
      output$ceo_performance_performance_chart <- renderPlot({

          rows_to_show <- rev(input$ceo_performance_performance_summary_rows_current)
          data <- ceo_performance_data()[rows_to_show,]

          if (input$ceo_performance_view_ctrl == "values") {
            
            #values
            xlimit <- xlimit(ceo_performance_data()$total_not_home)
            fields <- CEO_PERFORMANCE_CHART_VALUES_FIELDS
            labels <- CEO_PERFORMANCE_CHART_VALUES_LABELS
            chart <- setChart("GROUPED", "reds")

          } else {

            # ratios
            xlimit <- 100
            fields <- CEO_PERFORMANCE_CHART_RATIOS_FIELDS
            labels <- CEO_PERFORMANCE_CHART_RATIOS_LABELS
            chart <- setChart("STACKED", "reds")
          }

          data <- prep_barchart_data(data, "attempt_user", fields, labels, chart=chart$type)

        ggplot(data, aes(x=attempt_user, y=value, fill=reorder(type, order))) +
          geom_bar(stat="identity", show.legend = TRUE, position = chart$position)+
          scale_fill_manual(values=chart$palette, breaks = labels)+
          scale_y_continuous(limits = c(0, xlimit), expand = c(0,0))+
          theme_minimal()+
          theme(axis.title.x=element_blank())+
          theme(axis.title.y=element_blank())+
          theme(legend.position="top")+
          labs(fill="")+
          coord_flip()
          
      })
      
      # Table: Performance summary
      output$ceo_performance_performance_summary <- DT::renderDataTable(DT::datatable(
          {data <- ceo_performance_data()
        
          if (input$ceo_performance_view_ctrl == "values") {
            fields <- CEO_PERFORMANCE_SUMMARY_VALUES_FIELDS
            labels <- CEO_PERFORMANCE_SUMMARY_VALUES_LABELS

          } else {
            fields <- CEO_PERFORMANCE_SUMMARY_RATIOS_FIELDS
            labels <- CEO_PERFORMANCE_SUMMARY_RATIOS_LABELS
          }
          
          #setnames(select_(data, .dots = fields), old=fields, new=labels)
          select_(data, .dots = fields)
        },
        width = "100%",
        extensions = 'FixedColumns',
        rownames = FALSE,
        colnames = labels,
        options = list(dom = 'tp',
                       FixedColumns = TRUE,
                       pageLength = TABLE_MAX_ROWS,
                       scrollY = 500,
                       autoWidth = TRUE,
                       initComplete = JS("function(settings, json) {$(this.api().table().columns.adjust());}"))),
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