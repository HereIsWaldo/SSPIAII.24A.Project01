#Ester Vásquez Escudero
#Isaac Ulises Ascencio Padilla
#Waldo Gómez Plascencia
#Diego Hernández Cárdenas
source("Lib.Preprocess.R")

set.seed(1991)
options(scipen = 999)

data <-read.csv("Datasets/deuda_publica_2023_04.csv",header = T, stringsAsFactors = T)

#1.Preprocesamiento
data <- subset(data, select = -c(tipo_deuda,no_registro,inicio_credito,fin_credit,sobretasa,tasa))
data_new <- na.omit(data$amortizaciones_periodo)
View(data_new)
