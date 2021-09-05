server <- function(input, output, session) {


selectRun_server("run_date")

valueGetter <- selectRun_server("run_date")
stats_server("run_distance", date = valueGetter$theDate, whichRun = valueGetter$theRun, column = "km", subtitle = "Distance", icon = "bar chart", color = "blue") 



route = osrmRoute(c(115.6813467,-32.0397559), c(150.3715249,-33.8469759), overview = 'full')
# route_simple = osrmRoute(c(115.6813467,-32.0397559), c(150.3715249,-33.8469759), overview = 'simplified')
route_summary = osrmRoute(c(115.6813467,-32.0397559), c(150.3715249,-33.8469759), overview = FALSE)

output$map <- renderLeaflet({
    leaflet() %>% addTiles() %>% 
      addMarkers(c(115.6813467,150.3715249), c(-32.0397559,-33.8469759)) %>% 
      addPolylines(route$lon,route$lat, 
                   label = paste(round(route_summary[1]/60), 'hr - ', round(route_summary[2]), 'km'), 
                   labelOptions = labelOptions(noHide = TRUE))
  })

}