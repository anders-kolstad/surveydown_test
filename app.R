# remotes::install_github("surveydown-dev/surveydown", force = TRUE)
library(surveydown)
library(DT)
library(shiny)
library(dplyr)



db <- sd_database(
  host   = "aws-0-eu-north-1.pooler.supabase.com",
  dbname = "postgres",
  port   = "6543",
  user   = "postgres.jviaffsoemseazrnnwaz",
  table  = "my_table",
  gssencmode = "disable"
)


# Server setup
server <- function(input, output, session) {

  # Define any conditional skip logic here (skip to page if a condition is true)
  sd_skip_if(
    input$type == "pub" ~ "pubPage",
    input$type == "ind" ~ "indPage"
  )

  # Define any conditional display logic here (show a question if a condition is true)
  sd_show_if()

  
  myData <- reactive(sd_get_data(db))
  
  # renderDT doesn't work for some reason, so I render the DT table as a UI object
  observe({
    output$mydata_X <- renderUI(
      DT::datatable(myData() |>
        dplyr::filter(
          type == "pub") |>
        dplyr::select(
          session_id,
          penguins)
      )
    )
    
  })
  
  # Database designation and other settings
  sd_server(
    db = db
  )

}

# shinyApp() initiates your app - don't change it
shiny::shinyApp(ui = sd_ui(), server = server)
