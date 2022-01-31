########### chargement des packages
require("shiny")
require("dplyr")
require("DT")
require("ggplot2")
require("markdown")
require("gtsummary")
require("ggdendro")
require("factoextra")
require("mclust")
require("cluster")
require("rpart")
require("rpart.plot")
require("MASS")
require("magrittr")
require("ISLR")
require("class")
require("MASS")
require("rpart.plot")
require("rpart")
require("vctrs")
require("nnet")
require("corrplot")

theme_set(
  theme_classic() +
    theme(legend.position = "top")
)

########### Importation des donnees
class(data)
data2 = read.table("data.txt", header = TRUE, sep = ",",dec=".")
data=data2[,-1]

########### Fonctions
get.error <- function(diagnosis,pred){
  cont.tab <- table(diagnosis,pred)
  # print(cont.tab)
  return((cont.tab[2,1]+cont.tab[1,2])/(sum(cont.tab)))
}

get.sensitivity <- function(diagnosis,pred){
  cont.tab <- table(diagnosis,pred)
  return((cont.tab[2,2])/(sum(cont.tab[2,])))
}


get.specificity <- function(diagnosis,pred){
  cont.tab <- table(diagnosis,pred)
  return((cont.tab[1,1])/(sum(cont.tab[1,])))
}

########### Creation des jeux de donnees d'entrainement et de test
set.seed(1234)
n <- nrow(data)
n.train <- n/4
n.test <- n-n.train
ind.train <- sample(1:nrow(data),n.train)
data.train <- data[ind.train,]
data.test <- data[-ind.train,]

Mesure <- c("Erreur","Specificite","Sensibilite")