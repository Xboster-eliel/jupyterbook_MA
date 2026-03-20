---
title: "Inciso 2: Estructuras de redes profundas para series de tiempo univariadas"
---

# Inciso 2: Estructuras de redes profundas para series de tiempo univariadas

## Planteamiento
Replicar el ejercicio sobre precios historicos de Ethereum (`ETH`) desde `2015` hasta `2025`, enfocando el analisis en una serie univariada de rendimientos logaritmicos y comparando modelos de aprendizaje profundo con un modelo clasico de volatilidad.

El flujo del inciso reproduce estas etapas:

1. lectura de la serie `price`,
2. construccion de rendimientos logaritmicos,
3. analisis de estacionariedad, autocorrelacion y heteroscedasticidad,
4. ajuste de un modelo `LSTM`,
5. ajuste de un `LSTM` con `EarlyStopping`,
6. comparacion final con un modelo `GARCH(1,1)`.

## Entregables
- Notebook reproducible con el flujo completo de analisis y modelado.
- Documento de resolucion con resultados, interpretacion y comparacion entre modelos.

## Resolucion y notebook asociado
- [Resolucion Inciso 2: Estructuras de redes profundas para series de tiempo univariadas](resolucion-inciso-2-redes-profundas-series-univariadas)
- [Notebook asociado](../notebooks/redes_profundas_eth_univariada)

## Referencia base
- Natalia Acevedo Prins, `Estructuras de redes profundas para series de tiempo univariadas`.
