# AGENTS.md

## Proposito
Este directorio no es una libreria Python ni una app con CI formal.
Es una coleccion de ejercicios de modelacion ambiental resueltos de forma reproducible.

La unidad real de trabajo es cada ejercicio completo, con esta cadena:
1. datos de entrada,
2. notebook con resolucion paso a paso,
3. archivo markdown con hallazgos clave,
4. archivo `SubAGENTS_*` con documentacion para replicar analisis y calculos.

Si cambias un ejercicio, debes preservar y revisar esa cadena completa.

## Estructura del proyecto por ejercicio
- `datos de entrada` especificos del problema.
- `notebook` con explicacion pedagogica + codigo ejecutable.
- `Resultados_Discusion_*.md` con sintesis de hallazgos y conclusiones.
- `SubAGENTS_*` con runbook, decisiones tecnicas y cifras validadas.

Interpretacion obligatoria:
- el notebook no es solo codigo: tambien es documento metodologico,
- el `.md` no reemplaza al notebook: resume resultados,
- el `SubAGENTS_*` no es reporte final: documenta replicacion operativa.

## Artefactos principales detectados
NOAA Mauna Loa:
- `Guia_practica_MaunaLoa_NOAA.ipynb`
- `Resultados_Discusion_MaunaLoa.md`
- `SubAGENTS_resolucion_temporal.md`
- `co2_daily_mlo.csv`
- `co2_weekly_mlo.csv`
- `co2_mm_mlo.csv`
- `co2_annmean_mlo.csv`

GISTEMP:
- `Guia_practica_GISTEMP.ipynb`
- `Resultados_Discusion_GISTEMP.md`
- `SubAGENTS_resolucion_espacial.md`
- `gistemp1200_GHCNv4_ERSSTv5.nc.gz`
- `gistemp250_GHCNv4.nc.gz`
- `gistemp1200_GHCNv4_ERSSTv5.nc`
- `gistemp250_GHCNv4.nc`

## Reglas externas detectadas
- Este `AGENTS.md` es la guia principal local.
- No se detectaron reglas de Cursor en `.cursor/rules/`.
- No se detecto archivo `.cursorrules`.
- No se detecto `.github/copilot-instructions.md` en este repo.

## Entorno y dependencias
El trabajo se apoya en el `venv` local.
Paquetes observados: `pandas`, `numpy`, `matplotlib`, `xarray`, `netCDF4`, `nbclient`, `nbformat`, `ipykernel`.
No se detectaron `pyproject.toml`, `requirements.txt`, `pytest.ini`, `ruff.toml` ni configuracion formal de lint o tests.

## Comandos de trabajo
Ejecutar todo desde:
`/home/gentek-g3-esp/jupyterbook/Temas/modelacion ambi/Tarea1ModAmb/Tarea1`

Verificar Python del entorno:
```bash
"./.venv/bin/python" --version
```

Verificar Jupyter por modulo:
```bash
"./.venv/bin/python" -m jupyter --version
```

Ejecutar notebook NOAA completo:
```bash
"./.venv/bin/python" -m jupyter execute "Guia_practica_MaunaLoa_NOAA.ipynb" --kernel_name python3
```

Ejecutar notebook GISTEMP completo:
```bash
"./.venv/bin/python" -m jupyter execute "Guia_practica_GISTEMP.ipynb" --kernel_name python3
```

Smoke check rapido NOAA:
```bash
"./.venv/bin/python" - <<'PY'
import pandas as pd
df = pd.read_csv("co2_mm_mlo.csv", comment="#", header=None)
print(df.shape)
PY
```

Smoke check rapido GISTEMP:
```bash
"./.venv/bin/python" - <<'PY'
import xarray as xr
ds = xr.open_dataset("gistemp1200_GHCNv4_ERSSTv5.nc")
print("tempanomaly" in ds.data_vars)
print(ds["tempanomaly"].dims)
PY
```

## Que significa build, lint y test aqui
Build: no existe build formal; el equivalente es re-ejecutar el notebook afectado sin errores.

Lint: no existe lint oficial; no inventar comandos de `ruff`, `black`, `flake8` o `mypy` como si fueran obligatorios.

Test: no existe suite formal; el equivalente es:
1. ejecutar el notebook del ejercicio afectado,
2. validar salidas numericas clave,
3. revisar consistencia con `Resultados_Discusion_*.md`,
4. revisar consistencia con el `SubAGENTS_*` correspondiente.

Single test: no hay granularidad tipo `pytest path::test_name`; el equivalente mas cercano es ejecutar un solo notebook/ejercicio.

## Convenciones de notebooks y codigo
Idioma y redaccion:
- mantener explicaciones, conclusiones y markdown en espanol,
- escribir con tono tecnico, docente y reproducible,
- priorizar trazabilidad de resultados sobre prosa decorativa.

Estructura esperada:
- imports y configuracion al inicio,
- helpers antes del analisis principal,
- carga y limpieza antes de visualizacion,
- figuras y tablas con interpretacion explicita,
- celdas finales de conclusiones con valores calculados.

Imports, formato y nombres:
- agrupar stdlib primero y terceros despues,
- mantener aliases existentes: `pd`, `np`, `plt`, `xr`,
- seguir PEP 8 como referencia general,
- usar `snake_case` en funciones y variables,
- preferir nombres descriptivos como `read_noaa_co2`, `global_weighted_mean`, `regional_weighted_mean`,
- evitar imports muertos, dependencias nuevas sin justificacion y reformateos masivos.

Tipos, datos y errores:
- no hay tipado estatico obligatorio; usa type hints solo si aclaran,
- mantener semantica como `df_*` para tablas y `ds*` para datasets,
- convertir explicitamente a numerico cuando el origen pueda venir sucio,
- usar `ValueError` para formatos inesperados,
- usar `FileNotFoundError` para datos faltantes,
- usar `KeyError` para variables o dimensiones NetCDF ausentes.

Limpieza y analisis numerico:
- mantener lectura robusta de NOAA con comentarios `#`,
- normalizar sentinelas NOAA `-999.99`, `-99.99` y `-9.99` a `NaN`,
- usar `dropna(...)` de forma explicita luego de coercion numerica,
- alinear coberturas temporales antes de comparar series,
- en GISTEMP, normalizar longitudes y ordenar latitudes antes de recortes regionales,
- mantener ponderacion por `cos(lat)` en promedios espaciales cuando aplique,
- preferir `resample`, `rolling`, `weighted`, `align` y `np.polyfit` antes que logica manual repetitiva.

Graficas:
- mantener `plt.style.use('seaborn-v0_8-whitegrid')` salvo instruccion contraria,
- usar titulos, etiquetas y leyendas claras,
- mantener consistencia de colores entre productos comparados,
- si agregas una figura, agrega tambien su conclusion automatica o interpretacion asociada.

## Reglas de consistencia entre artefactos
Si cambias datos, codigo o metodologia de un ejercicio, revisar siempre:
1. datos de entrada,
2. notebook del ejercicio,
3. `Resultados_Discusion_*.md`,
4. `SubAGENTS_*` del ejercicio.

Reglas obligatorias:
- no dejar cifras del `.md` contradiciendo el notebook,
- no dejar el `SubAGENTS_*` desactualizado si cambian pasos o hallazgos,
- no convertir el notebook en un archivo puramente tecnico; debe seguir siendo explicativo,
- no eliminar conclusiones automaticas sin reemplazo equivalente,
- no asumir que el markdown final se actualiza solo.

## Riesgos y trampas del entorno
- `./.venv/bin/jupyter` puede fallar por shebang roto; usar `./.venv/bin/python -m jupyter`.
- `Guia_practica_GISTEMP.ipynb` contiene rutas absolutas antiguas.
- El metadata de GISTEMP apunta a kernel `gistemp-venv`; para automatizacion conviene `--kernel_name python3`.
- No hay tests ni lockfile; la reproducibilidad depende del entorno local y de re-ejecutar notebooks.
- Los NetCDF son pesados; evitar duplicar artefactos innecesarios.

## Flujo esperado para agentes
Cuando trabajes en un ejercicio:
1. identifica datos de entrada y artefactos derivados,
2. entiende el notebook como fuente principal del procedimiento,
3. realiza cambios minimos y trazables,
4. re-ejecuta el notebook afectado,
5. revisa hallazgos clave impresos,
6. actualiza `Resultados_Discusion_*.md` si cambian resultados,
7. actualiza `SubAGENTS_*` si cambian pasos, decisiones o cifras validadas.

## Checklist antes de cerrar un cambio
- notebook ejecuta completo,
- no se rompieron rutas de entrada,
- resultados clave siguen siendo coherentes,
- markdown final coincide con el notebook,
- `SubAGENTS_*` refleja el proceso actual,
- no se introdujeron rutas absolutas nuevas,
- no se agregaron dependencias innecesarias.
