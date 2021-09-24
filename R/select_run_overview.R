#' UI -> Display the Calendar with range options
selectRunOverview_UI <- function(id) {
    ns <- NS(id)
    fluidRow(class = "date_container",
        tagList(
            airDatepickerInput(
                            inputId = ns("select_date_range"),
                            label = "Select the range",
                            placeholder = "You can pick a date",
                            range = TRUE,
                            update_on = "change",
                            dateFormat = "yyyy-mm-dd",
                            clearButton = TRUE,
                            maxDate = Sys.Date(),
                            disabledDates = disabled_dates),
        )
    )

}

#' Create the Calendar with range options for stats overview
#' Returns a list of reactive :
#' - theRange = Outputs dynamically the selected range date
selectRunOverview_server <- function(id) {
    moduleServer(
        id,
        function(input, output, session) {
            ns <- session$ns
            #we need the ns domain space because we use a renderUI and need to pass the ns from the server and not directly from the UI this time
            #this is needed because we have to store and access the input$select_run as a reactive outside of this module
            #we use this reactive value in running_stats.r

            getDataTable <- reactive({
                #check if empty or not for the req in the rendervalueboxes'
                if (!is.null(input$select_date_range)) {
                    dt_runs[date == input$select_date_range]
                }
            })

            return(
                list(
                    theDateRange = reactive({ format(input$select_date_range) })
                )
            )
        }
    )
}