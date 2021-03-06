#' UI -> Display a map to show the run path on a map
#'
runningMap_UI <- function(id) {
    ns <- NS(id)
    leafletOutput(ns('map'))
}

#' Create a map to show the run path on a map
#' @param df Select the dataframe to extract informations and stats from
#' @param date Selected Date of the run
#' @param whichRun Selected run if the Date has multiple runs
#'
runningMap_server <- function(id, df, date, whichRun) {
    moduleServer(
        id,
        function(input, output, session) {

        output$map <- renderLeaflet({
            
            #if no date is selected, nothing is displayed
            #req is mainly used here to prevent the display of error message if selected date is empty
            req(date())
            getDataTable <- reactive({
                #check if empty or not for the req in the map
                if (!is.null(date())) {
                    df()[date == date()]
                }
            })
            data <- getDataTable()

            if (data[, .N] > 1) {
                #this mean we have more than 1 run this day, so multiple rows
                #remove " kilometers from the string we get from "input$select_run"
                select_run <- str_remove_all(whichRun(), " kilometers")
                #match the date & distance selected and display the result
                values <- data[km %in% select_run & date %in% date()]
            } else {
                #this means we have only 1 run this day so 1 row
                values <- data
            }

            latStart <- as.numeric(values[1, lat_start])
            longStart <- as.numeric(values[1, long_start])
            latFinish <- as.numeric(values[1, lat_finish])
            longFinish <- as.numeric(values[1, long_finish])


            # #Append values to the global list parameters for markdown report
            run_params <<- append(run_params, list(latStart = latStart))
            run_params <<- append(run_params, list(longStart = longStart))
            run_params <<- append(run_params, list(latFinish = latFinish))
            run_params <<- append(run_params, list(longFinish = longFinish))

            route = osrmRoute(c(longStart,latStart), c(longFinish,latFinish), overview = 'full')
            # route_simple = osrmRoute(c(115.6813467,-32.0397559), c(150.3715249,-33.8469759), overview = 'simplified')
            route_summary = osrmRoute(c(longStart,latStart), c(longFinish,latFinish), overview = FALSE)

            
            leaflet() %>%
            addTiles() %>%
            addMarkers(c(longStart, longFinish), c(latStart, latFinish))  %>%
            
            addPolylines(route$lon, route$lat,
            # You can uncomment the lines below to display a bubble with the distance and the time estimated for this travel
            #             label = paste(round(route_summary[1]/60), 'hr - ', round(route_summary[2]), 'km'), 
            #             labelOptions = labelOptions(noHide = TRUE)
            )
            
        })
    })
}
