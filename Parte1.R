#libreries

libs <- c("ggplot", "caTools","mltools","data.table","cowplot","caret","nnet","corrplot")

if(!require(libs))
(install.packages(libs, dependencies = T))

#HABILITAR
library(ggplot2)
library(caTools)
library(mltools)
library(data.table)
library(cowplot)
library(caret)
library(nnet)
library(corrplot)

set.seed(1000)
data <-read.csv(file = "deuda_publica_2023_04.csv",header = T, stringsAsFactors = T)

#1.Preprocesamiento
data <- subset(data, select = -c(tipo_deuda,no_registro,inicio_credito,fin_credito))
data$sobretasa <- as.numeric(as.character(data$sobretasa))
data$sobretasa[is.na(data$sobretasa)] <- 0
View(data)

#2. Analisis Descriptivo
boxplot(data,las=2)
boxplot(data$disposicion_inicial_credito, las =2)

# Matriz de correlacion
data_numeric <- data[sapply(data, is.numeric)]
correlation_matrix <- cor(data_numeric)
print(correlation_matrix)
corrplot(correlation_matrix, method = "circle")
