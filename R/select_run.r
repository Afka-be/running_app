#' UI -> Display the Calendar and the run select dropdown
selectRun_UI <- function(id) {
    ns <- NS(id)
    tagList(
        airDatepickerInput(
                        inputId = ns("select_date"),
                        label = "Select the day",
                        placeholder = "You can pick a date",
                        update_on = "change",
                        dateFormat = "yyyy-mm-dd",
                        clearButton = TRUE,
                        maxDate = Sys.Date(),
                        disabledDates = disabled_dates),
        uiOutput(ns("selectIfMultipleRunsPerDay"))
    )

}

#' Create the Calendar and the run select dropdown
#' The run select dropdown only appears when a day contains multiple runs
#' Returns a list of reactive :
#' - theDate = Outputs dynamically the selected date
#' - theRun = Outputs dynamically the selected if multiple runs that date
selectRun_server <- function(id) {
    moduleServer(
        id,
        function(input, output, session) {
            ns <- session$ns
            #we need the ns domain space because we use a renderUI and need to pass the ns from the server and not directly from the UI this time
            #this is needed because we have to store and access the input$select_run as a reactive outside of this module
            #we use this reactive value in running_stats.r

            getDataTable <- reactive({
                #check if empty or not for the req in the rendervalueboxes'
                if (!is.null(input$select_date)) {
                    dt_runs[date == input$select_date]
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