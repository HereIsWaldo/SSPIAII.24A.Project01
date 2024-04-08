#Ester Vásquez Escudero
#Isaac Ulises Ascencio Padilla
#Waldo Gómez Plascencia
#Diego Hernández Cárdenas
#Cesar Emmanuel Dillon Gonzalez 
source("Lib.Preprocess.R")

set.seed(1991)
options(scipen = 999)

df.deuda <-read.csv("Datasets/deuda_publica_2023_04.csv",header = T, stringsAsFactors = T)


#1.Preprocesamiento

    #ELIMINACIÓN DE COLUMNAS INECESARIAS:
#inicio y fin de credito tienen valores incorrectos
#tipo_deuda tiene un solo valor
#tasa y sobretasa tienen muchos NA, y la tasa_final es una combinacion de ambas variables
df.deuda <- subset(df.deuda, select = -c(tipo_deuda,no_registro,inicio_credito,fin_credito,sobretasa,tasa))


#PARA UTILIZAR LA VARIABLE DETALLE_TIPO_DEUDA COMO VARIABLE DE CLASIFICACIÓN!!
# data <- subset(data, select = -c(tipo_deuda,no_registro,inicio_credito,fin_credito,tasa))
# data$sobretasa <- as.numeric(!is.na(data$sobretasa))

#tasa final en algunos tiene el valor de TIIE+ un valor numérico, por lo que se elimina el TIIE para poder trabajar con ella
df.deuda$tasa_final = as.numeric(sub("TIIE\\+", "", df.deuda$tasa_final))

#Se pasan a variables dummies para poder trabajar mejor en el modelo
df.deuda$detalle_tipo_deuda <-factor(df.deuda$detalle_tipo_deuda,
                                 levels = c("Mercado de Capitales","Banca Comercial","Bonos Cupón Cero","Banca de Desarrollo"),
                                 labels = c(1,2,3,4))

#se busca saber cuantos NA hay en el dataset
summary(df.deuda)
#se eliminan todos los NA por que son pocos
df.deuda <- na.omit(df.deuda)
#se verfica que no se hayan eliminado demasiados datos
summary(df.deuda)
View(df.deuda)

#TO DO: Escalado, ver si se queda o no
df.deuda[,7:15] <- scale(df.deuda[,7:15])
View(df.deuda)


