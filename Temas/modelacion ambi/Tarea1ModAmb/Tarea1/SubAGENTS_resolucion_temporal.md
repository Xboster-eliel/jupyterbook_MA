# SubAGENTS.md

## Subagente: Analisis Mauna Loa NOAA

### Objetivo
Documentar, reproducir y explicar el flujo de analisis de CO2 de Mauna Loa en notebook, incluyendo carga de datos, limpieza, visualizacion, agregaciones, anomalias, tendencias e interpretacion para reporte.

## Alcance ejecutado

### Archivos fuente usados
- `co2_daily_mlo.csv`
- `co2_weekly_mlo.csv`
- `co2_mm_mlo.csv`
- `co2_annmean_mlo.csv`

### Archivos producidos/actualizados
- `Guia_practica_MaunaLoa_NOAA.ipynb` (actualizado y ejecutado)
- `Resultados_Discusion_MaunaLoa.md` (generado)

## Lo que se hizo

1. Se creo y luego se robustecio el notebook para soportar formatos NOAA CSV/TXT con comentarios `#`.
2. Se corrigio el parser para distinguir esquemas:
   - mensual (`year, month, decimal_date, average, ...`)
   - diario/semanal (`year, month, day, decimal_date, average, ...`)
3. Se normalizaron faltantes NOAA (`-999.99`, `-99.99`, `-9.99`) a `NaN`.
4. Se construyo `date` y se filtraron filas invalidas.
5. Se agrego lectura del archivo anual NOAA (`co2_annmean_mlo.csv`).
6. Se genero comparacion por escalas en 2019-2025.
7. Se agregaron:
   - media movil de 6 meses,
   - promedio trimestral (`QE`),
   - promedio anual (`YE`),
   - amplitud anual (solo anos completos),
   - anomalias respecto a 1990-2000,
   - tendencias lineales en periodo completo y periodo comun.
8. Se insertaron celdas Markdown y celdas `print` con conclusiones por figura (1-5).
9. Se verifico ejecucion completa del notebook sin errores.

## Hallazgos principales validados

- Formas de datos cargadas:
  - daily: `(15838, 6)`
  - weekly: `(2681, 6)`
  - monthly: `(815, 6)`
  - annual: `(67, 4)`
- Pendientes (ppm/anio, periodo completo):
  - daily: `1.879`
  - weekly: `1.873`
  - monthly: `1.661`
  - annual_noaa: `1.672`
- Pendientes en periodo comun (1974-05-19 a 2026-01-01):
  - daily: `1.877`
  - weekly: `1.871`
  - monthly: `1.871`
- Amplitud estacional:
  - anos 60: `~5.670 ppm`
  - 2014-2023: `~5.994 ppm`
- Anomalias (base 1990-2000):
  - media referencia: `361.414 ppm`
  - ultimo dato mensual - referencia: `67.206 ppm`
  - pendiente anomalia 1958-1999: `1.323 ppm/anio`
  - pendiente anomalia 2000-2025: `2.279 ppm/anio`

## Lo aprendido para futuras ediciones

1. La comparacion anual entre series debe alinearse por `year` (no por fecha exacta), porque una serie puede estar en inicio de ano y otra al fin de ano.
2. Al reportar amplitud anual, excluir anos incompletos evita sesgos (ejemplo: 2026 parcial).
3. Para afirmar reduccion de ruido entre escalas, no basta una sola metrica global; la interpretacion visual y el contexto estacional importan.
4. Cuando se comparan pendientes entre escalas con coberturas distintas, incluir siempre periodo comun evita interpretaciones sesgadas.
5. Incluir `co2_annmean_mlo.csv` mejora trazabilidad metodologica del crecimiento anual.

## Riesgos y puntos de escalamiento

Escalar revision metodologica si:
- cambia la definicion de periodo base (anomalias),
- se requieren inferencias causales fuertes (ENSO/volcanes) sin analisis adicional,
- se desea publicacion formal con incertidumbre estadistica (IC, autocorrelacion, sensibilidad de ventana),
- NOAA actualiza formato de archivos y rompe el parser.

## Mejoras recomendadas

1. Agregar analisis de incertidumbre de pendientes (IC95%, bootstrap).
2. Incluir deteccion explicita de quiebres de tendencia (piecewise/regimenes).
3. Añadir comparacion con estaciones de otro hemisferio.
4. Crear export automatico de figuras con nombres estandar para informe.
5. Integrar verificacion automatica de calidad de datos (checks por ano incompleto, outliers, faltantes).

## Runbook rapido (re-ejecucion)

1. Colocar CSV NOAA en `Tarea1ModAmb/Tarea1/`.
2. Abrir y ejecutar `Guia_practica_MaunaLoa_NOAA.ipynb` de arriba hacia abajo.
3. Revisar salidas de celdas de conclusiones (Figura 1-5).
4. Usar `Resultados_Discusion_MaunaLoa.md` como base del reporte final.
