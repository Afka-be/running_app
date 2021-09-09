userProfile_UI <- function(id){
    ns <- NS(id)
    tagList(
        textOutput(ns("currentWeight")),
        actionButton(ns("button_modal"), "Change the weight")
    )
}

userProfile_server <- function(id) {
    moduleServer(
        id,
        function(input, output, session) {
            ns <- session$ns
            userWeight <- reactiveVal(0) # Initialize weight reactiveVal

            if(file.exists("csv/profile.csv")) {
                userProfile <- fread(file = "csv/profile.csv")
                userWeight(userProfile[1, weight]) # Update weight reactiveVal with value stored in CSV
            } else {
                create_modal(modal(
                    id = "modal_weight",
                    header = h2("Important message"),
                    selectInput(ns("enterWeight"), "Enter your weight (in kg)", c(10:200))
                ))
            }
            observeEvent(
            eventExpr = input$enterWeight,
            handlerExpr = {
                newWeight = data.table(weight = input$enterWeight)
                write.csv(newWeight, "csv/profile.csv", row.names = FALSE)
                userWeight(input$enterWeight) # Update weight reactiveVal with the weight entered if CSV does not exist
            }
            )
            # If need to change weight, click input$button_modal and create new modal
            observeEvent(
                eventExpr = input$button_modal,
                handlerExpr = {
                create_modal(modal(
                    id = "modal_new_weight",
                    header = "Select your weight",
                    # create a select input for the new Weight
                    selectInput(ns("enterNewWeight"), "Enter your weight (in kg)", c(10:200))
                ))
            })
            # Use the new weight entered in the recently created modal with the new selectInput
            observeEvent(
                eventExpr = input$enterNewWeight,
                handlerExpr = {
                # Create a profile.csv again
                newWeight = data.table(weight = input$enterNewWeight)
                write.csv(newWeight, "csv/profile.csv", row.names = FALSE)
                userWeight(input$enterNewWeight) # Update weight reactiveVal
            })
            
            output$currentWeight <- renderText({
                paste("Currently selected weight :", userWeight(), "kg", sept = " ")
            })

            return(
                list(
                    userWeight = reactive({ userWeight() })
                )
            )

        }
    )
}