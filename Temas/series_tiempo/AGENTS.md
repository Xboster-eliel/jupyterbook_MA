# AGENTS.md

## Alcance
Este archivo vive en la carpeta de trabajo `Temas/series_tiempo` y aplica primero a este proyecto.
Combina dos capas de instrucciones para agentes:
1. guia tecnica local del proyecto `Temas/series_tiempo`,
2. contrato editorial y estructural para el Jupyter Book de esta misma carpeta.

Si hay conflicto, aplica esta prioridad:
1. reproducibilidad tecnica,
2. reglas editoriales del book,
3. estilo inferido de notebooks y capitulos existentes.

## Contexto del proyecto
- El subproyecto activo es `Temas/series_tiempo`.
- Es un Jupyter Book basado en MyST v2, no un paquete Python tradicional.
- La fuente principal son notebooks `.ipynb` y paginas `.md` en `content/`.
- El entorno virtual local es `Temas/series_tiempo/.venv`.
- No se detectaron reglas de Cursor ni Copilot en `.cursorrules`, `.cursor/rules/` o `.github/copilot-instructions.md`.

## Comandos de trabajo

### Entorno
- Activar entorno: `source /home/gentek-g3-esp/jupyterbook/Temas/series_tiempo/.venv/bin/activate`
- Python del proyecto: `/home/gentek-g3-esp/jupyterbook/Temas/series_tiempo/.venv/bin/python`

### Book
- Iniciar book local: `/home/gentek-g3-esp/jupyterbook/Temas/series_tiempo/start-book.sh`
- Alternativa directa: `.venv/bin/jupyter-book start`
- Iniciar sin UI completa: `.venv/bin/jupyter-book start --headless`
- Build HTML completo: `.venv/bin/jupyter-book build --html --all`
- Build del sitio: `.venv/bin/jupyter-book build --site --all`
- Build con ejecucion de notebooks: `.venv/bin/jupyter-book build --html --execute --all`
- Build estricto: `.venv/bin/jupyter-book build --html --all --strict`
- Limpiar artefactos: `.venv/bin/jupyter-book clean --all`

### Validacion por archivo unico
- Este repo no tiene `pytest` configurado ni suite de tests tradicional.
- La validacion mas cercana a "single test" es construir o ejecutar solo el archivo afectado.
- Build de una pagina/notebook puntual: `.venv/bin/jupyter-book build --html content/archivo.md --execute`
- Build de un notebook puntual: `.venv/bin/jupyter-book build --html notebooks/mlp_series_tiempo_nueva_york.ipynb --execute`
- Si solo cambias Markdown sin codigo, puedes omitir `--execute`.

### Estado actual de lint/test
- No hay `pyproject.toml`, `pytest.ini`, `conftest.py`, `tox`, `nox` ni `.pre-commit-config.yaml` en `Temas/series_tiempo`.
- No inventes comandos de lint inexistentes como `ruff`, `black` o `pytest` si no agregaste esa infraestructura.
- Si creas un script Python nuevo, ejecútalo y corrige errores hasta que termine con exito.

## Dependencias detectadas
- Book: `jupyter-book 2.1.2`
- Analisis: `pandas`, `numpy`, `matplotlib`, `plotly`, `statsmodels`
- ML: `scikit-learn`, `scikeras`, `tensorflow`, `arch`
- I/O: `openpyxl`

## Convenciones de codigo observadas

### Imports
- Ordena imports en tres grupos: libreria estandar, terceros, luego proyecto/locales.
- Deja una linea en blanco entre grupos.
- Evita imports duplicados en una misma celda o script salvo que el notebook requiera separarlos por narrativa.

### Rutas y archivos
- Usa `from pathlib import Path` como opcion por defecto.
- Mantén compatibilidad con ejecucion desde raiz del proyecto o desde `notebooks/`.
- Patron preferido:
  - `base_dir = Path.cwd().resolve()`
  - `if base_dir.name == 'notebooks': project_dir = base_dir.parent`
  - `else: project_dir = base_dir`
- No hardcodees rutas absolutas externas al repo salvo que ya existan y sean parte explicita del flujo reproducible.

### Nombres
- Usa `snake_case` para funciones, variables y helpers.
- Usa nombres descriptivos y orientados al dominio: `log_returns`, `station_codes`, `create_sequences`, `compute_metrics`.
- Mantén titulos, texto explicativo y nombres de pasos en espanol, como en los notebooks existentes.

### Tipos y estructuras de datos
- Prefiere `DataFrame` y `Series` de pandas para etapas de preparacion, analisis y reporte.
- Convierte a `numpy` solo cuando el modelo o el calculo numerico lo exija.
- Cuando un helper sea reutilizable o no trivial, agrega type hints si mejoran claridad; ya hay precedentes en el notebook de imputacion.
- Para objetivos 1D, usa patrones explicitos como `reshape(-1, 1)` y `flatten()` al escalar/invertir escalado.

### Formato y estilo
- Sigue el estilo ya presente: simple, legible y sin comentarios excesivos.
- Prefiere funciones pequenas para pasos reutilizables en vez de bloques enormes repetidos.
- Usa una variable por concepto y evita abreviaturas opacas fuera de notacion estandar (`X`, `y`, `M_art`, `M_real`).

### Reproducibilidad
- Fija semillas cuando haya aleatoriedad: `np.random.seed(42)`, `tf.random.set_seed(42)` o `np.random.default_rng(42)`.
- Mantén trazabilidad de datasets y resultados con `print`, tablas o salidas visibles en notebook.
- No cambies silenciosamente el dataset base ni sobrescribas archivos fuente sin decirlo.

### Series de tiempo y ML
- Evita fuga temporal: usa ventanas causales y validacion temporal.
- Prefiere `TimeSeriesSplit` sobre particiones aleatorias cuando haya ajuste de hiperparametros.
- Escala `X` y `y` por separado cuando el modelo lo requiera.
- Invierte transformaciones antes de reportar metricas finales en unidades del problema.
- Si entrenas redes, documenta `epochs`, `batch_size`, `validation_split`, callbacks y semillas.
- Si un notebook usa `EarlyStopping` o `ReduceLROnPlateau`, conserva ese patron salvo razon fuerte para cambiarlo.

### Manejo de errores y datos sucios
- Usa conversiones defensivas como `pd.to_numeric(..., errors='coerce')` cuando la fuente pueda venir sucia.
- Preserva `NaN` cuando forman parte del problema analitico, por ejemplo en imputacion.
- Valida formas (`shape`), tamanos y rangos antes de entrenar modelos o exportar resultados.

### Visualizacion
- Mantén coherencia con el stack actual: `matplotlib` y `plotly`.
- Usa graficas para justificar decisiones metodologicas, no solo decoracion.
- Si el problema es matricial grande, resume con subconjuntos representativos y metricas globales, como ya hace el notebook de precipitacion.

## Contrato editorial y estructural para Jupyter Book (MyST)

### Objetivo general
Generar o mantener notebooks y books con una convencion editorial, cientifica y estructural estricta: reproducibilidad, claridad taxonomica, trazabilidad a publicaciones, consistencia entre capitulos y legibilidad para lectores tecnicos y no expertos.

### Perfiles de book admitidos
Antes de escribir, elegir un perfil y aplicarlo en todo el book.

#### Perfil A: coleccion editorial cientifica
Estructura obligatoria, en este orden:
1. titulo principal,
2. `Table of Contents`,
3. introduccion editorial breve,
4. `About This Book`,
5. capitulos numerados (`Chapter 1`, `Chapter 2`, ...),
6. `Future Chapters`,
7. `Definitions`.

#### Perfil B: book docente por curso
Este es el modo activo en este proyecto.
Estructura obligatoria:
1. pagina principal `Content`,
2. capitulo por tarea/actividad (`Capitulo N: ...`),
3. glosario por capitulo,
4. incisos por tarea,
5. resolucion por inciso en pagina separada,
6. notebook asociado por inciso cuando aplique,
7. capitulos futuros pueden quedar pendientes sin hijos.

Reglas clave del Perfil B:
- la navegacion anida incisos, resoluciones y notebooks dentro del capitulo,
- el glosario es por capitulo, no global,
- el inciso aparece antes de su resolucion,
- los notebooks quedan como hijos del capitulo, no al nivel de capitulos.

### Metadatos cientificos cuando aplique
- `Author(s)`: nombres completos y orden autoral original.
- `Objective`: una sola frase clara y especifica.
- `ML method(s) and concepts)`: bullets jerarquicos con ` > `.
- `Data source(s)`: bullets jerarquicos con ` > `.
- `Published and refereed paper`: referencia breve con enlace estable, o `Not yet published` / `No refereed paper available`.

Formatos esperados:
- `Area general > familia metodologica > tecnica especifica > implementacion o libreria`
- `Dominio de datos > subtipo > variable, senal o producto derivado > mision, instrumento o repositorio`

### Consistencia editorial
Todos los capitulos deben ser homogeneos en:
- orden de campos,
- estilo de redaccion,
- granularidad de detalle,
- tipo de bullets,
- formato de enlaces,
- uso de nombres tecnicos.

No mezclar estilos entre capitulos.

### Convenciones semanticas
- La convencion ` > ` expresa jerarquia conceptual real.
- Evita metadatos narrativos; se compacto y estructurado.

### Reglas tecnicas MyST v2
- El TOC se define en `project.toc` dentro de `myst.yml` o en un archivo extendido.
- No usar `_toc.yml` legacy ni formato `jb-book`.
- Si existe `toc.yml`, debe seguir MyST v2 con `version: 1`.
- Si el `title` contiene `:`, debe ir entre comillas.

### Lo que el agente debe evitar
- crear capitulos sin plantilla del perfil activo,
- omitir autores, objetivo, metodos, datos o referencia cuando haya trazabilidad cientifica,
- usar listas de metodos o datos sin jerarquia,
- romper la uniformidad de encabezados,
- introducir secciones nuevas sin justificacion fuerte,
- mezclar Perfil A y Perfil B dentro del mismo book.

### Resultado esperado
Cada notebook o capitulo nuevo debe parecer parte de una misma coleccion editorial y permitir identificar rapidamente:
- quien hizo el trabajo,
- cual era el problema,
- que metodo se uso,
- que datos lo soportan,
- que paper lo respalda cuando aplique.

### Lineamientos editoriales adicionales
Ver `/home/gentek-g3-esp/jupyterbook/AGENTS_redactor.md` para plantilla editable, ejemplos correctos e instrucciones de estilo MyST.
