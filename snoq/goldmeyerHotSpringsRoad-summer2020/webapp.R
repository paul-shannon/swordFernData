library(shiny)
library(leaflet)
library(plotKML)
#----------------------------------------------------------------------------------------------------
library(yaml)
x <-  yaml.load(readLines("site.yaml"))

points <- x$points
tbl <- do.call(rbind, lapply(points, as.data.frame))
tbl$name <- as.character(tbl$name)
tbl$details <- as.character(tbl$details)
center.lat <- min(tbl$lat) + ((max(tbl$lat) - min(tbl$lat))/2)
center.lon <- min(tbl$lon) + ((max(tbl$lon) - min(tbl$lon))/2)
#----------------------------------------------------------------------------------------------------
ui <- fluidPage(

  titlePanel("Sword Fern Die-off Reports from the Snoqualmie Middle Fork"),
  sidebarLayout(
      sidebarPanel(
         selectInput("siteSelector", "Select Site", c("", as.character(1:nrow(tbl)))),
         actionButton("fullViewButton", "Full View"),

         width=2
         ),
      mainPanel(
          tags$style(type = "text/css", "#map {height: calc(100vh - 80px) !important;}"),
          tabsetPanel(type="tabs", id="mapTabs",
                      tabPanel(title="Map", value="mapTab", leafletOutput("map")),
                      tabPanel(title="Site Details", value="siteDetailsTab",
                               div(id="foo"))),# , includeHTML("emptyDetails.html")))
         width=10
         )
     )
)
#----------------------------------------------------------------------------------------------------
server <- function(input, output, session) {

  observeEvent(input$fullViewButton, ignoreInit=TRUE, {
     isolate({
        leafletProxy('map') %>%
           setView(lng=center.lon, lat=center.lat, zoom=14)
        })

      })

  observe({
     req(input$siteSelector)
     siteNumber <- as.integer(input$siteSelector)
     lat <- tbl[siteNumber, "lat"]
     lon <- tbl[siteNumber, "lon"]
     isolate({
        leafletProxy('map') %>%
            setView(lon, lat, zoom=18)
        })
    })


  observe({
     req(input$map_marker_click)
     event <- input$map_marker_click
     print(names(event))
     print(event)
     lat <- event$lat
     lon <- event$lng
     printf("lat: %f  lon: %f", lat, lon)
     details.url <- subset(tbl, name==event$id)$details
     print(details.url)
     removeUI("#temporaryDiv")
     insertUI("#foo", "beforeEnd", div(id="temporaryDiv"))
     insertUI("#temporaryDiv", "beforeEnd",
              div(id="detailsDiv", includeHTML(details.url)))
     updateTabsetPanel(session, "mapTabs", selected="siteDetailsTab")    # provided by shiny

     #insertUI(
     #    selector = '#foo',
     #    ui = includeHTML(details.url))
     })

#  output$foo <- renderUI({
#     #req(input$map_marker_click)
#     event <- input$map_marker_click
#     print(names(event))
#     print(event)
#     lat <- event$lat
#     lon <- event$lng
#     printf("lat: %f  lon: %f", lat, lon)
#     details.url <- subset(tbl, name==event$id)$details
#     print(details.url)
#     "<h4>foo</h4>"
#     })

  output$map <- renderLeaflet({
      options = leafletOptions(minZoom=0, maxZoom=22, maxNativeZoom=18)
      options.tile <- tileOptions(minZoom=0, maxZoom=22, maxNativeZoom=18)
      leaflet(options) %>%
      addTiles(options=options.tile) %>%
      setView(center.lon, center.lat, zoom=14) %>%
      addCircleMarkers(tbl$lon, tbl$lat, label=tbl$name, color=tbl$color, radius=tbl$radius, layerId=tbl$name) %>%
      addScaleBar()
      })
}
#----------------------------------------------------------------------------------------------------
runApp(shinyApp(ui, server), host="0.0.0.0", port=6789)
