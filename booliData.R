
devtools::install_github("reinholdsson/rbooli")
library(rbooli)

a <- booli("your_callerId", "your_privateKey")
a <- booli("data_m_p", "Nd5peRu3Sz2VXtGFlH59CgJrOir9F8fm1WhBcphA")

data <- a$get(path = "sold", q = "stockholm", limit = 100000)

data_malmo <- a$get(path = "sold", q = "malm�", limit = 100000)

data_gbg <- a$get(path = "sold", q = "G�teborg", limit = 100000)

data_upp <- a$get(path = "sold", q = "Uppsala", limit = 100000)

data_lkpg <- a$get(path = "sold", q = "Linköping", limit = 100000)

data_nkpg <- a$get(path = "sold", q = "Norrköping", limit = 100000)


a$get(path = "sold", q = "solna", limit = 10)


nrow(data) + nrow(data_malmo) +nrow(data_gbg) +nrow(data_upp) +nrow(data_lkpg) 

library(ggplot2)
options(scipen=999)
ggplot(data, aes(x=soldDate, y=soldPrice)) + geom_point() + geom_smooth()

ggplot(data_lkpg, aes(x=soldDate, y=data_lkpg$soldPrice)) + geom_point() + geom_smooth() + theme_minimal()

library(zoo)
length(rollmean(data_lkpg$soldPrice, 100))
nrow(data_lkpg[100:4860,])

ggplot(data_lkpg[50:4860,], aes(x=soldDate, y=rollmean(data_lkpg$soldPrice, 50))) + geom_line() + geom_smooth(method = "lm") + theme_minimal()

ggplot(data_lkpg, aes(x=source.name, y=soldPrice)) + geom_point() + theme_classic() + coord_flip()
table(data_gbg$location.namedAreas)


library(ggmap)
library(maps)

map <- get_map(location = c(lon = 18.003240, lat = 59.334591), zoom = 11, maptype = "terrain")
ggmap(map)+geom_point(data=data[-c(14726,15958,15663), ], aes(x=location.position.longitude, y=location.position.latitude, col=soldPrice), size=2) +
  scale_colour_gradient(low="red", high="yellow")  + ggtitle("Bostadspriser i Stockholm, 2012-2016")

map <- get_map(location = c(lon = 15.609612, lat = 58.409413), zoom = 12, maptype = "terrain")
ggmap(map)+geom_point(data=data_lkpg, aes(x=location.position.longitude, y=location.position.latitude, col=soldPrice), size=3) +
  scale_colour_gradient(low="red", high="yellow") + ggtitle("Bostadspriser i Linköping, 2012-2016")

map <- get_map(location = c(lon = 16.188313, lat = 58.588455), zoom = 12, maptype = "terrain")
ggmap(map)+geom_point(data=data_nkpg[-2236,], aes(x=location.position.longitude, y=location.position.latitude, col=soldPrice), size=3) +
  scale_colour_gradient(low="red", high="yellow") + ggtitle("Bostadspriser i Norrköping, 2012-2016")


save(data,file="C:\\Users\\Gustav\\Desktop\\price_sthlm.Rda")




load("C:\\Users\\Gustav\\Desktop\\price_sthlm.Rda")



library(tidyr)
test <- data %>% drop_na(location.namedAreas)
test$group <- 0
for(i in 1:nrow(test)){
  if(test$location.namedAreas[i] == "�stermalm" | test$location.namedAreas[i] ==  "Fredh�ll" | test$location.namedAreas[i] == "Kristineberg" | 
     test$location.namedAreas[i] == "Kungsholmen" | test$location.namedAreas[i] == "Marieberg" | test$location.namedAreas[i] == "Lilla Essingen" | 
     test$location.namedAreas[i] == "Stadshagen" | test$location.namedAreas[i] == "Stora Essingen" | test$location.namedAreas[i] == "Norrmalm" | 
     test$location.namedAreas[i] == "Skeppsholmen" | test$location.namedAreas[i] == "Vasastaden" | test$location.namedAreas[i] == "Gamla stan" | 
     test$location.namedAreas[i] == "L�ngholmen" | test$location.namedAreas[i] == "Reimersholme" | test$location.namedAreas[i] == "Riddarholmen" | 
     test$location.namedAreas[i] == "S�dermalm" | test$location.namedAreas[i] == "S�dra Hammarbyhamnen" | test$location.namedAreas[i] == "Djurg�rden" | 
     test$location.namedAreas[i] == "Hjorthagen" | test$location.namedAreas[i] == "G�rdet" | test$location.namedAreas[i] == "Norra Djurg�rden" ){
    test$group[i] = 1
  }else{
    test$group[i] = 2
  }
}

which(c(  "�stermalm"  , "Fredh�ll"  ,   "Kristineberg"  ,  "Kungsholmen"  ,   "Marieberg"  ,   "Lilla Essingen"  , "Stadshagen"  ,   "Stora Essingen"  ,  
        "Norrmalm"  , "Skeppsholmen"  ,   "Vasastaden"  ,   "Gamla stan"  ,  "L�ngholmen"  ,   "Reimersholme"  ,   "Riddarholmen"  , "S�dermalm"  ,  
        "S�dra Hammarbyhamnen"  ,   "Djurg�rden"  ,  "Hjorthagen"  ,   "G�rdet"  ,   "Norra Djurg�rden") %in% test$location.namedAreas)


map <- get_map(location = c(lon = 18.023240, lat = 59.334591), zoom = 12, maptype = "terrain")
ggmap(map)+geom_point(data=test[-c(14726,15958,15663), ], aes(x=location.position.longitude, y=location.position.latitude),col="black",size=2)+
  scale_colour_gradient(low="red", high="yellow")  + ggtitle("Bostadspriser i Stockholm, 2012-2016")

data$soldDat <- as.numeric(data$soldDate) - 15211

table(data$objectType)
apartm_d <- subset(data, data$objectType == "L�genhet")
options(scipen=999)
lm(soldPrice ~., data=apartm_d[,c(2,3,9,11,16,18,22,30,10,24)])
summary(lm(soldPrice ~., data=apartm_d[,c(9,11,16,18,22,30,10,24)]))

ggplot(apartm_d, aes(x=soldPrice, y=as.numeric(row.names(apartm_d)))) + geom_point()




innerstad <- a$get(path = "sold", bbox = "59.3,17.97,59.36,18.12", limit = 100000)
innerstad_apartm <- subset(innerstad, innerstad$objectType == "L�genhet" & innerstad$location.region.municipalityName == "Stockholm")
ggmap(map)+geom_point(data=innerstad_apartm, aes(x=location.position.longitude, y=location.position.latitude), size=3, col="darkorange")+
  geom_point(data=test, aes(x=location.position.longitude, y=location.position.latitude, col=group), size=1)


table(innerstad_apartm$location.region.municipalityName)

