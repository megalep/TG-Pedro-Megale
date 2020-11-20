# TG-Pedro-Megale
Códigos usados no Trabalho de Graduação Desenvolvimento de um Canal Independente de Medida de Bioimpedância

## Programas:

### SingleChannelAtSampleRateSimpleDigOut_PWM

Programa para verificação da taxa de amostragem da coleta dados analogicos do conversor AD do STM32. 

programa cria um PWM  software, coleta esse PWM (necessário ligar os pinos A0 e B0), e calcula a taxa de amostragem.

A taxa de amostragem é controlada por um Timer via hardware, que dispara o conversor AD.

O programa funciona da seguinte forma:

inicia a coleta no setup();
ao completar o buffer, pausa o timer e liga a flag_lido;
transmite os dados coletados por Serial;
aguarda 1000ms e reicinia o Timer e, com isso, a coleta.
Enquanto isso, cria um PWM (por software) na porta PB0 de frequencia aproximada sampleFreqkHz/50.
se ligar a porta A0 na porta B0, deverao aparecer aprox 10 ciclos quadrados no Plotter Serial, independentemente da frequencia usada.

### SingleChannelAtSampleRateSimpleDigOut_Celular

Programa para verificação da taxa de amostragem da coleta dados analogicos do conversor AD do STM32. 

O programa coleta o sinal enviado pelo celular que foi usado como gerador de sinais (ligar ao pinos A0), e calcula a taxa de amostragem.

A taxa de amostragem é controlada por um Timer via hardware, que dispara o conversor AD.

O programa funciona da seguinte forma:

inicia a coleta no setup();
ao completar o buffer, pausa o timer e liga a flag_lido;
transmite os dados coletados por Serial;
aguarda 1000ms e reicinia o Timer e, com isso, a coleta.

### Demodulação:

Programa usado para calcular amplitude e fase de uma onda senoidal de 20 kHz coletada pelo ADC e envia valores para porta serial.



