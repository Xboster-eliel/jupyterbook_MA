---
title: "Protocolo metodologico"
---

# Protocolo metodologico

## Proposito

Esta nota resume el plan maestro de verificacion metodologica del `Capitulo 2: Imputando series de precipitacion mensual`. Su objetivo es dejar explicitos los criterios que gobiernan la evaluacion de metodos de imputacion y comprobar que el notebook implementa un protocolo consistente con la literatura reciente.

## Principios que rigen el capitulo

1. definir un protocolo de imputacion explicito antes de cualquier comparacion final,
2. separar la evaluacion principal contra valores realmente observados de la comparacion secundaria contra reconstrucciones externas,
3. tratar la mascara artificial como `overlay masking`,
4. evitar fuga de informacion en el orden `masking -> reconstruccion inicial -> escalado/entrenamiento -> evaluacion`,
5. mantener trazabilidad entre decisiones metodologicas, codigo y resultados.

## Protocolo operativo aplicado

El notebook del capitulo sigue esta secuencia:

1. construir la matriz original con faltantes reales `M_real`,
2. crear una mascara artificial reproducible `M_art` sobre valores originalmente observados,
3. superponer `M_art` sin alterar los `NaN` reales,
4. obtener la matriz de trabajo `Y_work`,
5. construir dos reconstrucciones iniciales:
   - `interpolacion`,
   - `forecast_filled`,
6. entrenar modelos multivariados sobre ventanas temporales de toda la matriz,
7. evaluar primero sobre los valores reales ocultados por `M_art`,
8. comparar despues contra `LluviaAcum7615_Reconstruida` solo como benchmark externo.

## Criterios de verificacion

El estado del proyecto se considera alineado con la literatura si se verifica que:

- la hoja `LluviaAcum7615_Reconstruida` no se usa como verdad observada principal,
- la validacion principal se hace sobre observaciones reales ocultadas artificialmente,
- la mascara artificial se aplica como `overlay` sobre la estructura real de faltantes,
- los rellenos base no recuperan informacion a partir de valores ocultados,
- el ranking de metodos se reporta en dos niveles:
  - reconstruccion inicial,
  - modelo final de imputacion,
- las conclusiones se apoyan tanto en metricas globales como en analisis por estacion.

## Metricas del capitulo

Las metricas principales son:

- `MSE`,
- `RMSE`,
- `MAE`,
- `R2`,
- `NSE`.

En esta formulacion concreta, `R2` y `NSE` coinciden numericamente porque ambas expresan la misma razon entre error cuadratico y variabilidad respecto a la media observada.

## Lectura recomendada de resultados

- La **evaluacion principal** responde: que tan bien reconstruye cada metodo valores reales ocultados.
- La **comparacion secundaria** responde: que tan parecido es cada metodo a la reconstruccion convexa externa.
- El **analisis por estacion** responde: donde el metodo global es robusto y donde pierde desempeno.
- Los **mosaicos** permiten visualizar diferencias locales entre escenario con faltantes, referencia, imputacion y error.

## Estado actual del proyecto

En el estado actual, el proyecto ya contempla y aplica los lineamientos metodologicos principales:

- protocolo explicito,
- evaluacion principal sobre observados ocultados,
- benchmark externo separado,
- `overlay masking`,
- orden anti-leakage,
- comparacion entre reconstrucciones iniciales,
- comparacion entre modelos finales,
- analisis global y por estacion.

## Relacion con la literatura citada

- **Teresita Canchala-Nastar et al. (2019)** refuerza la necesidad de definir un protocolo de imputacion antes del analisis. Este capitulo ya lo explicita.
- **Linglong Qian et al. (2024)** enfatiza que el ranking depende del masking y de la definicion de objetivos. Este capitulo separa la validacion principal sobre observados ocultados de la comparacion externa contra una reconstruccion previa.
- El uso de `overlay masking` y el orden `masking -> reconstruccion -> entrenamiento/evaluacion` quedan adoptados como criterio central del proyecto.

## Uso de esta nota

Esta pagina debe leerse como referencia corta para auditar el notebook del capitulo. Si en futuras iteraciones se cambian el diseno del masking, las reconstrucciones iniciales o las metricas, esta nota debe actualizarse junto con la resolucion y el notebook asociado.
