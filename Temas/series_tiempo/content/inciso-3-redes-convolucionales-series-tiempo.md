---
title: "Inciso 3: Redes convolucionales para series de tiempo"
---

# Inciso 3: Redes convolucionales para series de tiempo

## Planteamiento
Replicar el ejercicio sobre la serie del indice `S&P 500` usando una red convolucional `CNN1D` para modelar rendimientos logaritmicos y reconstruir una prediccion aproximada del precio.

El inciso reproduce estas etapas:

1. lectura de `SP500.csv`,
2. construccion o verificacion de `log_yield`,
3. visualizacion de precio y rendimientos,
4. creacion de secuencias con `padding`,
5. escalado de entradas y salidas,
6. definicion de una `CNN1D` minima viable,
7. optimizacion de hiperparametros con `RandomizedSearchCV`,
8. prediccion en entrenamiento y test,
9. reconstruccion aproximada del precio a partir de la rentabilidad pronosticada.

## Entregables
- Notebook reproducible con el flujo completo de la `CNN1D`.
- Documento de resolucion con interpretacion de la arquitectura, del ajuste y de las metricas.

## Resolucion y notebook asociado
- [Resolucion Inciso 3: Redes convolucionales para series de tiempo](resolucion-inciso-3-redes-convolucionales-series-tiempo)
- [Notebook asociado](../notebooks/redes_convolucionales_sp500)

## Referencia base
- Natalia Acevedo Prins, `Redes convolucionales para series de tiempo`.
