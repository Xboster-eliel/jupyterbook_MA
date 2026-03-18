# Contrato editorial y estructural para Jupyter Book (MyST)

## Objetivo general
Quiero que generes o mantengas notebooks y books de Jupyter siguiendo una convencion editorial, cientifica y estructural estricta. Este archivo actua como contrato de estilo y organizacion del contenido. Todos los books deben mantener una arquitectura homogenea, facil de navegar, cientificamente trazable y apta para reproducibilidad.

## Principios obligatorios
El agente debe priorizar siempre:
1) reproducibilidad,
2) claridad taxonomica,
3) trazabilidad a publicaciones,
4) consistencia entre capitulos,
5) legibilidad para lectores tecnicos y no expertos del dominio.

## Perfiles de book admitidos
Este contrato define dos perfiles. Antes de escribir, se debe elegir uno y aplicarlo en todo el book:

### Perfil A: coleccion editorial cientifica
Se usa cuando el book es una coleccion de capitulos de investigacion con estructura canonica.

Estructura obligatoria:
1. Titulo o encabezado principal del book.
2. Seccion `Table of Contents`.
3. Introduccion editorial breve del book.
4. Seccion `About This Book`.
5. Capitulos numerados consecutivamente (`Chapter 1`, `Chapter 2`, etc.).
6. Seccion final `Future Chapters`.
7. Seccion final `Definitions` (glosario).

No se debe alterar este orden salvo instruccion explicita.

### Perfil B: book docente por curso (modo activo en este proyecto)
Se usa cuando el book representa un curso y cada capitulo es una tarea/actividad con incisos. Este perfil reemplaza la estructura del Perfil A.

Estructura obligatoria:
1. Pagina principal `Content` con tabla de capitulos del curso.
2. Capitulo por tarea/actividad (`Capitulo N: ...`).
3. Glosario por capitulo (pagina `Definitions` dentro del capitulo).
4. Incisos por tarea (cada inciso con su procedimiento/planteamiento).
5. Resolucion por inciso (pagina separada).
6. Notebook asociado por inciso (si aplica).
7. Capitulos siguientes pueden existir sin hijos si estan pendientes.

Reglas clave del Perfil B:
- La navegacion debe anidar incisos, resoluciones y notebooks dentro del capitulo correspondiente.
- El glosario es por capitulo, no global.
- El inciso debe aparecer antes de su resolucion en la navegacion.
- Los notebooks deben quedar como hijos del capitulo, no al mismo nivel de capitulos.

## Reglas de metadatos cientificos (cuando aplique)
Aplican a Perfil A y a cualquier capitulo del Perfil B que documente investigacion con trazabilidad.

### Author(s)
- Incluir nombres completos cuando esten disponibles.
- Respetar el orden autoral original si proviene de una publicacion.
- No abreviar salvo que la fuente original asi lo haga.

### Objective
- Una sola frase clara y especifica.
- Debe describir el problema cientifico o tecnico, no una tarea vaga.
- Debe expresar el proposito aplicado: predecir, detectar, clasificar, reconstruir, mejorar resolucion, caracterizar, simular o pronosticar.

### ML method(s) and concepts
- Usar estructura jerarquica con ` > `.
- Un bullet por metodo.
- De lo general a lo especifico.

Formato esperado:
- `Area general > familia metodologica > tecnica especifica > implementacion o libreria`

### Data source(s)
- Usar estructura jerarquica con ` > `.
- Un bullet por fuente.
- De la naturaleza del dato al repositorio/instrumento.

Formato esperado:
- `Dominio de datos > subtipo > variable, senal o producto derivado > mision, instrumento o repositorio`

### Published and refereed paper
- Si existe paper, incluir referencia breve y enlace estable.
- Si no existe paper: `Not yet published` o `No refereed paper available`.

## Reglas de consistencia editorial
Todos los capitulos deben ser homogeneos en:
- orden de campos,
- estilo de redaccion,
- granularidad de detalle,
- tipo de bullets,
- formato de enlaces,
- uso de nombres tecnicos.

No mezclar estilos entre capitulos.

## Convenciones semanticas
- La convencion ` > ` solo expresa jerarquia conceptual real.
- Evitar descripciones demasiado narrativas dentro de metadatos; ser compactos y estructurados.

## Reglas tecnicas MyST v2 (obligatorias)
- El TOC se define en `project.toc` dentro de `myst.yml` o en un archivo externo incluido con `extends:`.
- No usar el formato legacy `jb-book` ni `_toc.yml` en proyectos MyST v2.
- Si se usa `toc.yml`, debe ser formato MyST v2 con `version: 1` y `project: toc: ...`.
- Si el `title` de frontmatter contiene `:`, debe ir entre comillas.

## Que debe evitar el agente
El agente no debe:
- crear capitulos sin la plantilla requerida por el perfil activo,
- omitir autores, objetivo, metodos, datos o referencia cuando se declare trazabilidad cientifica,
- usar listas de metodos o datos sin jerarquia,
- romper la uniformidad de encabezados,
- introducir secciones nuevas sin justificacion editorial fuerte,
- mezclar perfiles A y B en un mismo book.

## Resultado esperado
Cada nuevo notebook o capitulo debe parecer parte de una misma coleccion editorial. La estructura debe permitir identificar rapidamente:
- quien hizo el trabajo,
- cual era el problema,
- que metodo se uso,
- que datos lo soportan,
- que paper lo respalda (si aplica).

## Lineamientos editoriales y de redaccion
Ver `AGENTS_redactor.md` para plantilla editable, ejemplos correctos e instrucciones de estilo MyST.
