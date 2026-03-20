# Analisis de CO2 en Mauna Loa (NOAA)

## Metodologia

### Descarga y lectura de datos
Se utilizaron los archivos NOAA para Mauna Loa en formato CSV:
- `co2_daily_mlo.csv` (media diaria)
- `co2_weekly_mlo.csv` (media semanal)
- `co2_mm_mlo.csv` (media mensual)
- `co2_annmean_mlo.csv` (media anual)

En la lectura se ignoraron comentarios con `#`, se convirtieron campos numericos y se reemplazaron valores faltantes codificados como `-999.99` (y codigos relacionados) por `NaN`.

### Preprocesamiento
Se construyo una columna de fecha (`datetime`) y se filtraron filas invalidas. Para comparaciones temporales se verifico que:
- daily y weekly inician en 1974,
- monthly inicia en 1958,
- annual abarca 67 anos en el archivo anual.

Adicionalmente, se derivaron series desde daily para comparaciones metodologicas:
- `weekly_from_daily` por promedio semanal,
- `monthly_from_daily` por promedio mensual.

### Escalas agregadas y suavizado
A partir de la serie mensual se calcularon:
- promedio trimestral (`QE`),
- promedio anual (`YE`),
- media movil centrada de 6 meses.

La amplitud anual estacional se definio como `max(mensual) - min(mensual)` por ano, usando solo anos completos (12 meses).

### Tendencias y anomalias
Se ajusto una regresion lineal simple (`y = a*t + b`) para estimar tasas de crecimiento (ppm/anio). Se reportaron:
- pendiente en periodo completo,
- pendiente en periodo comun (para comparar escalas equivalentes).

Las anomalias se calcularon respecto a la media 1990-2000.

---

## Resultados y discusion

### Figura 1. Comparacion entre escalas diaria, semanal y mensual (2019-2025)
La serie diaria muestra mayor dispersion visual por variabilidad de alta frecuencia (meteorologia local y condiciones de muestreo). La semanal suaviza parte de esa variabilidad y la mensual deja ver con mas claridad el ciclo estacional anual.

Valores de control del periodo 2019-2025:
- Daily: 2202 datos
- Weekly: 364 datos
- Monthly: 84 datos

La desviacion estandar total es similar entre series porque todas conservan la estacionalidad anual, pero la figura muestra la atenuacion del ruido al agregar temporalmente.

### Figura 2. Serie mensual completa y media movil de 6 meses
La tendencia de fondo es claramente ascendente. La concentracion mensual pasa de ~315.71 ppm (primer valor de 1958) a valores en 2025 entre ~424.37 y ~430.51 ppm.

Pendientes (periodo completo):
- Mensual: **1.661 ppm/anio**
- Diaria: **1.879 ppm/anio**
- Semanal: **1.873 ppm/anio**

Que daily/weekly den pendientes mayores que monthly en periodo completo es coherente con su fecha de inicio mas tardia (capturan con mayor peso decadas recientes, de crecimiento mas rapido).

### Figura 3. Amplitud anual del ciclo estacional
La amplitud anual media aumenta levemente entre periodos de referencia:
- Anos 60: **~5.670 ppm**
- 2014-2023: **~5.994 ppm**

En anos recientes aparecen amplitudes mas bajas en 2022-2024 (por ejemplo 2022: 5.23; 2023: 5.50; 2024: 4.88 ppm), consistentes temporalmente con la interrupcion de mediciones asociada a la erupcion del Mauna Loa y la relocalizacion temporal de la estacion.

### Figura 4. Comparacion entre promedios trimestrales y anuales
El promedio trimestral mantiene parte del ciclo estacional y reduce ruido frente a la mensual. El promedio anual elimina casi por completo la estacionalidad y resalta la tendencia secular.

Consistencia entre anual derivado de mensual y anual NOAA (`co2_annmean_mlo.csv`):
- N comun: 67 anos
- Diferencia media: **0.0004 ppm**
- Desviacion estandar de diferencia: **0.0030 ppm**

Esto confirma que ambas rutas de agregacion anual son practicamente equivalentes.

### Figura 5. Anomalias respecto a 1990-2000
La media de referencia fue **361.414 ppm**. Las anomalias mensuales muestran un aumento persistente y la curva suavizada de 6 meses resalta la tendencia de fondo.

Indicadores de aceleracion:
- Pendiente anomalia 1958-1999: **1.323 ppm/anio**
- Pendiente anomalia 2000-2025: **2.279 ppm/anio**

La tasa reciente mayor respalda la interpretacion de aceleracion del incremento de CO2 atmosferico.

---

## Conclusiones integradas

1. La agregacion temporal modifica fuertemente la legibilidad de la senal: daily prioriza variabilidad de alta frecuencia; monthly favorece deteccion de tendencia y ciclo estacional.
2. El crecimiento de CO2 en Mauna Loa es robusto y sostenido; para escalas de decision climatica, los promedios mensuales/anuales son mas informativos que la escala diaria.
3. La amplitud estacional aumento levemente desde los anos 60, con perturbaciones recientes asociadas a discontinuidades observacionales.
4. Las anomalias frente a 1990-2000 muestran incremento continuo y evidencias cuantitativas de aceleracion en el siglo XXI.
5. En linea con marcos tipo IPCC (horizontes multidecadales), el uso de escalas agregadas (anual y multianual) es el mas pertinente para evaluar tendencia de fondo y apoyar recomendaciones de politica climatica.
