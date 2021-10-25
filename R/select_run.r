#' UI -> Display the Calendar and the run select dropdown
selectRun_UI <- function(id) {
    ns <- NS(id)

    fluidRow(class = "date_container",
        tagList(
            uiOutput(ns("runCalendar")),
            uiOutput(ns("selectIfMultipleRunsPerDay"))
        )
    )

}

#' Create the Calendar and the run select dropdown
#' @param df Dataframe containing the discipline's dates to enable in the calendar
#' The select_run dropdown only appears when a day contains multiple runs
#' Returns a list of reactive :
#' - theDate = Outputs dynamically the selected date
#' - theRun = Outputs dynamically the selected if multiple runs that date
selectRun_server <- function(id, df) {
    moduleServer(
        id,
        function(input, output, session) {
            ns <- session$ns
            #we need the ns domain space because we use a renderUI and need to pass the ns from the server and not directly from the UI this time
            #this is needed because we have to store and access the input$select_run as a reactive outside of this module
            #we use this reactive value in running_stats.r

            disabled_dates <- reactive({
                alldays <- as.character(as.Date(as.Date("1970-01-01"):as.Date(Sys.Date()), origin="1970-01-01"))
                dates_to_disable <- as.character(df()$date)

                # Vector of all the dates not selectable (the dates without data/runs)
                # Difference between all the existing days and the dates from the Runs data.table
                disabled_dates <- setdiff(alldays, dates_to_disable)
                return(disabled_dates)
            })
            
            output$runCalendar <- renderUI(
                airDatepickerInput(
                            inputId = ns("select_date"),
                            label = "Select the day",
                            placeholder = "You can pick a date",
                            update_on = "change",
                            dateFormat = "yyyy-mm-dd",
                            clearButton = TRUE,
                            maxDate = Sys.Date(),
                            disabledDates = disabled_dates()),
            )

            getDataTable <- reactive({
                #check if empty or not for the req in the rendervalueboxes'
                if (!is.null(input$select_date)) {
                    df()[date == input$select_date]
                }
            })
           

            output$selectIfMultipleRunsPerDay <- renderUI({
                req(input$select_date)
                data <- getDataTable()
                if (data[, .N] > 1) {
                    #A day can contain multiple runs, we need a second selectInput for this case
                    #if we have more than 1 row for this date, we have multiple runs
                    #create a vector of the runs and add a string to each element
                    d <- data[, km]
                    distance <- paste(d, "kilometers", sep = " ")
                    selectInput(ns("select_run"), "Which run do you want to check ?", choices = distance)
                }
            })

            return(
                list(
                    theDate = reactive({ input$select_date }),
                    theRun = reactive({ input$select_run })
                )
            )
        }
    )
}