# SubAGENTS_modelos_linealesVSprocesos.md

## Objetivo
Documentar la reproduccion del ejercicio consolidado de comparacion entre modelos lineales y un modelo basado en procesos para dos cuencas: `APARTADO [12017060]` y `PUENTE CARRETERA - AUT [21137030]`.

## Artefactos finales del ejercicio
- `Guia_practica_Modelos_linealesVSprocesos.ipynb`
- `Resultados_Discusion_Modelos_linealesVSprocesos.md`
- `SubAGENTS_modelos_linealesVSprocesos.md`
- `hydro_modeling_utils.py`

## Datos de entrada usados
- `DataBasin-20260217T231911Z-1-001/DataBasin/APARTADO [12017060]/12017060 CHIRPS P1d 1981-2022.pcsv`
- `DataBasin-20260217T231911Z-1-001/DataBasin/APARTADO [12017060]/Caudal medio diario - APARTADO [12017060].csv`
- `DataBasin-20260217T231911Z-1-001/DataBasin/PUENTE CARRETERA - AUT [21137030]/21137030 CHIRPS P1d 1981-2022.pcsv`
- `DataBasin-20260217T231911Z-1-001/DataBasin/PUENTE CARRETERA - AUT [21137030]/Caudal medio diario - PUENTE CARRETERA - AUT [21137030].csv`
- `apartado_nasa_power_t2m_1984_2012.json`
- `puente_nasa_power_t2m_1981_2022.json`

## Flujo ejecutado
1. Inspeccion de series crudas de precipitacion y caudal para ambas cuencas.
2. Agregacion mensual de precipitacion y caudal.
3. Conversion de caudal a `mm/mes` usando area de cuenca.
4. Estimacion de PET con Thornthwaite a partir de temperatura mensual NASA POWER.
5. Filtrado de meses con cobertura diaria de caudal menor a `0.90`.
6. Split cronologico `75/25`.
7. Ajuste y evaluacion de `ARX(3,1)`.
8. Evaluacion de candidatos `ARIMAX` y `SARIMAX` con precipitacion exogena.
9. Calibracion de modelo fisico de balance de agua con reservorio lineal.
10. Comparacion final dentro de cada cuenca y comparacion transversal entre cuencas.

## Resultados clave consolidados

### APARTADO
- mejor modelo: `Estadistico ARX(3,1)`
- ARX: `RMSE = 114.62`, `NSE = 0.205`
- mejor ARIMAX: `ARIMAX(2,0,1)` con `RMSE = 134.54`
- mejor SARIMAX: `SARIMAX(1,0,0)x(1,0,0,12)` con `RMSE = 133.96`
- fisico: `RMSE = 144.23`, `k = 0.500`

### PUENTE
- mejor modelo: `Estadistico ARX(3,1)`
- ARX: `RMSE = 32.60`, `NSE = 0.513`
- mejor ARIMAX: `ARIMAX(1,0,0)` con `RMSE = 36.85`
- mejor SARIMAX: `SARIMAX(1,0,1)x(0,1,1,12)` con `RMSE = 36.06`
- fisico: `RMSE = 49.47`, `k = 0.290`

## Decision metodologica principal
La resolucion final se consolido en un unico notebook y un unico archivo de resultados para evitar replicacion de contenido y mantener una sola narrativa metodologica con el mismo procedimiento detallado en ambas cuencas.

## Runbook rapido
```bash
"./.venv/bin/python" -m jupyter execute "Guia_practica_Modelos_linealesVSprocesos.ipynb" --kernel_name python3
```
