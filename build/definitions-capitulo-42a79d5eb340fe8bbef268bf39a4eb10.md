---
title: Definitions
---

# Definitions

- Imputacion: Proceso de estimar valores faltantes a partir de la estructura temporal y estadistica de la serie.
- STL: Descomposicion estacional y de tendencia basada en suavizadores locales.
- Mascara de faltantes: Vector booleano que indica en que posiciones una serie tiene valores ausentes.
- Ventana temporal: Bloque de observaciones consecutivas usado como entrada para un modelo supervisado.
- MLP: Perceptron multicapa usado aqui para predecir el siguiente valor mensual desde rezagos previos.
- LSTM: Red recurrente con memoria de largo corto plazo, util para dependencias temporales secuenciales.
- CNN1D: Red convolucional unidimensional que detecta patrones locales en ventanas temporales.
- MAE: Error absoluto medio entre valor real e imputado.
- RMSE: Raiz del error cuadratico medio entre valor real e imputado.
