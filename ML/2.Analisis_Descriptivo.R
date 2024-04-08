#2. Analisis Descriptivo
#Se utiliza esta grafica para evaluar los datos atipicos
boxplot(df.deuda,las=2)

# Matriz de correlacion y grafica de correlacion para ver la relacion entre las variables
#Y como se trabajaran los datos en el modelo
data_numeric <- df.deuda[sapply(df.deuda, is.numeric)]
correlation_matrix <- cor(data_numeric)
print(correlation_matrix)
corrplot(correlation_matrix, method = "circle")

#Complementar el analisis de la relacion entre las variables numericas
pairs(data_numeric)
summary(df.deuda)
