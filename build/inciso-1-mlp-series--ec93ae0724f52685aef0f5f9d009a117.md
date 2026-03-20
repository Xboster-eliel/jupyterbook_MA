---
title: "Inciso 1: MLP para series de tiempo"
---

# Inciso 1: MLP para series de tiempo

## Planteamiento
Replicar paso a paso y con alta fidelidad textual el material `3_MLP` usando un conjunto de datos de clima global para trabajar la temperatura promedio diaria en Nueva York con un enfoque de Perceptron Multicapa.

El texto base que se replica es:

"Trabajaremos con un conjunto de datos de clima global para predecir la temperatura promedio diaria en Nueva York utilizando un modelo de Perceptron Multicapa (MLP)."

En este inciso la replicacion se mantiene dentro del mismo alcance de la pagina original, es decir, preparacion y EDA de la serie, sin extender todavia al entrenamiento del modelo. El flujo reproducido es:

1. lectura del archivo CSV,
2. filtrado por pais y ciudad,
3. construccion de la serie temporal de `tavg`,
4. resumen descriptivo de la serie,
5. visualizacion temporal,
6. descomposicion estacional aditiva,
7. analisis de autocorrelacion y autocorrelacion parcial,
8. interpretacion cualitativa del comportamiento temporal.

## Entregables
- Notebook reproducible con el flujo completo de `3_MLP`.
- Documento de resolucion con el procedimiento y la interpretacion principal de la serie.

## Resolucion y notebook asociado
- [Resolucion Inciso 1: MLP para series de tiempo](resolucion-inciso-1-mlp-series-tiempo)
- [Notebook asociado](../notebooks/mlp_series_tiempo_nueva_york)

## Referencia base
- Natalia Acevedo Prins, `3. MLP para series de tiempo`.
