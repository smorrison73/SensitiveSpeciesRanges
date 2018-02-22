
library(shiny)
library(rgdal)
library(leaflet)
library(RColorBrewer) #for coloring caribou herd ranges

# Define UI for application that draws a histogram
ui <- fluidPage(
  
  # Application title
  titlePanel("Mapping Sensitive Species in Alberta"),
  
  # Sidebar with a slider input for number of bins
  sidebarLayout(
    sidebarPanel(
      # selectInput("species",
      #             "Select a Species:",
      #             c("Caribou", "Burrowing Owl", "Eastern Short-horned Lizard"))
      p("This app allows a user to display range maps for sensitive wildlife species within Alberta. The range maps were obtained from Alberta Environment and Parks (http://aep.alberta.ca/forms-maps-services/maps/wildlife-sensitivity-maps/default.aspx).")
    )
    ,

    # Show a plot of the generated distribution
    mainPanel(
      p("Select the type of base map and which species you wish to display. Multiple species may be selected."),
      leafletOutput("speciesplot", height = 600, width = 800)
    )
  )
)

# Define server logic required to draw a histogram

server <- function(input, output) {
  
  alberta <- readOGR("GeoBoundaries", "BF ATS v4_1 Alberta Provincial Boundary")
  
  # Read in caribou
  Caribou <- readOGR("SpeciesLayers/caribou", "Caribou_Range")
  Caribou <- spTransform(Caribou, 
                         CRS("+proj=longlat +datum=NAD83 +no_defs +ellps=GRS80 +towgs84=0,0,0"))
  
  # Read in burrowing owl  
  BurrOwl <- readOGR("SpeciesLayers/burr_owl", "Burrowing_Owl_Range")
  BurrOwl <- spTransform(BurrOwl, 
                         CRS("+proj=longlat +datum=NAD83 +no_defs +ellps=GRS80 +towgs84=0,0,0"))
  
  # Read in Eastern Short-horned Lizard  
  ESHLizard <- readOGR("SpeciesLayers/EasternSHLizard", "Eastern_Short_horned_Lizard_Range")
  ESHLizard <- spTransform(ESHLizard, 
                         CRS("+proj=longlat +datum=NAD83 +no_defs +ellps=GRS80 +towgs84=0,0,0"))
  
  # Read in Greater Sage Grouse 
  SageGrouse <- readOGR("SpeciesLayers/GreaterSageGrouseRange", "Greater_Sage_Grouse_Range")
  SageGrouse <- spTransform(SageGrouse, 
                           CRS("+proj=longlat +datum=NAD83 +no_defs +ellps=GRS80 +towgs84=0,0,0"))
  
  # Read in Greater Sage Grouse 
  Ords <- readOGR("SpeciesLayers/OrdsKangarooRatRange", "Ords_Kangaroo_Rat_Range")
  Ords <- spTransform(Ords, 
                            CRS("+proj=longlat +datum=NAD83 +no_defs +ellps=GRS80 +towgs84=0,0,0"))
  
  # Read in Sharp=tailed Grouse 
  STGrouse <- readOGR("SpeciesLayers/Sharp-tailedGrouseSurvey", "Sharp_tailed_Grouse_Survey")
  STGrouse <- spTransform(STGrouse, 
                      CRS("+proj=longlat +datum=NAD83 +no_defs +ellps=GRS80 +towgs84=0,0,0"))
  
  # Read in Swift Fox 
  SwiftFox <- readOGR("SpeciesLayers/SwiftFoxRange", "Swift_Fox_Range")
  SwiftFox <- spTransform(SwiftFox, 
                          CRS("+proj=longlat +datum=NAD83 +no_defs +ellps=GRS80 +towgs84=0,0,0"))
  
  #create map
  output$speciesplot <- renderLeaflet({
    leaflet() %>%
      
      # Set the location to center and zoom the map
      setView(lng = -113, lat = 55, zoom = 5) %>%
    
      # Base maps
      addTiles(urlTemplate = "https://mts1.google.com/vt/lyrs=s&hl=en&src=app&x={x}&y={y}&z={z}&s=G", attribution = 'Google', group = "Google") %>%
      addProviderTiles(providers$Esri.WorldStreetMap, group = "Esri") %>%
      # Adds a small map inset indicating the selected part of the world.
      addMiniMap(
        tiles = providers$Esri.WorldStreetMap,
        toggleDisplay = T) %>%

      # Overlay groups
      addPolygons(data=alberta, weight=2, fillColor = "transparent", stroke = TRUE, color = "black", group = "Alberta") %>%
      addPolygons(data=Caribou, opacity = 1, color = "blue", stroke = FALSE, weight=1, group = "Caribou") %>%
      addPolygons(data=BurrOwl, opacity = 1, color = "red", stroke = FALSE, weight=1, group = "Burrowing Owl") %>%
      addPolygons(data=ESHLizard, opacity = 1, color = "green", stroke = FALSE, weight=1, group = "Eastern SH Lizard") %>%      
      addPolygons(data=SageGrouse, opacity = 1, color = "purple", stroke = FALSE, weight=1, group = "Greater Sage Grouse") %>%
      addPolygons(data=Ords, opacity = 1, color = "yellow", stroke = FALSE, weight=1, group = "Ord's Kangaroo Rat") %>%
      addPolygons(data=STGrouse, opacity = 1, color = "yellow", stroke = FALSE, weight=1, group = "Sharp-tailed Grouse") %>%
      addPolygons(data=SwiftFox, opacity = 1, color = "white", stroke = FALSE, weight=1, group = "Swift Fox") %>%
      hideGroup(c("Caribou", "Burrowing Owl", "Eastern SH Lizard", "Greater Sage Grouse", "Ord's Kangaroo Rat", "Sharp-tailed Grouse", "Swift Fox")) %>% # ensures the species are OFF by default
      
      
        # Layers control
      addLayersControl(
        baseGroups = c("Google", "Esri"),
        overlayGroups = c("Caribou", "Burrowing Owl", "Eastern SH Lizard", "Greater Sage Grouse", "Ord's Kangaroo Rat", "Sharp-tailed Grouse", "Swift Fox"),
        options = layersControlOptions(collapsed = FALSE)
      )
    
})
}

# Run the application 
shinyApp(ui = ui, server = server)

