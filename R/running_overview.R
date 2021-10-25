#' UI -> Display a box to display the stats of the run
runOverview_UI <- function(id) {
    ns <- NS(id)
    tagList(
        # We MUST load the ECharts javascript library in advance
        loadEChartsLibrary(),
        loadEChartsTheme("dark-digerati"),
        column(8,
            tags$div(id=paste(id, "div", sep = "_"), style="width:100%;height:200px;padding:15px;"),
            deliverChart(div_id = ns(paste(id, "div", sep = "_")))
        ),
        verbatimTextOutput(ns("rangedate")),
    )
}

#' Create the Overview statisticts part for a ranged selection Date
#' Produces linecharts
#' @param rangeDate Selected rangeDate from select_run_overview.R
#' @param df Select the dataframe to extract informations and stats from
#' @param column Name of the csv's column we want to display the data from
#' @param legend String of characters to describe the chart's utility
runOverview_server <- function(id, df, column, legend, rangeDate) {
    moduleServer(
        id,
        function(input, output, session) {
            ns <- session$ns
            #we need the ns domain space because we use a renderUI and need to pass the ns from the server and not directly from the UI this time

            output$rangedate <- renderText(
                paste(rangeDate()[1], rangeDate()[2])
            )

            # Preparing data for the graph inside a reactive
            # Changes everytime we use the range date picker
            rangeDateChart <- reactive({
                raw <- df()[date >= as.Date(rangeDate()[1], format="%Y-%m-%d") & date <= as.Date(rangeDate()[2],  format="%Y-%m-%d")]
                rangeDatedf <- data.frame(raw[, column, with = FALSE])
                rangedfHours <- paste(raw$date, raw$hour, sep ="-")

                names(rangeDatedf) <- c(legend)
                row.names(rangeDatedf) <- rangedfHours
                return(rangeDatedf)
            })
            
            observeEvent(
                eventExpr = rangeDateChart(),
                # Reloads everytime we use the range date picker
                handlerExpr = {
                    req(rangeDate()[1])
                    req(rangeDate()[2])
                    renderLineChart(div_id = paste(id, "div", sep = "_"),
                                    data = rangeDateChart(), # Returns the ranged
                                    line.width = c(2),
                                    line.type = c("solid"),
                                    #theme = "dark-digerati",
                                    point.size = c(10),
                                    point.type = c("emptyCircle"))
                }
                
            )
        })
}
