# Selección de variables objetivo
# Variable objetivo para la regresión: tasa_final
# Variable objetivo para la clasificación: detalle_tipo_deuda
y <- df.deuda$tasa_final



Split<- sample.split(df.deuda$tasa_final, SplitRatio = 0.8)
df.deuda.Train <- subset(df.deuda, Split == T)
df.deuda.Test <- subset(df.deuda, Split == F)

# Modelos
mld.deuda <- lm(df.deuda$tasa_final ~ ., data = df.deuda.Train)
mld1.deuda <- rpart(df.deuda$tasa_final ~ ., data = df.deuda.Train)
mdl2.deuda <- glmnet(df.deuda$tasa_final ~ ., data = df.deuda.Train)

ypred <- predict(mld.deuda, df.deuda.Train)
ypred1 <- predict(mld1.deuda, df.deuda.Train)
ypred2 <- predict(mld2.deuda, df.deuda.Train)

train.meta <- cbind(df.deuda.Train, ypred, ypred1, ypred2)

# Entrenar el modelo final
mdl.final <- lm(df.deuda$tasa_final ~ ., data = train.meta)


# Evaluar el modelo final en el conjunto de prueba
testPred <- predict(finalModel, testData)
rmse <- sqrt(mean((testPred - testLabel)^2))
print(rmse)

# Evaluar el modelo de regresión lineal simple
rmse_simple <- sqrt(mean((predict(model1, testData) - testLabel)^2))
print(rmse_simple)



# Modelo de clasificación
y1 <- df.deuda$detalle_tipo_deuda
# Entrenar 3 modelos base
modelo_arbol <- rpart(y1 ~ ., data = df.deuda.Train)
modelo_logit <- glm(y1 ~ ., data = df.deuda.Train, family = "binomial")
modelo_knn <- knn(y1 ~ ., data = df.deuda.Train, k = 5)

# Crear el conjunto de metadatos
predicciones_arbol <- predict(modelo_arbol, df.deuda.Train)
predicciones_logit <- predict(modelo_logit, df.deuda.Train, type = "response")
predicciones_knn <- predict(modelo_knn, df.deuda.Train)

metadatos_train <- cbind(df.deuda.Train, predicciones_arbol, predicciones_logit, predicciones_knn)

# Entrenar el modelo de stacking
modelo_stacking <- glm(detalle_tipo_deuda ~ ., data = metadatos_train)

# Predicción en el conjunto de prueba
predicciones_arbol_test <- predict(modelo_arbol, df.deuda.Test)
predicciones_logit_test <- predict(modelo_logit, df.deuda.Test, type = "response")
predicciones_knn_test <- predict(modelo_knn, df.deuda.Test)

metadatos_test <- cbind(df.deuda.Test, predicciones_arbol_test, predicciones_logit_test, predicciones_knn_test)

predicciones_stacking <- predict(modelo_stacking, metadatos_test)


# Evaluación de modelos
# Regresión
# Obtener el resumen del modelo
resumen_modelo <- summary(mdl.final)

# Extraer el R^2 y el R^2 ajustado
R2 <- resumen_modelo$r.squared
R2_ajustado <- resumen_modelo$adj.r.squared

# Clasificación
# Predecir las clases en el conjunto de datos completo
predicciones <- predict(modelo, data = datos)

# Obtener la matriz de confusión
matriz_confusion <- table(df.deuda.Test$y1, predicciones_stacking)

# Gráficos
df.plot <- data.frame(real = df.deuda.Test$tasa_final, prediccion = testPred)

ggplot(df.plot, aes(x = real, y = prediccion)) + 
geom_point() + 
geom_abline(intercept = 0, slope = 1, color = "red")+
labs(x = "Valor real", y = "Prediccion del modelo",
title = "Grafico de dispersion para el modelo")

# Método de la curva ROC
roc_auc <- roc(datos$clase, predicciones_prob)
plot(roc_auc)
