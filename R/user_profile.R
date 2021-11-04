userProfile_UI <- function(id){
    ns <- NS(id)
    tagList(
        h3("Username : ", textOutput(ns("currentUser"), inline=T)),
        h3("Weight : ", textOutput(ns("currentWeight"), inline=T)),
        uiOutput(ns("selectProfile")),
        actionButton(ns("btn_edit_profile_modal"), "Edit the name / weight"),
        actionButton(ns("btn_add_profile_modal"), "Create a new profile")
    )
}

userProfile_server <- function(id) {
    moduleServer(
        id,
        function(input, output, session) {
            ns <- session$ns
            userId <- reactiveVal(1) # Initialize Id reactiveVal
            userName <- reactiveVal(0) # Initialize Name reactiveVal
            userWeight <- reactiveVal(0) # Initialize weight reactiveVal
            # We also create a reactiveFileReader so the dropdown to select the user can refresh while the app is running
            # More info in the SELECT A PROFILE part
            reactiveUserData <- reactiveFileReader(1000, NULL, 'csv/profile.csv', fread)

            if(file.exists("csv/profile.csv")) {
                # If there is already data for existing users
                userProfile <- fread(file = "csv/profile.csv")
                userId(userProfile[1, id]) # Update Id reactiveVal with value stored in CSV)
                userName(userProfile[1, name]) # Update name reactiveVal with value stored in CSV
                userWeight(userProfile[1, weight]) # Update weight reactiveVal with value stored in CSV
            } else {
                # Establish a database for userprofiles. 
                # We need a persistent database exported in CSV. This way, we keep the data in a csv file which lives even when we shutoff the app
                # Create the first user/profile
                create_modal(modal(
                    id = "modal_first_profile",
                    header = "Create your first profile",
                    textInput(ns("enterName"), "Enter your name"),
                    selectInput(ns("enterWeight"), "Enter your weight (in kg)", c(10:200))
                ))
            }
            observeEvent(
                eventExpr = {
                    input$enterName
                    input$enterWeight
                },
                handlerExpr = {
                    newProfile = data.table(id = 1, name = input$enterName, weight = input$enterWeight) # id = 1 because first user to ever use the app
                    write.table(newProfile, "csv/profile.csv", row.names = FALSE, sep=";")
                    userId(1) # Update Id reactiveVal with 1 because in this case, it's always the first user created
                    userName(input$enterName) # Update name reactiveVal with the name entered if CSV does not exist
                    userWeight(input$enterWeight) # Update weight reactiveVal with the weight entered if CSV does not exist
                }
            )

            #######################################
            # ADD PROFILE
            #######################################
            observeEvent(
                eventExpr = input$btn_add_profile_modal,
                handlerExpr = {
                    create_modal(modal(
                        id = "modal_add_profile",
                        header = "Create a new profile user",
                        footer = actionButton(ns("btn_confirm_add_profile"), "Create this profile"),
                        textInput(ns("addNewName"), "Enter your name", placeholder = "Enter your name"),
                        selectInput(ns("addNewWeight"), "Enter your weight (in kg)", c(10:200))                   
                    ))
                }
            )
            observeEvent(
                eventExpr = input$btn_confirm_add_profile,
                handlerExpr = {
                    # Incremented ID based on previous user created
                    userProfile <- fread(file = "csv/profile.csv")
                    lastUserId = tail(userProfile, n = 1) # Select the last row of the dataframe, the "tail"
                    incrementedId =  lastUserId[1, id] + 1

                    # Add a new row to profile.csv 
                    createProfile = data.table(id = incrementedId, name = input$addNewName, weight = input$addNewWeight)
                    write.table(createProfile, "csv/profile.csv", row.names = FALSE, col.names=FALSE, sep=";", append=TRUE)
                    
                    # Add new dummy CSVs for each disciplines specifically for this new user
                    createCsvs = data.table(date = "1990-01-01", hour = "08:00", km = "0", time = "0", pace = "0", lat_start = "50", long_start = "4", lat_finish = "50", long_finish = "4")
                    
                    # But don't erase the CSV if it already exist
                    if(!file.exists(paste0("csv/running/running_data_", incrementedId ,".csv"))) {
                        write.table(createCsvs, paste0("csv/running/running_data_", incrementedId ,".csv"), row.names = FALSE, sep=";") #CSV for running
                    }
                    if(!file.exists(paste0("csv/biking/biking_data_", incrementedId ,".csv"))) {
                        write.table(createCsvs, paste0("csv/biking/biking_data_", incrementedId ,".csv"), row.names = FALSE, sep=";") #CSV for biking
                    }

                    # Update the reactive values
                    userName(input$addNewName) # Update name reactiveVal
                    userWeight(input$addNewWeight) # Update weight reactiveVal
                    removeModal()
                }
            )

            #######################################
            # SELECT A PROFILE
            #######################################
            output$selectProfile <- renderUI({
                
                # reactiveUserData is a reactive data.table with our profile.csv
                # The data.table updates everytime we use for example write.csv and erase our previous profile.csv
                # This allows us to always refresh the users list dropdown with the most recent updates in users database.

                # Display ID and the corresponding names of users. ID is column 1 and name is column 2
                profiles <- paste(as.character(reactiveUserData()[[1]]),as.character(reactiveUserData()[[2]]), sep = " - ")
                selectInput(ns("profiles_dropdown"), "You can select another profile :", profiles)
            })
            observeEvent(
                eventExpr = input$profiles_dropdown,
                handlerExpr = {
                    # Isolate the ID from the select profile dropdown string. We split at the first space
                    splitProfile <- strsplit(input$profiles_dropdown, " ")
                    # splitProfile contains a list, but list are tricky to use so we will unlist it
                    # It makes it easier to retrieve data. We can use splitProfile[1] instead of splitProfile[[1]][1] to get the first element of the split
                    splitProfile <- unlist(splitProfile)
                    # Return the ID from the split string () and store it
                    selectedID <- splitProfile[1]

                    # Search for the values and put them in reactive
                    df <- fread(file = "csv/profile.csv")
                    selectedRow <- df[id == selectedID]
                    selectedName <- selectedRow[1, name]
                    selectedWeight <- selectedRow[1, weight]
                    userId(selectedID) # Update Id reactiveVal
                    userName(selectedName) # Update name reactiveVal
                    userWeight(selectedWeight) # Update weight reactiveVal
                }
            )

            #######################################
            # EDIT CURRENT PROFILE
            #######################################
            # If need to change infos, click input$btn_edit_profile_modal and create new modal
            observeEvent(
                eventExpr = input$btn_edit_profile_modal,
                handlerExpr = {
                    create_modal(modal(
                        id = "modal_edit_profile",
                        header = "Edit the name and/or the weight",
                        footer = actionButton(ns("btn_confirm_edit_profile"), "Edit this profile"),
                        # create a select input for the new Name and Weight
                        textInput(ns("enterNewName"), "Enter your name", value = userName()),
                        selectInput(ns("enterNewWeight"), "Enter your weight (in kg)", c(10:200))
                    ))
                }
            )
            # Edit the row with the new values entered in the recently created modal
            observeEvent(
                eventExpr = {
                    input$btn_confirm_edit_profile
                },
                handlerExpr = {
                    # Browse the CSV 
                    editProfile = fread(file = "csv/profile.csv")
                    
                    # Search for the row with corresponding ID and edit the weight and name cells and edit the values in the CSV with the new values
                    editProfile[id == userId()][, 2] = input$enterNewName
                    editProfile[id == userId()][, 3] = as.integer(input$enterNewWeight)
                    write.table(editProfile, "csv/profile.csv", row.names = FALSE, sep=";")

                    # update the reactive with the new values for name and weight. ID stays the same obviously
                    userName(input$enterNewName) # Update name reactiveVal
                    userWeight(input$enterNewWeight) # Update weight reactiveVal
                    removeModal()
                }
            )

            output$currentUser <- renderText({
                    userName()
            })

            output$currentWeight <- renderText({
                    paste0(userWeight(), " kg")
            })
            
            # Store the values for the generated markdown
            observe({
                run_params <<- append(run_params, list(id = userId()))
                run_params <<- append(run_params, list(name = userName()))
                run_params <<- append(run_params, list(weight = userWeight()))
            })

            
            

            return(
                list(
                    userId = reactive({ userId() }),
                    userName = reactive({ userName() }),
                    userWeight = reactive({ userWeight() })
                )
            )

        }
    )
}