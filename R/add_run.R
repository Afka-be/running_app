#' UI => Display a new box of fields to let you add a new row to the run's CSV
addRun_UI <- function(id){
    ns <- NS(id)
    tagList(
        actionButton(ns("btn_display_add_run"), "Add a new run"),
        tags$div(class = "add-container",
            h3("Add a new entry for this discipline"),
            div(class = "add-fields",
                airDatepickerInput(ns("addNewRunDate"), "Enter the date", placeholder = "Enter the date"),
                textInput(ns("addNewRunHour"), "Enter the hour", placeholder = "08:00"),
                textInput(ns("addNewRunDistance"), "Enter the distance in km", placeholder = "15"),
                textInput(ns("addNewRunTime"), "Enter the total time in minutes", placeholder = "25"),
                textInput(ns("addNewRunPace"), "Enter the pace in km/h", placeholder = "7"),
                textInput(ns("addNewRunLatStart"), "Enter the start latitude", placeholder = "50.93901129"),
                textInput(ns("addNewRunLongStart"), "Enter the start longitude", placeholder = "4.6064235"),
                textInput(ns("addNewRunLatFinish"), "Enter the finish latitude", placeholder = "50.72746801"),
                textInput(ns("addNewRunLongFinish"), "Enter the finish longitude", placeholder = "4.29814105")
            ),
            div(class = "add-button",
                actionButton(ns("btn_confirm_add_run"), "Add this run")
            )
        ) #tags$div(class="run-container"
    )
}

#' Open a new box of fields to let you add a new row to the run's CSV
#' @param discipline Character string, equals to the current discipline tab. Must match the CSV's naming system
#' @param user_id Id of the active user. Reactive. Used to append the line to the correct CSV (the CSV of the active user)
addRun_server <- function(id, user_id, discipline) {
    moduleServer(
        id,
        function(input, output, session) {
            ns <- session$ns

            # Submit check conditions => If a field is empty, disable the submit button to append the row
            # This is to prevent people from sending empty values to the CSV's
            observe({
                if( is.null(input$addNewRunDate) || input$addNewRunDistance == "" || input$addNewRunHour == "" || input$addNewRunTime == "" || input$addNewRunPace == "" || input$addNewRunLatStart == "" || input$addNewRunLongStart == "" || input$addNewRunLatFinish == "" || input$addNewRunLongFinish == ""){
                    disable("btn_confirm_add_run")
                } else {
                    enable("btn_confirm_add_run")
                }
            })

            observeEvent(
                eventExpr = input$btn_confirm_add_run,
                handlerExpr = {

                    # Add a new row to the discipline's CSV
                    newRun = data.table(date = format(input$addNewRunDate), hour = input$addNewRunHour, km = input$addNewRunDistance, time = input$addNewRunTime, pace = input$addNewRunPace, lat_start = input$addNewRunLatStart, long_start = input$addNewRunLongStart, lat_finish = input$addNewRunLatFinish, long_finish = input$addNewRunLongFinish)

                    # Append this row to the discipline's CSV
                    write.table(newRun, paste0("csv/", discipline, "/", discipline,"_data_", user_id() ,".csv"), row.names = FALSE, col.names = FALSE, append = TRUE, sep=";") 
                    
                }
            )

        }
    )
}