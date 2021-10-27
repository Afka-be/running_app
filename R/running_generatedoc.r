#' Generates Report for the selected run
#' UI Side -> Creates the download button
running_generatedoc_ui <- function(id) {
    ns <- NS(id)
    downloadButton(ns("documentGenerator"),
                    "Generate report",
                    class = "button_generate_doc")
}

#' Generates Report for the selected run (SERVER SIDE)
#' @param date Needed for the condition to show the download button or not
running_generatedoc_server <- function(id, date) {
    moduleServer(
        id = id,
        module = function(input, output, session) {
            
            # If no date has been selected, hide the download button.
            # If Else, show it
            observe({
                if(is.null(date())) {
                    hide("documentGenerator")
                } else {
                    show("documentGenerator")
                }
            })

            output$documentGenerator <- downloadHandler(
                # For PDF output, change this to "report.pdf"
                filename = "report.html",
                content = function(file) {
                    # Copy the report file to a temporary directory before processing it, in
                    # case we don't have write permissions to the current working dir (which
                    # can happen when deployed).
                    tempReport <- file.path(tempdir(), "report.Rmd")
                        file.copy("report.Rmd", tempReport, overwrite = TRUE)

                    # Knit the document, passing in the `params` list, and eval it in a
                    # child of the global environment (this isolates the code in the document
                    # from the code in this app).
                    rmarkdown::render(tempReport, output_file = file,
                    params = run_params,
                    envir = new.env(parent = globalenv())
                    )
                }
            )
        }
    )
}