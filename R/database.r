#---------------------------------------------- Running Data

# Contains our csv data (Runs)
# dt stands for data.table (the package we use with fread)
dt_runs <- fread(file = "csv/running_data.csv")
# Order by date, ascending
dt_runs <- dt_runs[order(as.Date(dt_runs$date, format="%Y-%m-%d"))]

#---------------------------------------------- Biking Data

# Contains our csv data (Biking)
# dt stands for data.table (the package we use with fread)
dt_bike <- fread(file = "csv/biking_data.csv")
# Order by date, ascending
dt_bike <- dt_bike[order(as.Date(dt_bike$date, format="%Y-%m-%d"))]
