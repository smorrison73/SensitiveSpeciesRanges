# Download the species ranges
# The full list is at: http://aep.alberta.ca/forms-maps-services/maps/wildlife-sensitivity-maps/default.aspx


## Burrowing Owls
download.file('https://extranet.gov.ab.ca/srd/geodiscover/srd_pub/LAT/FWDSensitivity/BurrowingOwlRange.zip', destfile ='SpeciesLayers/burr_owl.zip')
unzip('SpeciesLayers/burr_owl.zip', exdir = 'SpeciesLayers/BurrOwl/')
burrowl <- readOGR("SpeciesLayers/BurrOwl/", "Burrowing_Owl_Range")

## Caribou
download.file('https://extranet.gov.ab.ca/srd/geodiscover/srd_pub/LAT/FWDSensitivity/CaribouRange.zip', destfile ='SpeciesLayers/caribou.zip')
unzip('SpeciesLayers/caribou.zip', exdir = 'SpeciesLayers/Caribou/')
caribou <- readOGR("SpeciesLayers/Caribou/", "Caribou_Range")

# Generate a map
ranges <- ggplot() +
  geom_polygon(data = burrowl, aes(x = long, y = lat, group=group), fill = NA, color = "red") +
  geom_polygon(data = caribou, aes(x = long, y = lat, group=group), fill = NA, color = "blue")
  coord_fixed(1)
ranges
