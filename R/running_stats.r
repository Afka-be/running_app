stats_UI <- function(id) {
    ns <- NS(id)
    valueBoxOutput(ns("stats"))
}

stats_server <- function(id, date, whichRun, value, column, subtitle, icon, color) {
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
                    dt[date == date()]
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
            #     #this means we have only 1 run this day so 1 row
                 value <- data[1, column, with = FALSE] #with = FALSE because otherwise, column name via variable does not work
            }

            valueBox(
            value = value,
            subtitle = subtitle,
            icon = icon(icon),
            color = color,
            width = 3)
        })

    })
}