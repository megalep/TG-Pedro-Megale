# TG-Pedro-Megale
Códigos usados no Trabalho de Graduação Desenvolvimento de um Canal Independente de Medida de Bioimpedância

## Programas:

### SingleChannelAtSampleRateSimpleDigOut_PWM

Programa para verificação da taxa de amostragem da coleta dados analogicos do conversor AD do STM32. 

programa cria um PWM  software, coleta esse PWM (necessário ligar os pinos A0 e B0), e calcula a taxa de amostragem.

A taxa de amostragem é controlada por um Timer via hardware, que dispara o conversor AD.

O programa funciona da seguinte forma:

inicia a coleta de dados no setup();

ao completar o buffer, pausa o timer e liga a flag_lido;

transmite os dados coletados por Serial;

aguarda 1000ms e reinicia o Timer e, com isso, a coleta.

Enquanto isso, cria um PWM (por software) na porta PB0 de frequencia aproximada sampleFreqkHz/50.

### SingleChannelAtSampleRateSimpleDigOut_Celular

Programa para verificação da taxa de amostragem da coleta dados analogicos do conversor AD do STM32. 

O programa coleta o sinal enviado pelo celular que foi usado como gerador de sinais (ligar ao pino A0), e calcula a taxa de amostragem.

A taxa de amostragem é controlada por um Timer via hardware, que dispara o conversor AD.

O programa funciona da seguinte forma:

inicia a coleta de dados no setup();

ao completar o buffer, pausa o timer e liga a flag_lido;

transmite os dados coletados por Serial;

aguarda 1000ms e reinicia o Timer e, com isso, a coleta.


### Matriz_inversa

Programa em MATLAB que calcula matriz pseudo inversa de demodulação por quadratura para onda senoidal coletada no STM32 usando o programa SingleChannelAtSampleRateSimpleDigOut_Celular

### Demodulação

Programa usado para calcular amplitude e fase de uma onda senoidal de 20 kHz coletada pelo ADC e envia valores para porta serial.

O programa usa como parâmetro a matriz pseudo inversa calculada pelo programa Matriz_inversa.

inicia a coleta no setup();

ao completar o buffer, pausa o timer e liga a flag_lido;

calcula amplitude e fase, e trasmite os dados calcuclados por Serial;

Reinicia o Timer e, com isso, a coleta.

