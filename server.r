server <- function(input, output, session) {

#-------------------------------- Initialization

userProfile_server("init") # Initialize user profile (weight, etc)

#-------------------------------- Left Part / Single Run

selectRun_server("run_date")

valueGetter <- selectRun_server("run_date") # Get the reactive values from the select fields's runs and use them as parameters for the functions that need those informations
profileGetter <- userProfile_server("init") # Get the reactive values from the userprofile and use them as parameters for the functions that need those informations

stats_server("run_distance", date = valueGetter$theDate, whichRun = valueGetter$theRun, weight = profileGetter$userWeight, column = "km", subtitle = "Distance", icon = "bar chart", color = "blue")
stats_server("run_time", date = valueGetter$theDate, whichRun = valueGetter$theRun, weight = profileGetter$userWeight, column = "time", subtitle = "minutes", icon = "clock", color = "purple") 
stats_server("run_pace", date = valueGetter$theDate, whichRun = valueGetter$theRun, weight = profileGetter$userWeight, column = "pace", subtitle = "in km/h", icon = "forward", color = "orange")
statsCalories_server("run_calories", date = valueGetter$theDate, whichRun = valueGetter$theRun, weight = profileGetter$userWeight, column = "pace", subtitle = "Calories", icon = "forward", color = "green")  
runningMap_server("run_map", date = valueGetter$theDate, whichRun = valueGetter$theRun)

#-------------------------------- Right Part / Overview

}