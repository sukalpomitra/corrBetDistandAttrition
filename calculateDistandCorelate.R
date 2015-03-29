library(httr)
library(jsonlite)
library(fields)
source <- read.csv("sample.csv",colClasses="character")
for (i in 1:nrow(source))
{
        content <- GET(paste("https://maps.googleapis.com/maps/api/geocode/json?components=postal_code:",source[i,1],sep=""))
        json1 <- content(content)
        json2 <- jsonlite::fromJSON(toJSON(json1))
        homeLatLong <- json2[[1]][3][[1]][1][[1]]
        homeLatLong <- as.data.frame(unlist(homeLatLong))
        content <- GET(paste("https://maps.googleapis.com/maps/api/geocode/json?components=postal_code:",source[i,2],sep=""))
        json1 <- content(content)
        json2 <- jsonlite::fromJSON(toJSON(json1))
        ofcLatLong <- json2[[1]][3][[1]][1][[1]]
        ofcLatLong <- as.data.frame(unlist(ofcLatLong))
        earthDist <- rdist.earth(matrix(c(homeLatLong[2,1],homeLatLong[1,1]), ncol=2),matrix(c(ofcLatLong[2,1],ofcLatLong[1,1]), ncol=2),miles=FALSE, R=6371)
        content <- GET(paste("https://maps.googleapis.com/maps/api/distancematrix/json?origins=",homeLatLong[1,1],",",homeLatLong[2,1],"&destinations=",ofcLatLong[1,1],",",ofcLatLong[2,1],sep=""))
        json1 <- content(content)
        json2 <- jsonlite::fromJSON(toJSON(json1))
        dist <- json2[[3]][[1]][[1]][[1]][[1]][[1]][1]
        #write.csv(homeLatLong,file="dist.csv",row.names=F,append = T)
}
