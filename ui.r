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
      tags$div(class = "user-container",
        box(h1("Welcome"), title = "Profile", collapsible = FALSE, width = 16, color = "orange",
          userProfile_UI("init")
        )
      ), #tags$div(class="run-container"
      menuItem(tabName = "homepage", "Homepage", icon = icon("address card")),
      menuItem(tabName = "running", "Running", icon = icon("dashboard")),
      menuItem(tabName = "biking", "Biking", icon = icon("dashboard"))
    )
  ),
  dashboardBody(
    # include the CSS file
    tags$head(
      tags$link(rel = "stylesheet", type = "text/css", href = "style/custom.css"),
      tags$head(tags$script(src="script/custom.js"))
    ),
    #load the dependecies of packages 
    useShinyjs(),

    tabItems(
      selected = 1,
      tabItem(
        tabName = "homepage",
        box(h1("SPEEDMETER APP"), title = "How to use", width = 16, color = "orange",
          "With this app, you can keep track of your various performances and analyze your evolution through your trainings.",
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
                  runningMap_UI("run_map"),
                ) #tags$div(class="run-container"
            ), #fluidRow
          ), #column
          column(8, class = "ui-container",
            fluidRow(
              tags$div(class = "run-overview-container",
                selectRunOverview_UI("run_overview"),
                runOverview_UI("runPace_overview"),
                runOverview_UI("runDistance_overview")
              ) #tags$div(class = "run-overview-container"
            ), #fluidRow
          ),
          column(16, class = "ui-container",
            fluidRow(
                addRun_UI("run_add")
            ) # fluidRow
          ),
           #column
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
                  runningMap_UI("bike_map"),
                ) #tags$div(class="run-container"
            ), #fluidRow
          ), #column
          column(8, class = "ui-container",
            fluidRow(
              tags$div(class = "run-overview-container",
                selectRunOverview_UI("bike_overview"),
                runOverview_UI("bikePace_overview"),
                runOverview_UI("bikeDistance_overview")
              ) #tags$div(class = "run-overview-container"
            ), #fluidRow
          ), #column
          column(16, class = "ui-container",
            fluidRow(
                addRun_UI("bike_add")
            ) # fluidRow
          ),
        ) #tabName biking
    ) #tabItems
  )
)