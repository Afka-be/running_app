runOverview_UI <- function(id) {
    ns <- NS(id)
    tagList(
        # We MUST load the ECharts javascript library in advance
        loadEChartsLibrary(),
        column(8,
            tags$div(id="pace_overview", style="width:100%;height:400px;"),
            deliverChart(div_id = ns("pace_overview"))
        ),
        verbatimTextOutput(ns("rangedate")),
    )
}

#' Create the Overview statisticts part for a ranged selection Date
#' Produces linecharts
#' @param rangeDate Selected rangeDate from select_run_overview.R
runOverview_server <- function(id, rangeDate) {
    moduleServer(
        id,
        function(input, output, session) {
            output$rangedate <- renderText(
                paste(rangeDate()[1], rangeDate()[2])
                
            )

            # Preparing data for the graph inside a reactive
            # Changes everytime we use the range date picker
            rangeDateChart <- reactive({
                raw <- dt_runs[date >= as.Date(rangeDate()[1], format="%Y-%m-%d") & date <= as.Date(rangeDate()[2],  format="%Y-%m-%d")]
                rangeDatedf <- data.frame(raw$pace)
                rangedfHours <- paste(raw$date, raw$hour, sep ="-")

                names(rangeDatedf) <- c("Pace in km/h")
                row.names(rangeDatedf) <- rangedfHours
                return(rangeDatedf)
            })
            
            observeEvent(
                eventExpr = rangeDateChart(),
                # Reloads everytime we use the range date picker
                handlerExpr = {
                    req(rangeDate()[1])
                    req(rangeDate()[2])
                    renderLineChart(div_id = "pace_overview",
                                    data = rangeDateChart(), # Returns the ranged
                                    line.width = c(2),
                                    line.type = c("solid"),
                                    point.size = c(10),
                                    point.type = c("emptyCircle"))
                }
                
            )
        })
}
