# User interface for date range selection using a calendar

library(shiny)
library(plotly)
library(leaflet)

    ui <- fluidPage(
        # start and end are always specified in yyyy-mm-dd, even if the display
        # format is different
          sidebarLayout(
            sidebarPanel(
                dateRangeInput("daterange", "Choose Timeframe",
                               start  = "2014-01-01",
                               end    = "2014-01-07",
                               min    = "2014-01-01",
                               max    = "2014-12-31",
                               format = "M/d/yyyy",
                               separator = " -> "),
                h4("Ensure \"from\" date is BEFORE \"to\" date OR you can watch the application crash and burn"),
                h4("Hit the \"Plot\" button after entering dates"),
                h4("Use tabs to see all the plots"),
                submitButton("Plot")
            ),
        # Show the crime plot
        mainPanel(
            tabsetPanel(type = "tabs", 
                tabPanel("Map", br(), leafletOutput("crimeLoc"), h3("Crime Locations - Zoom in")), 
                tabPanel("Histogram", br(), plotlyOutput("crimeRate"), h3("Crime Rates - Hover for totals")), 
                tabPanel("Line Chart", br(), plotlyOutput("crimeFreq", width = "75%"), h3("Crime Frequency - Hover for counts"))
            )
        )
    )
)