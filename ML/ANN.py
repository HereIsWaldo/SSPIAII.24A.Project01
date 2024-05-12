# p2.2.ANN.Keras
import tensorflow as tf
# print(tf.__version__)

import pandas as pd
from sklearn.preprocessing import LabelEncoder, OneHotEncoder, StandardScaler
from sklearn.compose import ColumnTransformer
from sklearn.model_selection import train_test_split

df_deuda = pd.read_csv('Datasets/deuda_publica_2023_04.csv')

X = df_deuda.iloc[:,3:13].values
Y = df_deuda.iloc[:,13].values


# Preprocesamiento
# Dummies
X[:,1] = LabelEncoder().fit_transform(X[:,1])
X[:,2] = LabelEncoder().fit_transform(X[:,2])

one = ColumnTransformer(
    [('one_hot_encoder', OneHotEncoder(categories='auto'),[1])], 
    remainder='passthrough'
    )

X = one.fit_transform(X)
X = X[:,1:]

# Escalado
X = StandardScaler().fit_transform(X)

# Split
X_train, X_test, Y_train, Y_test = train_test_split(X, Y, test_size=0.2, random_state=14)


# Modelo ANN
from keras.models import Sequential
from keras.layers import Dense

ann = Sequential()

# Capa de entrada
ann.add(
    Dense(units = 12, kernel_initializer='uniform', input_dim = 11)
)

# Capas ocultas
ann.add(
    Dense(units = 8, activation="relu", kernel_initializer='uniform')
)

ann.add(
    Dense(units = 4, activation="tanh", kernel_initializer='uniform')
)

# Capa de salida
ann.add(
    Dense(units = 1, activation='sigmoid', kernel_initializer = "uniform")
)


# Entrenador
ann.compile(optimizer = 'adam', loss = 'binary_crossentropy', metrics=['accuracy'])

print(X_train.shape)

ann.fit(X_train, Y_train, epochs = 50, batch_size= 50)


# Guardar el modelo
from keras.models import load_model
ann.save('ann.h5')

modelo = load_model('ann.h5')

from sklearn.metrics import confusion_matrix
Y_pred = modelo.predict(X_test)
Y_pred = (Y_pred > 0.5)

cm = confusion_matrix(Y_test, Y_pred)
print(cm)

# Visualizar la arquitectura de la red neuronal
from keras.utils import plot_model
plot_model(modelo,to_file='model.png',show_shapes=True,show_layer_activations=True,show_layer_names=True) 


import matplotlib.pyplot as plt
from sklearn.datasets import make_classification
from sklearn.linear_model import LogisticRegression
from sklearn.metrics import roc_curve, auc
from sklearn.model_selection import train_test_split

# 1. Generar datos de ejemplo (puedes reemplazar esto con tus propios datos)
X, y = make_classification(n_samples=1000, n_features=20, n_classes=2, random_state=42)
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.25, random_state=42)

# 2. Entrenar un modelo de clasificación (puedes reemplazar con tu modelo)
model = LogisticRegression()
model.fit(X_train, y_train)

# 3. Obtener las probabilidades predichas para la clase positiva
y_pred_probabilidad = model.predict_proba(X_test)[:, 1]

# 4. Calcular la curva ROC
fpr, tpr, thresholds = roc_curve(y_test, y_pred_probabilidad)

# 5. Calcular el AUC (Area Under the Curve)
roc_auc = auc(fpr, tpr)

# 6. Graficar la curva ROC
plt.plot(fpr, tpr, color='darkorange', label='ROC curve (area = %0.2f)' % roc_auc)
plt.plot([0, 1], [0, 1], color='navy', linestyle='--')
plt.xlim([0.0, 1.0])
plt.ylim([0.0, 1.05])
plt.xlabel('False Positive Rate')
plt.ylabel('True Positive Rate')
plt.title('Receiver Operating Characteristic (ROC) Curve')
plt.legend(loc="lower right")
plt.show()


# Parte 2
import tensorflow as tf
from tensorflow import keras
from tensorflow.keras.layers import Dense, Dropout
from sklearn.datasets import make_classification
from sklearn.model_selection import train_test_split

# 1. Generar datos de ejemplo (puedes reemplazar esto con tus propios datos)
X, y = make_classification(n_samples=1000, n_features=20, n_classes=2, random_state=42)
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.25, random_state=42)

# 2. Definir el modelo
model = keras.Sequential([
    Dense(32, activation='relu', input_shape=(X_train.shape[1],)),
    Dense(16, activation='relu'),
    Dropout(0.2),
    Dense(1, activation='sigmoid')
])

# 3. Compilar el modelo
model.compile(loss='binary_crossentropy', optimizer='adam', metrics=['accuracy'])

# 4. Entrenar el modelo
model.fit(X_train, y_train, epochs=10, batch_size=32)

# 5. Evaluar el modelo
_, accuracy = model.evaluate(X_test, y_test)
print('Accuracy: %.2f' % (accuracy*100))

# Gráfica
#  Predecir probabilidades en el conjunto de prueba
y_pred_proba = model.predict(X_test)[:, 0]  # Probabilidades para la clase positiva

# 6. Calcular FPR, TPR y umbrales
fpr, tpr, thresholds = roc_curve(y_test, y_pred_proba)

# 7. Calcular AUC
auc_score = auc(fpr, tpr)

# Graficar la curva ROC
plt.plot(fpr, tpr, label='ROC curve (area = %0.2f)' % auc_score)
plt.plot([0, 1], [0, 1], 'k--')  # Línea diagonal para modelo aleatorio
plt.xlabel('False Positive Rate')
plt.ylabel('True Positive Rate')
plt.title('Receiver Operating Characteristic (ROC) Curve')
plt.legend()
plt.show()

