

library(shiny)

# Define UI for application that draws a histogram
ui <- fluidPage(
  
  # Application title
  titlePanel("Mapping Sensitive Species"),
  
  # Sidebar with a slider input for number of bins 
  sidebarLayout(
    sidebarPanel(
      selectInput("species",
                  "Select a Species:",
                  list("Caribou", "Burrowing Owl"))
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
      plotOutput("distPlot")
    )
  )
)

# Define server logic required to draw a histogram
server <- function(input, output) {
  
  ## Add the maps here
  
}

# Run the application 
shinyApp(ui = ui, server = server)

