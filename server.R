
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)

shinyServer(function(input, output) {
    library(lubridate)
    library(leaflet)
    library(plotly)
# Set up to receive user inputted dates. Subset Baltimore crime data according to dates.
    reactive({
        minDate <- as.POSIXct(input$daterange[1])
        maxDate <- as.POSIXct(input$daterange[2])
        dateSubset <- bmoreRaw[bmoreRaw$CrimeDate >= minDate & bmoreRaw$CrimeDate <= maxDate,]
        dateSubset1 <- bmoreClean[bmoreClean$CrimeDate >= minDate & bmoreClean$CrimeDate <= maxDate,]
        dateSubset2 <- bmoreAgg[bmoreAgg$CrimeDate >= minDate & bmoreAgg$CrimeDate <= maxDate,]
})
# Plot map
    output$crimeLoc <- 
        renderLeaflet({
            minDate <- as.POSIXct(input$daterange[1])
            maxDate <- as.POSIXct(input$daterange[2])
            dateSubset <- bmoreRaw[bmoreRaw$CrimeDate >= minDate & bmoreRaw$CrimeDate <= maxDate,]
            crimeIcon <- makeIcon(
                iconUrl = "http://www.freeiconspng.com/uploads/robber-crime-thief-flat-icon-0.png",
                iconWidth = 31*215/230, iconHeight = 31,
                iconAnchorX = 31*215/230/2, iconAnchorY = 16
            )
            
            dateSubset %>% 
                leaflet() %>%
                addTiles() %>%
                addMarkers(popup = dateSubset$Description, icon = crimeIcon, clusterOptions = markerClusterOptions())
        })
# Plot histogram
    output$crimeRate <-     
          renderPlotly({
                minDate <- as.POSIXct(input$daterange[1])
                maxDate <- as.POSIXct(input$daterange[2])
                dateSubset1 <- bmoreClean[bmoreClean$CrimeDate >= minDate & bmoreClean$CrimeDate <= maxDate,]
                plot_ly(x = as.factor(dateSubset1$Description), type = "histogram", color = as.factor(dateSubset1$Description))
      })
# Plot line graph     
      output$crimeFreq <-     
          renderPlotly({
            minDate <- as.POSIXct(input$daterange[1])
            maxDate <- as.POSIXct(input$daterange[2])
            dateSubset2 <- bmoreAgg[bmoreAgg$CrimeDate >= minDate & bmoreAgg$CrimeDate <= maxDate,]
            plot_ly(dateSubset2, x = dateSubset2$CrimeDate, y = dateSubset2$x, type = "scatter", mode = "lines")
      })
})

