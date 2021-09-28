server <- function(input, output, session) {

#-------------------------------- Initialization

userProfile_server("init") # Initialize user profile (weight, etc)
profileGetter <- userProfile_server("init") # Get the reactive values from the userprofile and use them as parameters for the functions that need those informations


#############################
###       RUNNING         ###
#############################
#-------------------------------- Left Part / Single Run

selectRun_server("run_date", df = dt_runs)

runValueGetter <- selectRun_server("run_date", df = dt_runs) # Get the reactive values from the select fields's runs and use them as parameters for the functions that need those informations


stats_server("run_distance", df = dt_runs, date = runValueGetter$theDate, whichRun = runValueGetter$theRun, weight = profileGetter$userWeight, column = "km", subtitle = "Distance", icon = "distance", color = "green")
stats_server("run_time", df = dt_runs, date = runValueGetter$theDate, whichRun = runValueGetter$theRun, weight = profileGetter$userWeight, column = "time", subtitle = "Minutes", icon = "time", color = "blue") 
stats_server("run_pace", df = dt_runs, date = runValueGetter$theDate, whichRun = runValueGetter$theRun, weight = profileGetter$userWeight, column = "pace", subtitle = "Km/h", icon = "speed", color = "purple")
statsCalories_server("run_calories", df = dt_runs, date = runValueGetter$theDate, whichRun = runValueGetter$theRun, weight = profileGetter$userWeight, column = "pace", subtitle = "Calories", icon = "calories", color = "orange")  
runningMap_server("run_map", df = dt_runs, date = runValueGetter$theDate, whichRun = runValueGetter$theRun)

#-------------------------------- Right Part / Overview Run

selectRunOverview_server("run_overview", df = dt_runs)

runRangeGetter <- selectRunOverview_server("run_overview", df = dt_runs)

runOverview_server("runPace_overview", df = dt_runs, column = "pace", legend ="Pace in km/h", rangeDate = runRangeGetter$theDateRange)
runOverview_server("runDistance_overview", df = dt_runs, column = "km", legend ="Distance in km", rangeDate = runRangeGetter$theDateRange)


#############################
###        BIKING         ###
#############################
#-------------------------------- Left Part / Single Biking

selectRun_server("bike_date", df = dt_bike)

bikeValueGetter <- selectRun_server("bike_date", df = dt_bike) # Get the reactive values from the select fields's runs and use them as parameters for the functions that need those informations

stats_server("bike_distance", df = dt_bike, date = bikeValueGetter$theDate, whichRun = bikeValueGetter$theRun, weight = profileGetter$userWeight, column = "km", subtitle = "Distance", icon = "distance", color = "green")
stats_server("bike_time", df = dt_bike, date = bikeValueGetter$theDate, whichRun = bikeValueGetter$theRun, weight = profileGetter$userWeight, column = "time", subtitle = "Minutes", icon = "time", color = "blue") 
stats_server("bike_pace", df = dt_bike, date = bikeValueGetter$theDate, whichRun = bikeValueGetter$theRun, weight = profileGetter$userWeight, column = "pace", subtitle = "Km/h", icon = "speed", color = "purple")
statsCalories_server("bike_calories", df = dt_bike, date = bikeValueGetter$theDate, whichRun = bikeValueGetter$theRun, weight = profileGetter$userWeight, column = "pace", subtitle = "Calories", icon = "calories", color = "orange")  
runningMap_server("bike_map", df = dt_bike, date = bikeValueGetter$theDate, whichRun = bikeValueGetter$theRun)

#-------------------------------- Right Part / Overview Biking

selectRunOverview_server("bike_overview", df = dt_bike)

bikeRangeGetter <- selectRunOverview_server("bike_overview", df = dt_bike)

runOverview_server("bikePace_overview", df = dt_bike, column = "pace", legend ="Pace in km/h", rangeDate = bikeRangeGetter$theDateRange)
runOverview_server("bikeDistance_overview", df = dt_bike, column = "km", legend ="Distance in km", rangeDate = bikeRangeGetter$theDateRange)


}