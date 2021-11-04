#' UI -> Display a box to display the stats of the run
#'
stats_UI <- function(id) {
    ns <- NS(id)
    uiOutput(ns("stats"))
}

#' UI -> Display a box to display the Calories of the run
#'
statsCalories_UI <- function(id) {
    ns <- NS(id)
    uiOutput(ns("stats"))
}

#' Create a box to display the general stats of the run
#' @param df Select the dataframe to extract informations and stats from
#' @param date Selected Date of the run
#' @param whichRun Selected run if the Date has multiple runs
#' @param weight User weight stored in profile for the calories maths, etc
#' @param value Displayed value by this box
#' @param column Name of the database/csv's column we want to access
#' @param subtitle Subtitle/description of the value
#' @param icon Icon name and modifiers
#' @param color Box's color CSS. Class styled in custom.css
#'
stats_server <- function(id, df, date, whichRun, weight, value, column, subtitle, icon, color) {
    moduleServer(
        id,
        function(input, output, session) {

        output$stats <- renderUI({
            #if no date is selected, nothing is displayed
            #req is mainly used here to prevent the display of error message if selected date is empty
            req(date())
            getDataTable <- reactive({
                #check if empty or not for the req in the rendervalueboxes
                if (!is.null(date())) {
                    df()[date == date()]
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

            #Append values to the global list parameters for markdown report
            observe({
                # because the values are scattered between multiple calls of this function
                # we need to use a few more steps so we can have dynamic names based on the column parameter
                
                runstats <- list(value) # create a list that contains the value
                names(runstats) <- column # assign a dynamic name based on the column parameter used in server.r (km, time and pace)
                run_params <<- append(run_params, runstats) # append the new list
                # now, run_params$km, run_params$time and run_params$pace all have the correct values
                # and because we have dynamic names created for each call, they all coexist without erasing themselves
            })


            HTML(paste0("<div class = 'custom_card'>",
                        "<div class = 'icon_card icon_",color,"'>",
                        "<img src='images/",icon,".svg'>",
                        "</div>",
                        "<p>", subtitle, "</p>",
                        "<h3>", value, "</h3>",
                        "</div>"),
                        sep = "")

        })

    })
}



#' Create a box to display the calories stats of the run
#' @param df Select the dataframe to extract informations and stats from
#' @param date Selected Date of the run
#' @param whichRun Selected run if the Date has multiple runs
#' @param weight User weight stored in profile for the calories maths, etc
#' @param value Displayed value by this box
#' @param subtitle Subtitle/description of the value
#' @param icon Icon name and modifiers
#' @param color Box's color CSS. Class styled in custom.css
#'
statsCalories_server <- function(id, df, date, whichRun, weight, value, column, subtitle, icon, color) {
    moduleServer(
        id,
        function(input, output, session) {

        output$stats <- renderUI({
            #if no date is selected, nothing is displayed
            #req is mainly used here to prevent the display of error message if selected date is empty
            req(date())
            getDataTable <- reactive({
                #check if empty or not for the req in the rendervalueboxes
                if (!is.null(date())) {
                    df()[date == date()]
                }
            })
            data <- getDataTable()

            if (data[, .N] > 1) {
                #this mean we have more than 1 run this day, so multiple rows
                #remove " kilometers from the string we get from "input$select_run"
                select_run <- str_remove_all(whichRun(), " kilometers")
                #match the date & distance selected and display the result
                row <- data[km %in% select_run & date %in% date()]

                value <- as.integer(as.numeric(weight()) * 1.028 * row[1, km]) #calories lost => 1.028kcal * weight in kg * distance in km
            } else {
                #this means we have only 1 run this day so 1 row
                value <- as.integer(as.numeric(weight()) * 1.028 * data[1, km]) #calories lost => 1.028kcal * weight in kg * distance in km
            }

            observe({
                run_params <<- append(run_params, list(calories = value ))
            })

            HTML(paste0("<div class = 'custom_card'>",
                        "<div class = 'icon_card icon_",color,"'>",
                        "<img src='images/",icon,".svg'>",
                        "</div>",
                        "<p>", subtitle, "</p>",
                        "<h3>", value, "</h3>",
                        "</div>"),
                        sep = "")

        })

    })
}