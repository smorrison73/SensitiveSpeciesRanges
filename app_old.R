
library(shiny)
library(rgdal)
library(leaflet)
library(RColorBrewer) #for coloring caribou herd ranges

# Define UI for application that draws a histogram
ui <- fluidPage(
  
  # Application title
  titlePanel("Mapping Sensitive Species"),
  
  # Sidebar with a slider input for number of bins 
  sidebarLayout(
    sidebarPanel(
      selectInput("species",
                  "Select a Species:",
                  c("Caribou", "Burrowing Owl", "Marcus"))
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
  
  Caribou <- readOGR("SpeciesLayers/Caribou", "Caribou_Range")
  Caribou <- spTransform(Caribou, 
                         CRS("+proj=longlat +datum=NAD83 +no_defs +ellps=GRS80 +towgs84=0,0,0"))
  
  #create pallet of colors for caribou ranges 
  qual_col_pals = brewer.pal.info[brewer.pal.info$category == 'qual',]
  col_vector = unlist(mapply(brewer.pal, qual_col_pals$maxcolors, rownames(qual_col_pals)))
  factpal <- colorFactor(col_vector, Caribou$LOCALRANGE)
  
  #create map
  output$speciesplot <- renderLeaflet({
    leaflet() %>% 
      addPolygons(data=alberta, weight=0.5, col = 'black') %>% #Add provincial border
      addPolygons(data=Caribou, opacity = 1, stroke = FALSE, weight=1) %>% 
      addTiles(urlTemplate = "https://mts1.google.com/vt/lyrs=s&hl=en&src=app&x={x}&y={y}&z={z}&s=G", attribution = 'Google') %>%
      addLegend(pal = factpal,
        values  = Caribou$LOCALRANGE,
        position = "bottomright",
        title = "Caribou Range",
        labFormat = labelFormat(digits=1))
})
}

# Run the application 
shinyApp(ui = ui, server = server)

