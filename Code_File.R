
install.packages("sp")
install.packages("sf")
install.packages("raster")
install.packages("terra")

library(sp)
library(raster)


AOI <- shapefile("AUX.shp")

#Clip

rasterfiles <- list.files(pattern = ".jp2")

patternmatching <- gsub("\\.jp2$", "_clipped.jp2", rasterfiles)

ext <- extent(630780, 645150, 5346730, 5369050)

for (i in 1:length(rasterfiles)){
  print(i)
  gc()
  r <- raster(rasterfiles[i])
  clip <- raster::crop(r, ext, filename = patternmatching[i],format="GTiff",
                       overwrite=TRUE)
}

#Reproject

clipped <- list.files(pattern = "_clipped.tif")

patternmatching2 <- gsub("\\_clipped.tif$", "_reproj.tif$", clipped)

newproj<- '+proj=utm +zone=32 +datum=WGS84 +units=m +no_defs'

for (i in 1:length(clipped)){
  print(i)
  gc()
  b <- raster(clipped[i])
  prj <- projectRaster(b, crs=newproj, method = 'bilinear', res = 10, 
                       filename = patternmatching2[i], format="GTiff", overwrite=TRUE)
}


#Extent

files <- list.files(pattern = "_reproj.tif")
patternmatching3 <- gsub("\\_reproj.tif$", "_extent.tif$", files)

example <- raster("T32UPU_20210225T102021_B03_10m_reproj.grd")

ext <- extent(example)

for (i in 1:length(files)){
  print(i)
  gc()
  b <- raster(files[i])
  x <- setExtent(b, ext, keepres=TRUE)
  writeRaster(x, filename = patternmatching3[i], format="GTiff", 	overwrite= TRUE)
}
