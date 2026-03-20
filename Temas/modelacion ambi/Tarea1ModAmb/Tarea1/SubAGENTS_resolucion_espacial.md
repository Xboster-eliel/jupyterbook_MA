# SubAGENTS_resolucion_espacial.md

## Subagente: Analisis GISTEMP por resolucion espacial (1200 km vs 250 km)

### Objetivo
Documentar la reproduccion completa del analisis de anomalias de temperatura superficial con GISTEMP, comparando resoluciones de 1200 km y 250 km en tres escalas espaciales: global, zonal y regional (dominio cercano a Medellin: 0-10 N, 80-70 W).

## Alcance ejecutado

### Archivos fuente usados
- `gistemp1200_GHCNv4_ERSSTv5.nc.gz`
- `gistemp250_GHCNv4.nc.gz`
- `gistemp1200_GHCNv4_ERSSTv5.nc` (descomprimido)
- `gistemp250_GHCNv4.nc` (descomprimido)

### Archivos producidos/actualizados
- `Guia_practica_GISTEMP.ipynb` (actualizado y ejecutado)
- `Resultados_Discusion_GISTEMP.md` (generado)

## Lo que se hizo (resumen operativo)

1. Se verifico la presencia de archivos `.nc.gz` y se descomprimieron en el directorio de trabajo.
2. Se inspecciono la estructura NetCDF y se confirmo la variable `tempanomaly(time, lat, lon)` en ambos productos.
3. Se robustecio el notebook para:
   - resolver rutas locales,
   - estandarizar longitudes a convencion 0-360,
   - ordenar latitud ascendente para slicing consistente,
   - alinear ambos datasets por periodo comun.
4. Se implementaron funciones de analisis:
   - promedio global ponderado por `cos(lat)`,
   - promedio regional ponderado por `cos(lat)`,
   - resumen de variabilidad (amplitud y varianza),
   - metricas zonales promedio (amplitud/varianza media por latitud).
5. Se ajusto el dominio regional al solicitado:
   - Medellin: `lat 0-10`, `lon 80-70 W` (equivalente `280-290` en 0-360).
6. Se agregaron celdas Markdown y `print(...)` con conclusiones automaticas por seccion/figura:
   - global,
   - zonal,
   - regional,
   - tabla resumen.
7. Se ejecuto el notebook completo con kernel virtual dedicado (`gistemp-venv`) y se verifico ejecucion sin errores.

## Hallazgos principales validados

### Cobertura temporal comun
- Periodo: `1880-01-15` a `2026-01-15`
- Muestras mensuales: `1753`

### Resultados cuantitativos (Tabla 1 validada)

- Promedio global, 1200 km:
  - amplitud: `2.3564 C`
  - varianza: `0.1768`

- Promedio global, 250 km:
  - amplitud: `4.9503 C`
  - varianza: `0.3953`

- Media zonal (promedio de latitudes), 1200 km:
  - amplitud media: `6.7295 C`
  - varianza media: `1.1940`

- Media zonal (promedio de latitudes), 250 km:
  - amplitud media: `8.7405 C`
  - varianza media: `1.6601`

- Promedio regional (0-10 N, 80-70 W), 1200 km:
  - amplitud: `4.5094 C`
  - varianza: `0.3935`

- Promedio regional (0-10 N, 80-70 W), 250 km:
  - amplitud: `3.9596 C`
  - varianza: `0.4622`
  - meses validos: `1019` (faltantes: `734`), coherente con producto solo terrestre.

### Tendencia global (aceleracion)
- 1200 km:
  - 1880-1969: `0.0040 C/anio`
  - 1970-2026: `0.0204 C/anio`
- 250 km:
  - 1880-1969: `0.0073 C/anio`
  - 1970-2026: `0.0307 C/anio`

## Verificacion de consistencia con el texto del informe

Se verifico que las afirmaciones queden respaldadas por datos reales:
- calentamiento sostenido en ambos productos,
- mayor variabilidad global y zonal en 250 km,
- en la region Medellin, amplitud menor pero varianza mayor en 250 km,
- efecto de faltantes en 250 km por cobertura terrestre.

## Lecciones aprendidas para futuras ediciones

1. Siempre convertir longitudes a una convencion unica (0-360 o -180..180) antes de recortes regionales.
2. Al trabajar con regiones mixtas tierra-oceano, el producto terrestre (250 km) puede inducir sesgos por faltantes.
3. Diferenciar claramente:
   - amplitud/varianza de serie global,
   - amplitud/varianza media de series zonales por latitud.
4. Incluir celdas de conclusiones automaticas evita discrepancias entre texto narrativo y resultados calculados.
5. Mantener un kernel dedicado al proyecto evita fallas por dependencias faltantes.

## Riesgos y criterios de escalamiento

Escalar revision metodologica si:
- cambian formatos o nombres de variables en NetCDF GISTEMP,
- se exige comparacion formal con incertidumbre (IC, bootstrap, autocorrelacion),
- se requiere imputacion de faltantes en dominios regionales,
- se necesitan inferencias causales de forzantes (ENSO, aerosoles, volcanismo).

## Mejoras recomendadas

1. Agregar bandas de incertidumbre para tendencias (IC95%).
2. Incorporar test de cambio de regimen (breakpoints).
3. Generar export automatico de figuras y tabla a carpeta `outputs/`.
4. Incluir comparacion por subperiodos fijos (1880-1950, 1950-1990, 1990-2026).
5. Implementar checks automatizados de calidad:
   - cobertura temporal,
   - porcentaje de celdas validas por region,
   - alertas por faltantes extremos.

## Runbook rapido (re-ejecucion)

1. Colocar/actualizar:
   - `gistemp1200_GHCNv4_ERSSTv5.nc.gz`
   - `gistemp250_GHCNv4.nc.gz`
2. Ejecutar `Guia_practica_GISTEMP.ipynb` de arriba hacia abajo.
3. Revisar salidas de:
   - conclusiones globales,
   - conclusiones zonales,
   - conclusiones regionales,
   - conclusiones de Tabla 1.
4. Usar `Resultados_Discusion_GISTEMP.md` como base para el informe final.
