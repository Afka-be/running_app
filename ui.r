ui <- dashboardPage(
  margin = FALSE,
  dashboardHeader(title = tags$div(class = 'running_logo',
                            tags$img(src='images/logo_app.svg'),
                          ),
                  logo_path = "images/logo.svg",
                  logo_align = "right",
                  inverted = TRUE,
                  dropdownMenu(type = "notifications",
                    taskItem("Project progress...", 50.777, color = "red")
                  )
                ),

  dashboardSidebar(
    size = "wide",
    inverted = TRUE,
    sidebarMenu(
      menuItem(tabName = "homepage", "Homepage", icon = icon("dashboard")),
      menuItem(tabName = "running", "Running", icon = icon("address card")),
      menuItem(tabName = "biking", "Biking", icon = icon("address card"))
    )
  ),
  dashboardBody(
    # include the CSS file
    tags$head(
      tags$link(rel = "stylesheet", type = "text/css", href = "style/custom.css"),
      tags$head(tags$script(src="script/custom.js"))
    ),
    #load the dependecies of "prompter" package so we can have tooltips
    use_prompt(),


    tabItems(
      selected = 1,
      tabItem(
        tabName = "homepage",
        box(h1("Welcome"), title = "How to use", width = 16, color = "orange",
          "This is SpeedMeter App. 
          Here you can check your various performances analyze your evolution through your trainings.",
          userProfile_UI("init")
        )
      ),
      tabItem(
        tabName = "running",
          column(8, class = "ui-container",
            fluidRow(
                tags$div(class = "run-container",
                  selectRun_UI("run_date"),
                  fluidRow(class = "stats-container",
                    stats_UI("run_distance"),
                    stats_UI("run_time"),
                    stats_UI("run_pace"),
                    statsCalories_UI("run_calories"),
                  ), #fluidRow
                  runningMap_UI("run_map")
                ) #tags$div(class="run-container"
            ), #fluidRow
            fluidRow(
            ) #fluidRow
          ), #column
          column(8, class = "ui-container",
            fluidRow(
              tags$div(class = "run-overview-container",
                selectRunOverview_UI("run_overview"),
                runOverview_UI("runPace_overview"),
                runOverview_UI("runDistance_overview")
              ) #tags$div(class = "run-overview-container"
            ), #fluidRow
          ) #column
        ), #tabName running
        tabItem(
        tabName = "biking",
          column(8, class = "ui-container",
            fluidRow(
                tags$div(class = "run-container",
                  selectRun_UI("bike_date"),
                  fluidRow(class = "stats-container",
                    stats_UI("bike_distance"),
                    stats_UI("bike_time"),
                    stats_UI("bike_pace"),
                    statsCalories_UI("bike_calories"),
                  ), #fluidRow
                  runningMap_UI("bike_map")
                ) #tags$div(class="run-container"
            ), #fluidRow
            fluidRow(
            ) #fluidRow
          ), #column
          column(8, class = "ui-container",
            fluidRow(
              tags$div(class = "run-overview-container",
                selectRunOverview_UI("bike_overview"),
                runOverview_UI("bikePace_overview"),
                runOverview_UI("bikeDistance_overview")
              ) #tags$div(class = "run-overview-container"
            ), #fluidRow
          ) #column
        ) #tabName biking
    ) #tabItems
  )
)