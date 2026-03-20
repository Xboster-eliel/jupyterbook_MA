---
title: "Resolucion Inciso 2: Estructuras de redes profundas para series de tiempo univariadas"
---

# Resolucion Inciso 2: Estructuras de redes profundas para series de tiempo univariadas

:::{dropdown} Introduccion
Esta resolucion replica el ejercicio de redes profundas para series univariadas usando la serie historica de precios de Ethereum (`ETH`). El objetivo es modelar los rendimientos logaritmicos y comparar el desempeno de dos variantes `LSTM` frente a un modelo clasico `GARCH`.

La resolucion sigue este flujo:

1. lectura de la serie `price`,
2. calculo de rendimientos logaritmicos,
3. analisis estadistico de estacionariedad y heteroscedasticidad,
4. construccion de secuencias temporales para `LSTM`,
5. ajuste de un modelo `LSTM` base,
6. ajuste de un `LSTM` con `EarlyStopping`,
7. ajuste de un modelo `GARCH(1,1)`,
8. comparacion final en el conjunto de test.
:::

## Serie y rendimientos logaritmicos

El dataset `eth-usd-max.csv` contiene precios historicos de Ethereum desde `2015-08-07` hasta `2025-08-01`. A partir de la serie `price` se calculan rendimientos logaritmicos diarios mediante:

`log_returns = log(price_t / price_(t-1))`

Esta transformacion es estandar en finanzas porque estabiliza la escala del problema y facilita la interpretacion de cambios relativos diarios.

## Analisis estadistico de la serie

El analisis visual de `ACF` y `PACF` no muestra evidencia fuerte de autocorrelacion lineal significativa en los rendimientos. Esto es coherente con la idea de que los retornos financieros suelen parecerse a ruido blanco en media.

Las pruebas formales refuerzan esa lectura:

- `ADF`: evidencia fuerte de estacionariedad,
- `Ljung-Box`: no sugiere autocorrelacion lineal relevante en los rezagos evaluados,
- `ARCH`: evidencia muy fuerte de heteroscedasticidad.

En otras palabras, la media parece estable y poco predecible linealmente, pero la volatilidad no es constante. Esa combinacion es tipica de series financieras y justifica comparar una red recurrente con un modelo clasico de volatilidad.

## Ajuste del modelo LSTM base

La serie se divide cronologicamente en `80%` para entrenamiento y `20%` para prueba. Luego se construyen secuencias de longitud `20`, de modo que cada ventana usa los `20` dias previos para predecir el siguiente rendimiento.

El modelo base usa:

- `LSTM(64, return_sequences=True)`,
- `LSTM(32)`,
- `Dense(1)`.

Los datos se escalan con `MinMaxScaler(feature_range=(-1, 1))` usando solo el conjunto de entrenamiento para ajustar los limites. La curva de perdida entrenamiento-validacion muestra que el modelo aprende, pero tambien insinua sobreajuste a partir de cierto punto: la perdida de entrenamiento sigue bajando mientras la de validacion deja de mejorar de forma estable.

## Regularizacion con Early Stopping

La segunda variante conserva una arquitectura similar pero introduce `EarlyStopping` con restauracion de mejores pesos. Esta estrategia detiene el entrenamiento cuando la perdida de validacion deja de mejorar, evitando memorizar ruido del conjunto de entrenamiento.

La comparacion visual en test muestra que este segundo modelo (`M2`) sigue mejor la serie que el `LSTM` base (`M1`) y reduce el error promedio.

## Comparacion con GARCH

Como linea base clasica se ajusta un `GARCH(1,1)` sobre los rendimientos logaritmicos. Este modelo no esta orientado a predecir directamente la media como una red neuronal, sino la volatilidad condicional. Aun asi, se incluye porque es una referencia muy comun en series financieras con heteroscedasticidad.

Los resultados del ejercicio muestran que ambos modelos `LSTM` superan a `GARCH` en las metricas de test consideradas (`MSE` y `MAE`), y que la version con parada temprana es la mejor de las tres.

## Resultados comparativos en test

La lectura final del inciso es:

- `GARCH` presenta el mayor error,
- `M1` mejora notablemente frente al baseline clasico,
- `M2` logra el mejor desempeno global al combinar una arquitectura recurrente con control del sobreajuste.

## Conclusiones

1. Los rendimientos logaritmicos del ETH son estacionarios en media, pero exhiben heteroscedasticidad fuerte.
2. La ausencia de autocorrelacion lineal marcada no impide explorar modelos no lineales como `LSTM`.
3. El `LSTM` base aprende la dinamica local, pero muestra senales de sobreajuste.
4. `EarlyStopping` mejora la generalizacion y reduce el error en el conjunto de prueba.
5. En este ejercicio, las arquitecturas `LSTM` superan claramente al baseline `GARCH` en `MSE` y `MAE`.

## Notebook asociado

- [Notebook asociado](../notebooks/redes_profundas_eth_univariada)
