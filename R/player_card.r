# Create the player card with his/her informations
player_card_ui <- function(id) {
    ns <- NS(id)
    box(
        title = "Resume", status = "warning", collapsible = FALSE,
        solidHeader = TRUE,
        width = 4,
        class = "player_card",

    ) #box
}

player_card_server <- function(id) {

    moduleServer(
        id = id,
        module = function(input, output, session) {
        }
    )
}