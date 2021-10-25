server <- function(input, output, session) {

#-------------------------------- Initialization

# Initialize user profile (weight, etc)
profileGetter <- userProfile_server("init") # Get the reactive values from the userprofile and use them as parameters for the functions that need those informations
csvGetter <- selectDatabase_server("init", user_id = profileGetter$userId) # Get the CSV containing the runs/sports values based on the user_d currently selected
#observe({
#    view(csvGetter$dt_runs())
#})

#############################
###       RUNNING         ###
#############################
#-------------------------------- Left Part / Single Run

runValueGetter <- selectRun_server("run_date", df = csvGetter$dt_runs) # Get the reactive values from the select fields's runs and use them as parameters for the functions that need those informations

stats_server("run_distance", df = csvGetter$dt_runs, date = runValueGetter$theDate, whichRun = runValueGetter$theRun, weight = profileGetter$userWeight, column = "km", subtitle = "Distance", icon = "distance", color = "green")
stats_server("run_time", df = csvGetter$dt_runs, date = runValueGetter$theDate, whichRun = runValueGetter$theRun, weight = profileGetter$userWeight, column = "time", subtitle = "Minutes", icon = "time", color = "blue") 
stats_server("run_pace", df = csvGetter$dt_runs, date = runValueGetter$theDate, whichRun = runValueGetter$theRun, weight = profileGetter$userWeight, column = "pace", subtitle = "Km/h", icon = "speed", color = "purple")
statsCalories_server("run_calories", df = csvGetter$dt_runs, date = runValueGetter$theDate, whichRun = runValueGetter$theRun, weight = profileGetter$userWeight, column = "pace", subtitle = "Calories", icon = "calories", color = "orange")  
runningMap_server("run_map", df = csvGetter$dt_runs, date = runValueGetter$theDate, whichRun = runValueGetter$theRun)

#-------------------------------- Right Part / Overview Run

runRangeGetter <- selectRunOverview_server("run_overview", df = csvGetter$dt_runs)

runOverview_server("runPace_overview", df = csvGetter$dt_runs, column = "pace", legend ="Pace in km/h", rangeDate = runRangeGetter$theDateRange)
runOverview_server("runDistance_overview", df = csvGetter$dt_runs, column = "km", legend ="Distance in km", rangeDate = runRangeGetter$theDateRange)


#############################
###        BIKING         ###
#############################
#-------------------------------- Left Part / Single Biking

bikeValueGetter <- selectRun_server("bike_date", df = csvGetter$dt_bike) # Get the reactive values from the select fields's runs and use them as parameters for the functions that need those informations

stats_server("bike_distance", df = csvGetter$dt_bike, date = bikeValueGetter$theDate, whichRun = bikeValueGetter$theRun, weight = profileGetter$userWeight, column = "km", subtitle = "Distance", icon = "distance", color = "green")
stats_server("bike_time", df = csvGetter$dt_bike, date = bikeValueGetter$theDate, whichRun = bikeValueGetter$theRun, weight = profileGetter$userWeight, column = "time", subtitle = "Minutes", icon = "time", color = "blue") 
stats_server("bike_pace", df = csvGetter$dt_bike, date = bikeValueGetter$theDate, whichRun = bikeValueGetter$theRun, weight = profileGetter$userWeight, column = "pace", subtitle = "Km/h", icon = "speed", color = "purple")
statsCalories_server("bike_calories", df = csvGetter$dt_bike, date = bikeValueGetter$theDate, whichRun = bikeValueGetter$theRun, weight = profileGetter$userWeight, column = "pace", subtitle = "Calories", icon = "calories", color = "orange")  
runningMap_server("bike_map", df = csvGetter$dt_bike, date = bikeValueGetter$theDate, whichRun = bikeValueGetter$theRun)

#-------------------------------- Right Part / Overview Biking

bikeRangeGetter <- selectRunOverview_server("bike_overview", df = csvGetter$dt_bike)

runOverview_server("bikePace_overview", df = csvGetter$dt_bike, column = "pace", legend ="Pace in km/h", rangeDate = bikeRangeGetter$theDateRange)
runOverview_server("bikeDistance_overview", df = csvGetter$dt_bike, column = "km", legend ="Distance in km", rangeDate = bikeRangeGetter$theDateRange)


}