
library(shiny)
library(rgdal)
library(leaflet)

# Define UI for application that draws a histogram
ui <- fluidPage(
  
  # Application title
  titlePanel("Mapping Sensitive Species"),
  
  # Sidebar with a slider input for number of bins 
  sidebarLayout(
    sidebarPanel(
      selectInput("species",
                  "Select a Species:",
                  list("Caribou", "Burrowing Owl", "Marcus"))
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
      
        leafletOutput("speciesplot")
    )
  )
)

# Define server logic required to draw a histogram

server <- function(input, output) {
  
  alberta <- readOGR("GeoBoundaries", "BF ATS v4_1 Alberta Provincial Boundary")
  caribou <- readOGR("SpeciesLayers/Caribou", "Caribou_Range")
  
  output$speciesplot <- renderLeaflet({
    leaflet() %>% 
      addPolygons(data=alberta, weight=1, col = 'black') #%>%
     # addPolygons(data=caribou, weight=1, col = 'red')

})
}

# Run the application 
shinyApp(ui = ui, server = server)

