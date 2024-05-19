# Isaac Ulises Ascencio Padilla

import tensorflow as tf
import pandas as pd
import numpy as np
from sklearn.preprocessing import LabelEncoder, OneHotEncoder, StandardScaler
from sklearn.compose import ColumnTransformer
from sklearn.model_selection import train_test_split
from sklearn.metrics import mean_absolute_error, mean_squared_error, r2_score

# Leer el dataset
df_deuda = pd.read_csv('datasets/deuda_publica_2023_04.csv')

# Eliminar columnas no necesarias
df_deuda = df_deuda.drop(columns=['no_registro', 'inicio_credito', 'fin_credito', 'detalle_tipo_deuda', 'trimestre', 'mes', 'tipo_deuda', 'concepto'])

# Eliminar filas con valores 'NA'
df_deuda.dropna(inplace=True)

# Función para reemplazar 'TIIE' y calcular tasa final
def reemplazar_tiie(tasa, valor_tiie=8.0):
    try:
        if pd.isna(tasa):
            return np.nan
        if isinstance(tasa, str):
            tasa = tasa.strip()  # Eliminar espacios en blanco alrededor
            if 'TIIE' in tasa:
                if '+' in tasa:
                    return valor_tiie + float(tasa.split('+')[1])
                elif '-' in tasa:
                    return valor_tiie - float(tasa.split('-')[1])
                else:
                    return valor_tiie
            else:
                return float(tasa)
        return tasa
    except ValueError:
        return np.nan

# Aplicar la función a las columnas de tasa
df_deuda['tasa'] = df_deuda['tasa'].apply(reemplazar_tiie)
df_deuda['tasa_final'] = df_deuda['tasa_final'].apply(reemplazar_tiie)

# Convertir las tasas y sobretasa a tipo numérico
df_deuda['tasa'] = pd.to_numeric(df_deuda['tasa'], errors='coerce')
df_deuda['sobretasa'] = pd.to_numeric(df_deuda['sobretasa'], errors='coerce')
df_deuda['tasa_final'] = pd.to_numeric(df_deuda['tasa_final'], errors='coerce')

# Eliminar filas resultantes con valores faltantes después de la conversión
df_deuda.dropna(inplace=True)

# Revisar el rango de las características y la variable objetivo
print(df_deuda.describe())

# Normalizar la variable objetivo
scaler_y = StandardScaler()
df_deuda['saldo_periodo'] = scaler_y.fit_transform(df_deuda[['saldo_periodo']])

# Separar las características y la variable objetivo
X = df_deuda.drop(columns=['saldo_periodo'])
Y = df_deuda['saldo_periodo']

# Convertir variables categóricas en variables dummy (One-Hot Encoding)
categorical_columns = ['acreedor']
X = pd.get_dummies(X, columns=categorical_columns, drop_first=True)

# Escalado de las características
scaler = StandardScaler()
X = scaler.fit_transform(X)

# Dividir el dataset en conjunto de entrenamiento y prueba
X_train, X_test, Y_train, Y_test = train_test_split(X, Y, test_size=0.2, random_state=14)

# Construir el modelo ANN
from keras.models import Sequential
from keras.layers import Dense

ann = Sequential()

# Capa de entrada
ann.add(Dense(units=12, kernel_initializer='uniform', input_dim=X_train.shape[1]))

# Capas ocultas
ann.add(Dense(units=8, activation="relu", kernel_initializer='uniform'))
ann.add(Dense(units=4, activation="tanh", kernel_initializer='uniform'))

# Capa de salida
ann.add(Dense(units=1, activation='linear', kernel_initializer='uniform'))

# Compilar el modelo
ann.compile(optimizer='adam', loss='mean_squared_error')

# Entrenar el modelo
ann.fit(X_train, Y_train, epochs=50, batch_size=50)

# Guardar el modelo
ann.save('annPro.h5')

# Imprimir la forma del conjunto de entrenamiento para verificar
print(X_train.shape)

# Predecir con el conjunto de prueba
Y_pred = ann.predict(X_test)

# Calcular métricas de evaluación
mae = mean_absolute_error(Y_test, Y_pred)
mse = mean_squared_error(Y_test, Y_pred)
r2 = r2_score(Y_test, Y_pred)

# Calcular el número de características y el tamaño de la muestra
num_features = X_test.shape[1]
sample_size = X_test.shape[0]

# Calcular R² ajustado
adj_r2 = 1 - (1 - r2) * ((sample_size - 1) / (sample_size - num_features - 1))

print(f"Mean Absolute Error: {mae}")
print(f"Mean Squared Error: {mse}")
print(f"R-squared: {r2}")
print(f"Adjusted R-squared: {adj_r2}")



# modelo = load_model('annPro.h5')


# # Visualizar la arquitectura de la red neuronal
# from keras.utils import plot_model
# plot_model(modelo,to_file='model.png',show_shapes=True,show_layer_activations=True,show_layer_names=True) 


