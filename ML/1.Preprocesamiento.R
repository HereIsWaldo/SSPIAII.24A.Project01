#Ester Vásquez Escudero
#Isaac Ulises Ascencio Padilla
#Waldo Gómez Plascencia
#Diego Hernández Cárdenas
source("Lib.Preprocess.R")

set.seed(1991)
options(scipen = 999)

data <-read.csv("Datasets/deuda_publica_2023_04.csv",header = T, stringsAsFactors = T)


#1.Preprocesamiento

    #ELIMINACIÓN DE COLUMNAS INECESARIAS:
#inicio y fin de credito tienen valores incorrectos
#tipo_deuda tiene un solo valor
#tasa y sobretasa tienen muchos NA, y la tasa_final es una combinacion de ambas variables
data <- subset(data, select = -c(tipo_deuda,no_registro,inicio_credito,fin_credito,sobretasa,tasa))


#PARA UTILIZAR LA VARIABLE DETALLE_TIPO_DEUDA COMO VARIABLE DE CLASIFICACIÓN!!
# data <- subset(data, select = -c(tipo_deuda,no_registro,inicio_credito,fin_credito,tasa))
# data$sobretasa <- as.numeric(!is.na(data$sobretasa))

#tasa final en algunos tiene el valor de TIIE+ un valor numérico, por lo que se elimina el TIIE para poder trabajar con ella
data$tasa_final = as.numeric(sub("TIIE\\+", "", data$tasa_final))

#Se pasan a variables dummies para poder trabajar mejor en el modelo
data$detalle_tipo_deuda <-factor(data$detalle_tipo_deuda,
                                 levels = c("Mercado de Capitales","Banca Comercial","Bonos Cupón Cero","Banca de Desarrollo"),
                                 labels = c(1,2,3,4))

#se busca saber cuantos NA hay en el dataset
summary(data)
#se eliminan todos los NA por que son pocos
data <- na.omit(data)
#se verfica que no se hayan eliminado demasiados datos
summary(data)
View(data)

#TO DO: Escalado, ver si se queda o no
data[,7:15] <- scale(data[,7:15])
View(data)

Split<- sample.split(data$tasa_final, SplitRatio = 0.8)
data.Train <- subset(data, Split == T)
data.Test <- subset(data, Split == F)
