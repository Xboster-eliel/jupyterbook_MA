# Lineamientos editoriales para Jupyter Book v2 (MyST)

## Objetivo
Operativizar el contrato editorial definido en `AGENTS.md` con reglas de redaccion, plantillas y ejemplos aplicables a cada book.

## Perfil activo en este proyecto
Perfil B: book docente por curso.

## Arquitectura obligatoria del book (Perfil B)
1) Pagina principal `Content` con tabla de capitulos del curso.
2) Capitulo por tarea/actividad (`Capitulo N: ...`).
3) Glosario por capitulo en `Definitions`.
4) Incisos por tarea (procedimiento/planteamiento).
5) Resolucion por inciso (pagina separada).
6) Notebook asociado por inciso (si aplica).
7) Capitulos siguientes pueden existir sin hijos si estan pendientes.

## Reglas de navegacion
- El inciso debe aparecer antes que su resolucion.
- Resolucion y notebook deben colgar del capitulo, no del nivel global.
- Capitulo 2 (y siguientes) no debe tener hijos si esta vacio.

## Plantillas obligatorias (Perfil B)

### Portada `index.md`
```
---
title: Content
---

# Content

## Capitulos: Tabla de contenido
* [Capitulo 1: Actividad #1](capitulo-1-actividad-1)
* [Capitulo 2: Modelo conceptual de Inundacion Regional](capitulo-2-modelo-conceptual-inundacion-regional)
```

### Capitulo `content/capitulo-N-...md`
```
---
title: "Capitulo N: Titulo del capitulo"
---

# Capitulo N: Titulo del capitulo

## Glosario
El glosario de este capitulo esta en:
- [Definitions](definitions)

## Subcapitulos (tabla de contenido)
* [Definitions](definitions)
* [Inciso 1: ...](inciso-1)
* [Resolucion Inciso 1: ...](resolucion-inciso-1)
* [Notebook asociado](notebook-asociado)
* [Inciso 2: ...](inciso-2)
* [Inciso 3: ...](inciso-3)
```

### Glosario `content/definitions.md`
```
---
title: Definitions
---

# Definitions

- CO2: Dioxido de carbono atmosferico.
- NOAA: National Oceanic and Atmospheric Administration.
```

### Inciso `content/inciso-1.md`
```
---
title: "Inciso 1: Titulo del inciso"
---

# Inciso 1: Titulo del inciso

## Planteamiento
...

## Entregables
- Notebook reproducible.
- Documento de resultados y discusion.

## Resolucion y notebook asociado
- [Resolucion Inciso 1: ...](resolucion-inciso-1)
- [Notebook asociado](notebook-asociado)

## Referencias base (opcional)
- TBD
```

### Resolucion `content/resultados-...md`
```
---
title: "Resolucion Inciso 1: Titulo del inciso"
---

# Resolucion Inciso 1: Titulo del inciso

Contenido de la resolucion.
```

### Notebook asociado
- Ubicar en `notebooks/`.
- Incluir en el TOC bajo el capitulo correspondiente.

## Regla de titulos YAML
- Si el `title` contiene `:`, debe ir entre comillas.

## MyST v2: TOC obligatorio con extends
- El TOC no debe ser legacy (`_toc.yml`, `jb-book`).
- Usar `toc.yml` con formato MyST v2 y cargarlo con `extends:` en `myst.yml`.

### `myst.yml` (ejemplo valido)
```
version: 1
project:
  id: <uuid>
  title: Modelacion Ambiental
  description: Tarea #1

extends:
  - toc.yml

site:
  template: book-theme
```

### `toc.yml` (ejemplo valido)
```
version: 1
project:
  toc:
    - file: index.md
    - file: content/capitulo-1-actividad-1.md
      children:
        - file: content/definitions.md
        - file: content/tarea-1-agregacion-temporal-co2.md
        - file: content/Resultados_Discusion_MaunaLoa.md
        - file: notebooks/Guia_practica_MaunaLoa_NOAA.ipynb
        - file: content/tarea-1-punto-2.md
        - file: content/tarea-1-punto-3.md
    - file: content/capitulo-2-modelo-conceptual-inundacion-regional.md
```

## Copia de resoluciones con imagenes
- Si un .md trae una carpeta `files/`, copiar ambos al book y mantener rutas relativas.
- Ejemplo:
  - `content/Resultados_Discusion_MaunaLoa.md`
  - `content/files/`

## Contenido colapsable
- No usar HTML crudo `<details>` para secciones con tablas, listas o Markdown complejo.
- Usar directivas MyST `dropdown` para garantizar que el contenido quede dentro del colapsable.
- Plantilla recomendada:
```
:::{dropdown} Titulo
Contenido en Markdown.
:::
```

## Checklist de validacion
- `Content` lista capitulos del curso.
- `Capitulo 1` contiene `Definitions`, incisos, resolucion y notebook.
- `Capitulo 2` no tiene hijos si esta vacio.
- El inciso aparece antes que su resolucion en la navegacion.
- `myst.yml` usa `extends: toc.yml` y el TOC es MyST v2.
- Titulos con `:` estan entre comillas.
