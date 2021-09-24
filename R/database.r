#---------------------------------------------- Running Data

# Contains our csv data (Runs)
# dt stands for data.table (the package we use with fread)
dt_runs <- fread(file = "csv/running_data.csv")
# Order by date, ascending
dt_runs <- dt_runs[order(as.Date(dt_runs$date, format="%Y-%m-%d"))]

alldays <- as.character(as.Date(as.Date("1970-01-01"):as.Date(Sys.Date()), origin="1970-01-01"))
dates_to_disable <- as.character(dt_runs$date)

# Vector of all the dates not selectable (the dates without data/runs)
# Difference between all the existing days and the dates from the Runs data.table
disabled_dates <- setdiff(alldays, dates_to_disable)

