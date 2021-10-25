#' UI -> Display the Calendar with range options
selectRunOverview_UI <- function(id) {
    ns <- NS(id)

    fluidRow(class = "date_container",
        tagList(
            uiOutput(ns("runCalendarOverview"))
        )
    )

}

#' Create the Calendar with range options for stats overview
#' @param df Dataframe containing the discipline's dates to enable in the calendar
#' Returns a list of reactive :
#' - theRange = Outputs dynamically the selected range date
selectRunOverview_server <- function(id, df) {
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

            output$runCalendarOverview <- renderUI(
                airDatepickerInput(
                            inputId = ns("select_date_range"),
                            label = "Select the range",
                            placeholder = "You can pick a date",
                            range = TRUE,
                            update_on = "change",
                            dateFormat = "yyyy-mm-dd",
                            clearButton = TRUE,
                            maxDate = Sys.Date(),
                            disabledDates = disabled_dates()),
            )

            return(
                list(
                    theDateRange = reactive({ format(input$select_date_range) })
                )
            )
        }
    )
}