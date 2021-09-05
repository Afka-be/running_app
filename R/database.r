#contains our csv data
#dt stands for data.table (the package we use with fread)
dt <- fread(file = "csv/running_data.csv")

alldays <- as.character(as.Date(as.Date("1970-01-01"):as.Date(Sys.Date()), origin="1970-01-01"))
dates_to_disable <- as.character(dt$date)

disabled_dates <- setdiff(alldays, dates_to_disable)


