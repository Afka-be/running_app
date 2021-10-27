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

        dt_runs <- reactive({
            dt_runs <- fread(file = paste0("csv/running/running_data_", user_id(), ".csv"))
            # Order by date, ascending
            dt_runs <- dt_runs[order(as.Date(dt_runs$date, format="%Y-%m-%d"))]
            return(dt_runs)
        })


        #---------------------------------------------- Biking Data

        # Contains our csv data (Biking)
        # dt stands for data.table (the package we use with fread)

        dt_bike <- reactive({
            dt_bike <- fread(file = paste0("csv/biking/biking_data_", user_id(), ".csv"))
            # Order by date, ascending
            dt_bike <- dt_bike[order(as.Date(dt_bike$date, format="%Y-%m-%d"))]
            return(dt_bike)
        })

        return(
                list(
                    dt_runs = dt_runs,
                    dt_bike = dt_bike
                )
            )
    })
}

