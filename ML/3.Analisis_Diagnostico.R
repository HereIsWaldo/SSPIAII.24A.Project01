# Convertir los datos de texto a factor
#datos$trimestre <- factor(datos$trimestre, levels = c("Primer trimestre", "Segundo trimestre", "Tercer trimestre", "Cuarto trimestre"))
df.deuda$mes <- factor(df.deuda$mes)

# Relación entre pagos de servicio de deuda y otras variables
# En la siguiente gráfica podemos observar como es que al iniciar la colocacion de credito, el pago de duda esta en mayor nivel
plot(df.deuda$colocacion_periodo, df.deuda$pago_servicio_deuda, xlab = "Colocación de crédito", ylab = "Pago de servicio de deuda", main = "Relación entre colocación de crédito y pagos de servicio de deuda", col = "blue")

# Calcular correlación entre pagos de servicio de deuda y amortizaciones
correlacion <- cor(df.deuda$pago_servicio_deuda, df.deuda$amortizaciones_periodo)
print(paste("Correlación entre pagos de servicio de deuda y amortizaciones:", correlacion))

# Gráfico lineal
# En este grafico podemos analizar como es que la deuda ha fluido con el paso de los años de que se tiene 
# registro dentro de nuestro df.deudaset
plot(df.deuda$anio, df.deuda$endeudamiento_periodo, type = "l", xlab = "Año", ylab = "Endeudamiento", main = "Endeudamiento a lo largo del tiempo")
