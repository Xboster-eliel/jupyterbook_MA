# Resultados_Discusion_Modelos_linealesVSprocesos

## Contexto general

Se resolvio el ejercicio comparando modelos estadisticos y un modelo basado en procesos para la prediccion de caudal mensual en dos cuencas colombianas:

- `APARTADO [12017060]`
- `PUENTE CARRETERA - AUT [21137030]`

En ambas cuencas se aplico exactamente el mismo procedimiento:

1. inspeccion de precipitacion diaria y caudal diario crudos,
2. agregacion mensual,
3. conversion del caudal a lamina de escorrentia (`mm/mes`),
4. estimacion de PET con Thornthwaite usando temperatura NASA POWER,
5. division cronologica `75/25`,
6. ajuste de `ARX(3,1)`,
7. prueba de candidatos `ARIMAX` y `SARIMAX`,
8. calibracion de un modelo fisico de balance de agua con reservorio lineal,
9. comparacion final por `RMSE`, `MAE`, `sesgo`, `NSE` y correlacion.

## Fundamento del modelo basado en procesos

El esquema fisico usado fue:

`dS/dt = P - ET - Q`

con una formulacion mensual discreta:

- `S_(t+1) = S_t + P_t - ET_t - Q_t`
- `Q_t = k S_t`

La aproximacion `dS/dt ~ 0` en el largo plazo se justifica porque el almacenamiento medio de la cuenca no crece ni decrece indefinidamente al analizar periodos multianuales; por tanto, el balance medio de entradas y salidas tiende a cerrarse.

La PET se infirio con Thornthwaite. Esta eleccion es consistente con el caracter docente del ejercicio y con la disponibilidad de temperatura mensual, aunque introduce simplificaciones importantes frente a la evapotranspiracion real.

## Resultados por cuenca

### APARTADO [12017060]

Resumen hidrologico:

- area: `87.186 km2`
- rango mensual: `1984-01` a `2012-12`
- meses validos: `308` de `348`
- precipitacion media: `237.4 mm/mes`
- PET media: `118.8 mm/mes`
- caudal observado medio: `158.9 mm/mes`

Desempeno en evaluacion:

- `ARX(3,1)`: `RMSE = 114.62`, `NSE = 0.205`, `corr = 0.610`
- mejor `ARIMAX`: `ARIMAX(2,0,1)` con `RMSE = 134.54`, `NSE = -0.095`
- mejor `SARIMAX`: `SARIMAX(1,0,0)x(1,0,0,12)` con `RMSE = 133.96`, `NSE = -0.086`
- fisico: `RMSE = 144.23`, `NSE = -0.258`, `k = 0.500`

Comparacion interna:

```text
modelo                      | rmse    | nse    | corr 
----------------------------|---------|--------|------
Estadistico ARX(3,1)        | 114.617 | 0.205  | 0.610
SARIMAX(1,0,0)x(1,0,0,12)   | 133.965 | -0.086 | 0.483
ARIMAX(2,0,1)               | 134.541 | -0.095 | 0.478
Fisico balance + reservorio | 144.226 | -0.258 | 0.418
```

Lectura tecnica:

- En APARTADO, el `ARX(3,1)` fue superior a todos los candidatos `ARIMAX/SARIMAX` y tambien al modelo fisico.
- Las familias ARIMA no mejoraron la prediccion fuera de muestra; sus `NSE` fueron negativos.
- El modelo fisico quedo ultimo, lo que sugiere que una estructura de un solo reservorio es demasiado simple para esta cuenca bajo este conjunto de datos.

### PUENTE CARRETERA - AUT [21137030]

Resumen hidrologico:

- area: `658.750 km2`
- rango mensual: `1981-01` a `2022-01`
- meses validos: `447` de `493`
- precipitacion media: `177.3 mm/mes`
- PET media: `73.8 mm/mes`
- caudal observado medio: `62.6 mm/mes`

Desempeno en evaluacion:

- `ARX(3,1)`: `RMSE = 32.60`, `NSE = 0.513`, `corr = 0.736`
- mejor `ARIMAX`: `ARIMAX(1,0,0)` con `RMSE = 36.85`, `NSE = 0.377`
- mejor `SARIMAX`: `SARIMAX(1,0,1)x(0,1,1,12)` con `RMSE = 36.06`, `NSE = 0.404`
- fisico: `RMSE = 49.47`, `NSE = -0.122`, `k = 0.290`

Comparacion interna:

```text
modelo                      | rmse   | nse    | corr 
----------------------------|--------|--------|------
Estadistico ARX(3,1)        | 32.601 | 0.513  | 0.736
SARIMAX(1,0,1)x(0,1,1,12)   | 36.055 | 0.404  | 0.671
ARIMAX(1,0,0)               | 36.854 | 0.377  | 0.616
Fisico balance + reservorio | 49.466 | -0.122 | 0.712
```

Lectura tecnica:

- En PUENTE, el `ARX(3,1)` tambien fue el mejor modelo.
- El mejor `SARIMAX` y el mejor `ARIMAX` mejoraron claramente frente al modelo fisico, pero no alcanzaron al `ARX`.
- Aqui las familias ARIMA mostraron mas habilidad que en APARTADO, lo que sugiere una estructura temporal mas favorable para ese tipo de modelos.

## Comparacion transversal entre cuencas

```text
cuenca                            | mejor_modelo         | rmse_mejor | nse_mejor | rmse_arx | rmse_fisico
----------------------------------|----------------------|------------|-----------|----------|------------
APARTADO [12017060]               | Estadistico ARX(3,1) | 114.617    | 0.205     | 114.617  | 144.226    
PUENTE CARRETERA - AUT [21137030] | Estadistico ARX(3,1) | 32.601     | 0.513     | 32.601   | 49.466     
```

## Hallazgos globales

1. En las dos cuencas evaluadas, el mejor modelo fue `ARX(3,1)`.
2. La inclusion de memoria hidrologica explicita mediante rezagos de caudal fue mas efectiva que las formulaciones `ARIMAX/SARIMAX` probadas.
3. El modelo fisico de balance de agua con un solo parametro fue el menos competitivo en precision predictiva, aunque sigue siendo el mas interpretable desde el punto de vista hidrologico.
4. El desempeno pobre del modelo fisico no invalida el enfoque basado en procesos; indica que la formulacion usada fue demasiado parsimoniosa para representar adecuadamente ambas cuencas.
5. La comparacion muestra que, para este ejercicio y estos datos, un modelo lineal bien especificado puede superar a un modelo fisico simple cuando el objetivo principal es la prediccion fuera de muestra.

## Cierre

El analisis final queda consolidado en un solo notebook y un solo archivo de resultados para evitar duplicacion de contenido y mantener una narrativa metodologica unica para ambas cuencas.
