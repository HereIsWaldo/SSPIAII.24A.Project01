

#2. Analisis Descriptivo
boxplot(data,las=2)
boxplot(data$disposicion_inicial_credito, las =2)

# Matriz de correlacion
data_numeric <- data[sapply(data, is.numeric)]
correlation_matrix <- cor(data_numeric)
print(correlation_matrix)
corrplot(correlation_matrix, method = "circle")
