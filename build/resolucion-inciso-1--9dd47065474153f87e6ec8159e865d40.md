---
title: "Resolucion Inciso 1: MLP para series de tiempo"
---

# Resolucion Inciso 1: MLP para series de tiempo

:::{dropdown} Introduccion
En esta resolucion se replica de forma fiel el contenido de dos paginas consecutivas del curso original: `3_MLP` y `4_mlp_model`. Por eso, el flujo ya no se detiene en el EDA, sino que continua con la construccion de ventanas temporales, escalado, ajuste de un `MLP` simple y una primera busqueda de hiperparametros.

La resolucion sigue este flujo:

1. carga del archivo CSV,
2. inspeccion inicial de columnas y registros,
3. filtrado de los datos de `USA` y luego `New York`,
4. definicion de la serie `tavg` con indice temporal,
5. EDA descriptivo y grafico,
6. descomposicion de la serie,
7. analisis ACF y PACF,
8. creacion de ventanas temporales,
9. escalado con `MinMaxScaler`,
10. construccion y entrenamiento del `MLP`,
11. analisis de perdidas, predicciones y residuos,
12. introduccion a optimizacion de hiperparametros con `GridSearchCV`.
:::

## Dataset y seleccion de la serie

El texto original inicia con el trabajo sobre un conjunto de datos de clima global para predecir la temperatura promedio diaria en Nueva York usando un `MLP`. En esta replica, el archivo local usado es `global_weather_data_2015_2024.csv` y la serie seleccionada corresponde a `tavg` para `New York`, `USA`.

Al filtrar por `country == 'USA'` y `city == 'New York'` se obtiene una subserie con `3649` observaciones. En esta ciudad, la variable `tavg` no presenta faltantes, lo que permite replicar el flujo original sin imputacion previa.

## Analisis exploratorio

La serie de `tavg` presenta las siguientes estadisticas descriptivas principales:

- numero de observaciones: `3649`
- media: `13.995`
- desviacion estandar: `9.635`
- minimo: `-13.2`
- maximo: `33.2`

Estas cifras muestran una amplitud termica amplia, consistente con un clima con marcada variacion intraanual.

## Hallazgos visuales

La visualizacion temporal permite observar ciclos anuales bien definidos. La descomposicion aditiva separa una componente de tendencia suave, una estacionalidad anual dominante y un residuo de menor escala.

El analisis de autocorrelacion y autocorrelacion parcial refuerza esta lectura:

- la ACF evidencia persistencia y memoria temporal,
- la PACF sugiere una contribucion fuerte del primer rezago,
- la estructura global es coherente con una serie climatica diaria con estacionalidad pronunciada.

## Preprocesamiento para el MLP

La pagina de modelado introduce una transformacion supervisada clasica para series temporales: convertir la serie univariada en pares entrada-salida mediante ventanas de tiempo.

Con `window_size = 7` se construyen `3642` ejemplos, donde cada fila de `X` contiene `7` temperaturas consecutivas y cada valor de `y` corresponde al siguiente dia. Esto preserva el orden temporal y evita fuga de datos, porque el objetivo siempre queda fuera de la ventana de entrada.

La estructura resultante es:

- `X.shape = (3642, 7)`
- `y.shape = (3642,)`

Despues se aplica `MinMaxScaler` por separado a `X` y `y`, reproduciendo el flujo original. Esta eleccion deja todos los valores en un rango comparable y facilita la convergencia de la red neuronal.

## Construccion y entrenamiento del modelo

El modelo implementado es un `Sequential` muy simple con `tensorflow.keras`:

- una capa de entrada de tamano `7`,
- una capa densa oculta con `32` neuronas y activacion `relu`,
- una capa de salida con una sola neurona para predecir el siguiente dia.

La compilacion usa:

- optimizador `adam`,
- funcion de perdida `mse`,
- metrica `mse`.

El entrenamiento se realiza con:

- `epochs = 500`,
- `batch_size = 32`,
- `validation_split = 0.2`.

La curva de entrenamiento y validacion permite verificar si el ajuste converge y si aparecen signos fuertes de sobreajuste.

## Predicciones y residuos

Una vez entrenado el `MLP`, se generan predicciones sobre todas las ventanas escaladas y luego se invierte la transformacion de `y` para volver a la escala original de temperatura.

Las tres salidas graficas mas importantes de esta etapa son:

1. perdida de entrenamiento vs perdida de validacion,
2. valores reales vs valores predichos,
3. residuos de la prediccion.

Estas figuras permiten inspeccionar tres aspectos distintos:

- estabilidad del proceso de optimizacion,
- capacidad del modelo para seguir la dinamica observada,
- estructura del error remanente.

## Optimizacion de hiperparametros

La ultima parte replica una introduccion a la busqueda de hiperparametros. El notebook conserva la tabla orientativa de herramientas y luego implementa un wrapper `KerasRegressor` compatible con `scikit-learn`.

Sobre ese wrapper se define una malla pequena:

- `optimizer`: `adam`, `sgd`
- `neurons`: `32`, `64`
- `batch_size`: `16`
- `epochs`: `10`

La validacion se hace con `TimeSeriesSplit(n_splits=3)`, lo cual respeta el orden cronologico y evita particiones aleatorias impropias para series de tiempo. En esta replica, la busqueda con `GridSearchCV` se realizo sobre los datos escalados (`X_scaled`, `y_scaled`) para mantener coherencia con el entrenamiento del `MLP` y evitar inestabilidad numerica durante la comparacion de configuraciones.

El mejor resultado obtenido en el notebook fue:

- `optimizer = 'adam'`
- `neurons = 32`
- `batch_size = 16`
- `epochs = 10`
- mejor `MSE` aproximado: `0.004262`

Este resultado indica que, dentro de la malla probada, `adam` fue mas robusto que `sgd` para este problema y esta formulacion de red.

## Conclusiones

1. La serie de temperatura promedio diaria de Nueva York es adecuada para iniciar un ejercicio de modelado supervisado con `MLP`.
2. El comportamiento temporal no es aleatorio; hay persistencia y una señal estacional anual clara.
3. La presencia de memoria temporal sugiere que los rezagos inmediatos deben formar parte del conjunto de entrada para el modelo.
4. La lectura coincide con el cierre del material original: la serie muestra fuerte memoria temporal y tendencia persistente, y la `PACF` sugiere un comportamiento autorregresivo de primer orden.
5. La formulacion con ventanas de `7` dias permite convertir la serie en un problema supervisado compatible con una red densa simple.
6. El `MLP` construido con `tensorflow.keras` ofrece una primera aproximacion no lineal para predecir la temperatura del dia siguiente.
7. La inspeccion de perdidas, predicciones y residuos es esencial para evaluar si el modelo aprende estructura real o solo suaviza la serie.
8. La busqueda de hiperparametros con validacion temporal es un paso natural para mejorar el modelo sin romper la logica cronologica del problema.
9. En la malla evaluada, `adam` fue la mejor opcion y produjo el mejor desempeno promedio sobre los datos escalados.

## Notebook asociado

- [Notebook asociado](../notebooks/mlp_series_tiempo_nueva_york)
