# Selección de variables objetivo
# Variable objetivo para la regresión: dias_restantes_contrato
# Variable objetivo para la clasificación: detalle_tipo_deuda
y <- df.deuda$tasa_final

# df.deuda$dias_contrato <- NULL 
# df.deuda$tasa_final <- NULL 
# df.deuda$dias_restantes_contrato <- NULL 
# df.deuda$anio <- NULL 
# df.deuda$saldo_periodo <- NULL 
# df.deuda$trimestre <- NULL 
# df.deuda$mes <- NULL 
# df.deuda$concepto <- NULL 
# df.deuda$pago_servicio_deuda <- NULL
# df.deuda$saldo_periodo <- NULL
# df.deuda$disposicion_inicial_credito <- NULL 

Split<- sample.split(df.deuda$dias_restantes_contrato, SplitRatio = 0.8)
df.deuda.Train <- subset(df.deuda, Split == T)
df.deuda.Test <- subset(df.deuda, Split == F)

# Modelos de regresion
# En este punto nos percatamos que nuestro dataset se complica para generar regresiones
# debido a que todos las variantes del stack que utilizamos terminaban en un sobreajuste, por ende
# El modelo era inutilizable
mld.deuda <- lm(dias_restantes_contrato ~ ., data = df.deuda.Train)
mld1.deuda <- rpart(dias_restantes_contrato ~ ., data = df.deuda.Train)
formula <- dias_restantes_contrato ~ .
mld2.deuda <- gbm(formula, data=df.deuda.Train, distribution = "gaussian", n.trees=500, interaction.depth= 2, shrinkage= 0.01)

ypred <- predict(mld.deuda, df.deuda.Test)
ypred1 <- predict(mld1.deuda, df.deuda.Test)
ypred2 <- predict(mld2.deuda, df.deuda.Test)

train.meta <- cbind(df.deuda.Test, ypred, ypred1, ypred2)

# Entrenar el modelo final
mdl.final <- lm(df.deuda.Test$dias_restantes_contrato ~ ., data = train.meta)


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
mod <- rpart(formula = detalle_tipo_deuda ~ disposicion_inicial_credito+ dias_restantes_contrato + intereses_periodo, data = df.deuda.Train, minsplit = 1)
mdl.Rlog <- glm(formula = detalle_tipo_deuda ~disposicion_inicial_credito+ dias_restantes_contrato + intereses_periodo, data = df.deuda.Train, family = binomial)
mdl1.Rlog <- glm(formula = detalle_tipo_deuda ~ disposicion_inicial_credito + saldo_periodo, data = df.deuda.Train, family = binomial)



# Crear el conjunto de metadatos
# Nuestros metadatos son predicciones de cada uno de nuestros modelos 
# en este caso generamos 3 modelos los cuales terminaran el stack final
#
predicciones_arbol <- predict(mod, df.deuda.Train)
predicciones_logit <- predict(mdl.Rlog, df.deuda.Train, type = "response")
predicciones_knn <- predict(mdl1.Rlog, df.deuda.Train)

metadatos_train <- cbind(df.deuda.Train, predicciones_arbol, predicciones_logit, predicciones_knn)

# Entrenar el modelo de stacking
modelo_stacking <- glm(formula = detalle_tipo_deuda ~ disposicion_inicial_credito, data = metadatos_train, family = binomial)

# Predicción en el conjunto de prueba
predicciones_arbol_test <- predict(mod, df.deuda.Test)
predicciones_logit_test <- predict(mdl.Rlog, df.deuda.Test, type = "response")
predicciones_knn_test <- predict(mdl1.Rlog, df.deuda.Test)

metadatos_test <- cbind(df.deuda.Test, predicciones_arbol_test, predicciones_logit_test, predicciones_knn_test)

predicciones_stacking <- predict(modelo_stacking, metadatos_test)


# Evaluación de modelos
# Regresión
# Obtener el resumen del modelo
resumen_modelo <- summary(mdl.final)
resumen_modelo
# Extraer el R^2 y el R^2 ajustado
R2 <- resumen_modelo$r.squared
R2_ajustado <- resumen_modelo$adj.r.squared
R2
R2_ajustado
# Clasificación
# Predecir las clases en el conjunto de datos completo
predicciones <- predict(modelo, data = datos)

# Obtener la matriz de confusión
matriz_confusion <- table(df.deuda.Test$detalle_tipo_deuda, predicciones_stacking)
matriz_confusion
# Gráficos
df.plot <- data.frame(real = df.deuda.Test$tasa_final, prediccion = predicciones_stacking)

ggplot(df.plot, aes(x = real, y = prediccion)) + 
geom_point() + 
geom_abline(intercept = 0, slope = 1, color = "red")+
labs(x = "Valor real", y = "Prediccion del modelo",
title = "Grafico de dispersion para el modelo")

# Método de la curva ROC
# roc_auc <- multiclass.roc(df.deuda.Test$detalle_tipo_deuda, predicciones_stacking)

# plot(roc_auc, average = "macro", main = "Curva ROC Multiclase")
# ##Area por debajo de la curva multi-class de ROC
# auc(roc_auc)
