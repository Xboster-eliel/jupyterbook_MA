---
title: "Inciso 1: Imputacion de series de precipitacion mensual"
---

# Inciso 1: Imputacion de series de precipitacion mensual

## Planteamiento
Construir un flujo secuencial de imputacion para precipitacion mensual en Colombia a partir del archivo `LluviaAcum19762015_30%_Series.xlsx`, tratando el problema de forma matricial: todas las estaciones se usan simultaneamente como entradas y tambien como salidas de los modelos.

El inciso integra en un solo notebook estas etapas:

1. lectura del Excel y construccion de la matriz mensual completa,
2. definicion de faltantes reales y mascara artificial de validacion,
3. reconstruccion inicial matricial por `interpolacion` y por `pronostico recursivo`,
4. descomposicion `STL` y analisis `ACF/PACF` sobre estaciones representativas,
5. construccion de ventanas supervisadas multivariadas,
6. imputacion matricial con `MLP`,
7. imputacion matricial con `LSTM`,
8. imputacion matricial con `CNN1D`,
9. comparacion principal contra valores reales ocultados y comparacion secundaria contra la reconstruccion convexa externa.

## Entregables
- Notebook reproducible con el flujo completo de analisis e imputacion.
- Documento de resolucion con comparacion cuantitativa entre metodos, entre estrategias de reconstruccion inicial y con analisis por estacion.

## Resolucion y notebook asociado
- [Resolucion Inciso 1: Imputacion de series de precipitacion mensual](resolucion-inciso-1-imputacion-series-precipitacion)
- [Notebook asociado](../notebooks/imputacion_series_precipitacion_mensual)

## Referencia de datos
- `Imputacion de Datos Faltantes/LluviaAcum19762015_30%_Series.xlsx`.
