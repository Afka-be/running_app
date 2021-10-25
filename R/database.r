#' Function that returns the databases we need the get the values from based on the user profile selected
#' @param user_id Select the of the user profile currently selected
#'
selectDatabase_server <- function(id, user_id) {
    moduleServer(
        id,
        function(input, output, session) {

        #---------------------------------------------- Running Data

        # Contains our csv data (Runs)
        # dt stands for data.table (the package we use with fread)
        
        #dt_runs <- reactiveFileReader(1000, NULL, "csv/running/running_data_2.csv", fread)

        dt_runs <- fread(file = paste0("csv/running/running_data_1.csv"))
        dt_runs <- dt_runs[order(as.Date(dt_runs$date, format="%Y-%m-%d"))]

        dt_runs2 <- reactive({
            dt_runs2 <- fread(file = paste0("csv/running/running_data_", user_id(), ".csv"))
            dt_runs2 <- dt_runs2[order(as.Date(dt_runs2$date, format="%Y-%m-%d"))]
            return(dt_runs2)
        })
        #observe({
        #    view(dt_runs2())
        #})

        #print(dt_runs())
  
        #observe(dt_runs <- fread(file = paste("csv/running/running_data_", user_id(), ".csv", sep="")))
        # Order by date, ascending
        #dt_runs2 <- dt_runs2[order(as.Date(dt_runs$date, format="%Y-%m-%d"))]
        

        #---------------------------------------------- Biking Data

        # Contains our csv data (Biking)
        # dt stands for data.table (the package we use with fread)
        #observe(dt_bike <- reactiveFileReader(1000, NULL, paste("csv/biking/biking_data_", user_id(), ".csv", sep =""), fread))
        dt_bike <- fread(file = "csv/biking/biking_data_1.csv")
        #observe(dt_bike <- fread(file = paste("csv/biking/biking_data_", user_id(), ".csv", sep="")))
        # Order by date, ascending
        dt_bike <- dt_bike[order(as.Date(dt_bike$date, format="%Y-%m-%d"))]

        dt_bike2 <- reactive({
            dt_bike2 <- fread(file = paste0("csv/biking/biking_data_", user_id(), ".csv"))
            dt_bike2 <- dt_bike2[order(as.Date(dt_bike2$date, format="%Y-%m-%d"))]
            return(dt_bike2)
        })


        return(
                list(
                    dt_runs = dt_runs2,
                    dt_bike = dt_bike2
                )
            )
    })
}

