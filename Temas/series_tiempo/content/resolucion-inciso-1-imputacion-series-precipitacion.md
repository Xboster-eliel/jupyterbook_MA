---
title: "Resolucion Inciso 1: Imputacion de series de precipitacion mensual"
---

# Resolucion Inciso 1: Imputacion de series de precipitacion mensual

:::{dropdown} Introduccion
Esta resolucion integra en un solo flujo las metodologias vistas previamente para aplicarlas a una matriz mensual de precipitacion con valores faltantes. La evaluacion principal ya no usa la hoja reconstruida del archivo como verdad observada, porque esa hoja proviene de otra metodologia de imputacion. En su lugar, el notebook crea una mascara artificial sobre valores reales observados de toda la matriz para medir con certeza que tan buena es cada tecnica al recuperar datos ocultados.

La resolucion sigue este flujo:

1. lectura del Excel y construccion de la matriz mensual completa,
2. definicion de faltantes reales y mascara artificial,
3. reconstruccion inicial matricial,
4. descomposicion `STL` y analisis `ACF/PACF` sobre estaciones representativas,
5. creacion de una mascara artificial de validacion,
6. reconstruccion inicial de la serie de trabajo por `interpolacion` y por `pronostico recursivo`,
7. validacion previa de los modelos multivariados con un split temporal `70/30`,
8. imputacion con `MLP`,
9. imputacion con `LSTM`,
10. imputacion con `CNN1D`,
11. comparacion principal con `MSE`, `RMSE`, `MAE`, `R2` y `NSE` sobre valores reales ocultados,
12. comparacion secundaria contra la reconstruccion convexa como benchmark externo.
:::

## Datos y estrategia de evaluacion

El archivo contiene:

- una hoja con coordenadas y codigos de estaciones,
- una matriz mensual con faltantes,
- una matriz reconstruida sin faltantes generada por una metodologia matricial previa.

Para que la evaluacion sea reproducible, el notebook trabaja sobre la matriz completa `tiempo x estaciones`. Luego construye una mascara artificial adicional sobre valores originalmente observados. Esos valores ocultados se convierten en la referencia principal de validacion porque si son observaciones reales conocidas.

La hoja reconstruida se conserva, pero solo como benchmark externo de una metodologia de optimizacion convexa. Por eso ya no se interpreta como verdad observada.

## Protocolo de evaluacion

El notebook adopta un protocolo de imputacion explicito antes de cualquier comparacion final, en linea con la literatura reciente sobre evaluacion de metodos de imputacion.

La secuencia metodologica es:

1. construir la matriz original con faltantes reales `M_real`,
2. crear una mascara artificial reproducible `M_art` solo sobre valores originalmente observados,
3. superponer (`overlay`) `M_art` sin alterar los `NaN` reales,
4. obtener la matriz de trabajo `Y_work`,
5. generar las reconstrucciones iniciales (`interpolacion` y `forecast_filled`) a partir de `Y_work`,
6. construir ventanas, escalar y entrenar sin usar los valores ocultados como si fueran conocidos,
7. evaluar primero contra los valores reales ocultados por `M_art`,
8. usar la reconstruccion convexa solo como benchmark externo en una segunda lectura.

Este orden evita fuga de informacion (`data leakage`) porque los valores ocultados por la mascara artificial no participan como datos visibles en la generacion de rellenos base ni en la evaluacion principal.

En terminos de la literatura citada, la mascara artificial se trata como un `overlay masking`: se superpone sobre la estructura real de faltantes y no sustituye la mascara original del problema. Esto hace que la validacion sea mas realista y mas consistente con las recomendaciones metodologicas recientes.

## Reconstruccion inicial y exploracion temporal

Antes del modelado, el notebook evalua dos estrategias de pre-relleno para la serie de trabajo:

- `interpolacion` como baseline simple,
- `forecast_filled` como reconstruccion basada en pronostico recursivo estacional con backcasting para huecos iniciales.

La comparacion sobre la mascara artificial muestra que el pre-relleno por pronostico recursivo supera claramente a la interpolacion simple como serie base inicial (`RMSE` aproximado de `103.90` frente a `109.49`).

Como ahora el problema se trata matricialmente, la exploracion grafica detallada se hace sobre un pequeno conjunto de estaciones representativas. La descomposicion `STL` de periodo `12`, adecuada para una serie mensual de precipitacion, se aplica sobre `forecast_filled`, ya que fue la mejor serie base. Esto permite separar:

- tendencia de largo plazo,
- componente estacional anual,
- residuo.

Luego se calculan `ACF` y `PACF` sobre una version interpolada preliminar de la serie de trabajo, usada solo para caracterizacion y para construir entradas iniciales de los modelos supervisados.

## Mascara artificial y referencia principal

La validacion principal del notebook se apoya en cinco decisiones metodologicas:

1. partir de la serie original con faltantes reales,
2. tomar un subconjunto de valores observados y ocultarlos artificialmente como `NaN`,
3. conservar los faltantes originales sin alterarlos,
4. entrenar e imputar sobre la serie de trabajo resultante,
5. medir el error solo sobre los valores reales ocultados.

Esta estrategia permite saber con certeza que tan eficaz es cada metodo para recuperar datos conocidos, algo que no seria posible si se tomara otra imputacion previa como verdad.

Por esa razon, la hoja `LluviaAcum7615_Reconstruida` no se usa como objetivo principal. Su rol es secundario: sirve para contrastar los resultados obtenidos con una reconstruccion externa ya existente, pero no para definir la calidad real de la imputacion.

## Validacion previa del modelo

Antes de imputar los meses faltantes reales, cada arquitectura se valida sobre ventanas multivariadas construidas con la matriz completa y con un unico split temporal `70/30`. Esta etapa permite comprobar si el modelo tiene capacidad predictiva razonable antes de usarlo como imputador.

Para cada modelo el notebook genera:

- grafica de perdida de entrenamiento y validacion,
- grafica `real vs prediccion` en el bloque de prueba,
- metricas de error en entrenamiento y prueba.

Las metricas reportadas son:

- `MSE`,
- `RMSE`,
- `MAE`,
- `R2`,
- `NSE`.

El coeficiente `NSE` es especialmente util en contextos hidrologicos:

- `NSE = 1`: ajuste perfecto,
- `NSE = 0`: el modelo no mejora a usar la media observada,
- `NSE < 0`: el modelo es peor que la media observada como predictor.

En esta formulacion puntual, `R2` y `NSE` coinciden numericamente porque ambos se calculan con la misma razon entre el error cuadratico del modelo y la variabilidad de la serie respecto a su media. Por eso no se trata de un error del notebook, sino de una equivalencia matematica en este problema univariado.

## Metodos de imputacion

Se implementan tres estrategias no lineales basadas en ventanas temporales de rezagos:

### `MLP`
Usa una red densa que predice el valor mensual a partir de un bloque de rezagos previos. Es la extension directa del inciso de perceptron multicapa a este problema de imputacion.

### `LSTM`
Usa una red recurrente para capturar dependencias temporales secuenciales y relaciones mas largas dentro de la ventana.

### `CNN1D`
Usa convoluciones unidimensionales para detectar patrones locales recurrentes en la serie mensual.

En los tres casos el procedimiento es coherente:

- se construyen ventanas multivariadas sobre una matriz base,
- se entrena solo con meses observados que permanecen visibles,
- se validan primero sobre valores reales ocultados por la mascara artificial,
- se imputan despues los faltantes reales originales de toda la matriz,
- se compara aparte el resultado contra la reconstruccion convexa como benchmark externo.

## Comparacion entre metodos

La comparacion principal del notebook se resume con `MSE`, `RMSE`, `MAE`, `R2` y `NSE` calculados exclusivamente sobre los valores reales ocultados por la mascara artificial. Esto permite comparar con justicia cual combinacion entre serie base y modelo reconstruye mejor precipitaciones conocidas en toda la matriz.

De manera secundaria, el notebook tambien compara las imputaciones de los faltantes originales frente a la hoja reconstruida del Excel, pero solo como benchmark externo y no como verdad observada.

En la matriz analizada, la mejor combinacion segun `RMSE` sobre la mascara artificial fue:

- serie base: `forecast_filled`
- modelo: `LSTM`

Esta combinacion tambien fue la mejor frente al benchmark convexo externo dentro de los experimentos probados, con `RMSE` aproximado de `70.41` en la comparacion contra la reconstruccion convexa.

## Analisis por estacion

El notebook no se limita a metricas globales. Tambien calcula metricas por estacion sobre la mascara artificial, siempre que cada estacion tenga suficientes valores ocultados para una evaluacion estable.

Este analisis permite responder tres preguntas utiles:

1. si la mejor combinacion global tambien domina localmente,
2. en que estaciones el error sigue siendo alto,
3. como cambia el desempeno con el porcentaje de faltantes reales.

Las salidas adicionales incluyen:

- distribucion de `RMSE` por estacion y por metodo,
- conteo de cuantas estaciones gana cada combinacion,
- relacion entre porcentaje de faltantes y `RMSE` para el mejor metodo global,
- tablas con las estaciones de mejor y peor desempeno.

Ademas, el notebook incorpora dos mosaicos visuales para hacer visibles las diferencias entre metodos:

- un mosaico global `6 x 4` con `missing-data scenario`, `reference`, `imputed result` y `error map`,
- un mosaico de zoom sobre las `10` estaciones mas dificiles segun `RMSE`.

Estas figuras usan una submatriz enfocada en los meses con mayor densidad de huecos y en las estaciones con mas faltantes, lo que permite ver diferencias que no eran evidentes en una vista global mas comprimida.

Con esto, el capitulo ya no solo identifica un mejor metodo global, sino que tambien muestra donde el enfoque matricial es mas robusto o mas fragil.

La tabla final del notebook resume el desempeno de:

- interpolacion base,
- `MLP`,
- `LSTM`,
- `CNN1D`.

## Conclusiones

1. La validacion mas confiable para imputacion se obtiene ocultando artificialmente valores reales observados y midiendolos despues de la reconstruccion.
2. `STL` y `ACF/PACF` siguen siendo utiles para caracterizar estaciones representativas aun cuando el entrenamiento se hace de forma matricial.
3. `MLP`, `LSTM` y `CNN1D` pueden plantearse como modelos multivariados que reciben todas las estaciones y predicen todas las estaciones a la vez.
4. La validacion previa con graficas de perdida ayuda a verificar que cada modelo aprende antes de imputar.
5. El pre-relleno por `pronostico recursivo` fue mas eficaz que la interpolacion simple como punto de partida para imputar.
6. La comparacion con `MSE`, `RMSE`, `MAE`, `R2` y `NSE` sobre valores reales ocultados permite identificar la combinacion mas fiable.
7. En esta version matricial, la mejor combinacion fue `LSTM + forecast_filled`.
8. El analisis por estacion complementa la lectura global y permite detectar heterogeneidad espacial en la calidad de imputacion.
9. La hoja reconstruida del Excel sigue siendo util como benchmark externo frente a una metodologia matricial previa, pero no como verdad observada.
10. El flujo queda listo para extenderse despues a otras estaciones del territorio colombiano o a ajustes arquitectonicos mas grandes.

## Notebook asociado

- [Notebook asociado](../notebooks/imputacion_series_precipitacion_mensual)
