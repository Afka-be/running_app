server <- function(input, output, session) {

#-------------------------------- Initialization

userProfile_server("init") # Initialize user profile (weight, etc)

#-------------------------------- Left Part / Single Run

selectRun_server("run_date")

valueGetter <- selectRun_server("run_date") # Get the reactive values from the select fields's runs and use them as parameters for the functions that need those informations
profileGetter <- userProfile_server("init") # Get the reactive values from the userprofile and use them as parameters for the functions that need those informations

stats_server("run_distance", date = valueGetter$theDate, whichRun = valueGetter$theRun, weight = profileGetter$userWeight, column = "km", subtitle = "Distance", icon = "distance", color = "green")
stats_server("run_time", date = valueGetter$theDate, whichRun = valueGetter$theRun, weight = profileGetter$userWeight, column = "time", subtitle = "Minutes", icon = "time", color = "blue") 
stats_server("run_pace", date = valueGetter$theDate, whichRun = valueGetter$theRun, weight = profileGetter$userWeight, column = "pace", subtitle = "Km/h", icon = "speed", color = "purple")
statsCalories_server("run_calories", date = valueGetter$theDate, whichRun = valueGetter$theRun, weight = profileGetter$userWeight, column = "pace", subtitle = "Calories", icon = "calories", color = "orange")  
runningMap_server("run_map", date = valueGetter$theDate, whichRun = valueGetter$theRun)

#-------------------------------- Right Part / Overview

selectRunOverview_server("run_overview")

rangeGetter <- selectRunOverview_server("run_overview")

runOverview_server("run_overview", rangeDate = rangeGetter$theDateRange)

}