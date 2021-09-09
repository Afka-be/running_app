#' UI -> Display a box to display the stats of the run
#'
stats_UI <- function(id) {
    ns <- NS(id)
    valueBoxOutput(ns("stats"))
}

#' Create a box to display the stats of the run
#' @param date Selected Date of the run
#' @param whichRun Selected run if the Date has multiple runs
#' @param weight User weight stored in profile for the calories maths, etc
#' @param value Displayed value by this box
#' @param column Name of the database/csv's column we want to access
#' @param subtitle Subtitle/description of the value
#' @param icon Icon name and modifiers
#' @param color Box's color CSS. Class styled in custom.css
#'
stats_server <- function(id, date, whichRun, weight, value, column, subtitle, icon, color) {
    moduleServer(
        id,
        function(input, output, session) {

        output$stats <- renderValueBox({
            #if no date is selected, nothing is displayed
            #req is mainly used here to prevent the display of error message if selected date is empty
            req(date())
            getDataTable <- reactive({
                #check if empty or not for the req in the rendervalueboxes
                if (!is.null(date())) {
                    dt_runs[date == date()]
                }
            })
            data <- getDataTable()

            if (data[, .N] > 1) {
                #this mean we have more than 1 run this day, so multiple rows
                #remove " kilometers from the string we get from "input$select_run"
                select_run <- str_remove_all(whichRun(), " kilometers")
                #match the date & distance selected and display the result
                row <- data[km %in% select_run & date %in% date()]
                value <- row[1, column, with = FALSE] #with = FALSE because otherwise, column name via variable does not work
            } else {
                #this means we have only 1 run this day so 1 row
                value <- data[1, column, with = FALSE] #with = FALSE because otherwise, column name via variable does not work
            }

            valueBox(
            value = value,
            subtitle = weight(),
            icon = icon(icon),
            color = color,
            width = 3)
        })

    })
}