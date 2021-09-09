server <- function(input, output, session) {

#-------------------------------- Initialization
userWeight <- reactiveVal(0) # Initialize weight reactiveVal

if(file.exists("csv/profile.csv")) {
  userProfile <- fread(file = "csv/profile.csv")
  userWeight(userProfile[1, weight]) # Update weight reactiveVal with value stored in CSV
} else {
  create_modal(modal(
    id = "modal_weight",
    header = h2("Important message"),
    selectInput("enterWeight", "Enter your weight (in kg)", c(10:200))
  ))
}
observeEvent(
  eventExpr = input$enterWeight,
  handlerExpr = {
    newWeight = data.table(weight = input$enterWeight)
    write.csv(newWeight, "csv/profile.csv", row.names = FALSE)
    userWeight(input$enterWeight) # Update weight reactiveVal with the weight entered if CSV does not exist
  }
)
# If need to change weight, click input$button_modal and create new modal
observeEvent(
    eventExpr = input$button_modal,
    handlerExpr = {
    create_modal(modal(
      id = "modal_new_weight",
      header = h2("Important message"),
      # create a select input for the new Weight
      selectInput("enterNewWeight", "Enter your weight (in kg)", c(10:200))
    ))
})
# Use the new weight entered in the recently created modal with the new selectInput
observeEvent(
    eventExpr = input$enterNewWeight,
    handlerExpr = {
    # Create a profile.csv again
    newWeight = data.table(weight = input$enterNewWeight)
    write.csv(newWeight, "csv/profile.csv", row.names = FALSE)
    userWeight(input$enterNewWeight) # Update weight reactiveVal
})

#-------------------------------- Left Part / Single Run
selectRun_server("run_date")
valueGetter <- selectRun_server("run_date") # Get the reactive values and use them as parameters for the functions that need those informations
stats_server("run_distance", date = valueGetter$theDate, whichRun = valueGetter$theRun, weight = userWeight, column = "km", subtitle = "Distance", icon = "bar chart", color = "blue")
stats_server("run_time", date = valueGetter$theDate, whichRun = valueGetter$theRun, weight = userWeight, column = "time", subtitle = "minutes", icon = "clock", color = "purple") 
stats_server("run_pace", date = valueGetter$theDate, whichRun = valueGetter$theRun, weight = userWeight, column = "pace", subtitle = "in km/h", icon = "forward", color = "orange") 

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


#-------------------------------- Right Part / Overview

}