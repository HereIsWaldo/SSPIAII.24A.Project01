# Convertir los datos de texto a factor
#datos$trimestre <- factor(datos$trimestre, levels = c("Primer trimestre", "Segundo trimestre", "Tercer trimestre", "Cuarto trimestre"))
data$mes <- factor(data$mes)

# Relación entre pagos de servicio de deuda y otras variables
# En la siguiente gráfica podemos observar como es que al iniciar la colocacion de credito, el pago de duda esta en mayor nivel
plot(data$colocacion_periodo, data$pago_servicio_deuda, xlab = "Colocación de crédito", ylab = "Pago de servicio de deuda", main = "Relación entre colocación de crédito y pagos de servicio de deuda", col = "blue")

# Calcular correlación entre pagos de servicio de deuda y amortizaciones
correlacion <- cor(data$pago_servicio_deuda, data$amortizaciones_periodo)
print(paste("Correlación entre pagos de servicio de deuda y amortizaciones:", correlacion))

# Gráfico lineal
# En este grafico podemos analizar como es que la deuda ha fluido con el paso de los años de que se tiene 
# registro dentro de nuestro dataset
plot(data$anio, data$endeudamiento_periodo, type = "l", xlab = "Año", ylab = "Endeudamiento", main = "Endeudamiento a lo largo del tiempo")
