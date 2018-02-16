
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
      # selectInput("species",
      #             "Select a Species:",
      #             c("Caribou", "Burrowing Owl", "Marcus"))
    )
    ,

    # Show a plot of the generated distribution
    mainPanel(
      leafletOutput("speciesplot")
    )
  )
)

# Define server logic required to draw a histogram

server <- function(input, output) {
  
  alberta <- readOGR("GeoBoundaries", "BF ATS v4_1 Alberta Provincial Boundary")
  
  # Read in caribou
  Caribou <- readOGR("SpeciesLayers/Caribou", "Caribou_Range")
  Caribou <- spTransform(Caribou, 
                         CRS("+proj=longlat +datum=NAD83 +no_defs +ellps=GRS80 +towgs84=0,0,0"))
  
  # Read in burrowing owl  
  BurrOwl <- readOGR("SpeciesLayers/BurrOwl", "Burrowing_Owl_Range")
  BurrOwl <- spTransform(BurrOwl, 
                         CRS("+proj=longlat +datum=NAD83 +no_defs +ellps=GRS80 +towgs84=0,0,0"))
  
  #create map
  output$speciesplot <- renderLeaflet({
    leaflet() %>%
      
      # Set the location to center and zoom the map
      setView(lng = -113, lat = 55, zoom = 4) %>%
    
      # Base maps
      addTiles(urlTemplate = "https://mts1.google.com/vt/lyrs=s&hl=en&src=app&x={x}&y={y}&z={z}&s=G", attribution = 'Google', group = "Google") %>%
      addProviderTiles(providers$Esri.WorldStreetMap, group = "Esri") %>%
      addMiniMap(
        tiles = providers$Esri.WorldStreetMap,
        toggleDisplay = T) %>%

      # Overlay groups
      addPolygons(data=alberta, weight=2, fillColor = "transparent", stroke = TRUE, color = "black", group = "Alberta") %>%
      addPolygons(data=Caribou, opacity = 1, color = "blue", stroke = FALSE, weight=1, group = "Caribou") %>%
      addPolygons(data=BurrOwl, opacity = 1, color = "red", stroke = FALSE, weight=1, group = "Burrowing Owl") %>%
      hideGroup(c("Caribou", "Burrowing Owl")) %>% # ensures the species are OFF by default
      
      
        # Layers control
      addLayersControl(
        baseGroups = c("Google", "Esri"),
        overlayGroups = c("Caribou", "Burrowing Owl"),
        options = layersControlOptions(collapsed = FALSE)
      )
    
})
}

# Run the application 
shinyApp(ui = ui, server = server)

