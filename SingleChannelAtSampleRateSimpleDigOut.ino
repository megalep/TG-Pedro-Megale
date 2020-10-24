// Coleta dados analogicos do conversor AD;
// A taxa de amostragem eh controlada por um Timer via hardware
// O programa funciona da seguinte forma:
//   - inicia a coleta no setup();
//   - ao completar o buffer, pausa o timer e liga a flag_lido;
//   - transmite os dados coletados por Serial;
//   - aguarda 1000ms e reicinia o Timer e, com isso, a coleta.
// Enquanto isso, cria um PWM (por software) na porta PB0 de frequencia aproximada sampleFreqkHz/50.
//   - se ligar a porta A0 na porta B0, deverao aparecer aprox 10 ciclos quadrados no Plotter Serial,
//     independentemente da frequencia usada...

#include <HardwareTimer.h>
#include <STM32ADC.h>

#define pinLED  PC13 // LED interno da placa
#define pinOUT  PB0

// Channels to be acquired.
// A0 (adc1 channel 1)
uint8 pins = 0;

#define maxSamples  500 // Numero de amostras a serem lidas de cada vez
uint16_t buffer[maxSamples];
uint8_t flag_lido;
uint16_t contador;

#define sampleFreqKhz       1000
#define samplePeriodus      1000 / sampleFreqKhz
#define ticksPerSecond      2 * sampleFreqKhz * 1000 / maxSamples

STM32ADC myADC(ADC1);

void TimerIRQ(void) { // O timer serve soh como trigger do ADC... 1 a cada amostra
}

void DmaIRQ(void) { // Completou o buffer...
  Timer3.pause();
  flag_lido = 1;
  digitalWrite(pinLED, ! digitalRead(pinLED)); // altera estado do LED
}

void setup() {

  pinMode(pinLED, OUTPUT);
  pinMode(pinOUT, OUTPUT);
  pinMode(pins, INPUT_ANALOG);

  Serial.begin(115200);

  flag_lido = 0;
  contador = 0;

  Timer3.setPeriod(samplePeriodus);
  Timer3.setMasterModeTrGo(TIMER_CR2_MMS_UPDATE);

  myADC.calibrate();
  myADC.setSampleRate(ADC_SMPR_1_5); // a cada trigger, a conversao eh feita o mais rapido possivel.
                                     // Talvez de para diminuir para melhorar acuracia da medida.
  myADC.setPins(&pins, 1);

  // Configurando DMA com:
  // - DMA_MINC_MODE: Auto-increment memory address
  // - DMA_CIRC_MODE: Circular mode
  // - DMA_TRNS_CMPLT: Interrupt on transfer completion
  myADC.setDMA(buffer, maxSamples, (DMA_MINC_MODE | DMA_CIRC_MODE | DMA_TRNS_CMPLT), DmaIRQ);
  
  myADC.setTrigger(ADC_EXT_EV_TIM3_TRGO); // ajusta Timer3 como trigger
  myADC.startConversion();
}

void loop() {

    if (flag_lido == 1) {
        // process data
        int nn;
        int ntotal = maxSamples;
        for (nn=0; nn<ntotal; nn++){
            Serial.println(buffer[nn]); // Envia dados pela serial como ASCII, para ser visto com o 'Plotter Serial'
        }
        flag_lido=0;
        delay(1000); // aguarda 1000ms (1s)
        
        Timer3.resume(); // reinicia o timer e o ADC
    }

    // Cria um PWM na porta PB0 de frequencia aproximada sampleFreqkHz/50
    if (contador == 50000/sampleFreqKhz){
      digitalWrite(pinOUT, LOW);
      contador = 0;
    }
    else if (contador == 25000/sampleFreqKhz){
      digitalWrite(pinOUT, HIGH);
    }
    contador += 1;
    
}
