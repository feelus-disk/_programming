//----------------------------------------------------------------------------------
// Функции, относящиеся к системе
//----------------------------------------------------------------------------------

#include "Board.h"

//инициализация основных узлов системы
void CPUinit()
  {
  //нициализация EFC (Flash-памяти)
  AT91C_BASE_MC->MC_FMR = AT91C_MC_FWS_1FWS ; // 1 цикла на чтение, 3 цикла на запись
  //настройка тактовых частот
  //включение и задание времени запуска основного генератора
  AT91C_BASE_PMC->PMC_MOR = (( AT91C_CKGR_OSCOUNT & (0x40 <<8) | AT91C_CKGR_MOSCEN ));
  // ожидание стабилизации частоты основного генератора
  while(!(AT91C_BASE_PMC->PMC_SR & AT91C_PMC_MOSCS));
  //задание  частоты PLL  96,109 МГц и такт частоты UDP 48,058 МГц
  AT91C_BASE_PMC->PMC_PLLR = AT91C_CKGR_USBDIV_1|(16 << 8) |
                               (AT91C_CKGR_MUL & (72 << 16)) |
                               (AT91C_CKGR_DIV & 14);
  //ожидание стабилизации PLL
  while( !(AT91C_BASE_PMC->PMC_SR & AT91C_PMC_LOCK) );
    // ожидание стабилизации задающей частоты от PLL
  while( !(AT91C_BASE_PMC->PMC_SR & AT91C_PMC_MCKRDY) );
  //задание задающей частоты и частоты процессора PLL/2=48 МГц
  //регистр PMC_MCKR не должен програмироваться одной операцией записи
  AT91C_BASE_PMC->PMC_MCKR = AT91C_PMC_PRES_CLK_2;
  // ожидание стабилизации задающей частоты
  while( !(AT91C_BASE_PMC->PMC_SR & AT91C_PMC_MCKRDY) );
  AT91C_BASE_PMC->PMC_MCKR |= AT91C_PMC_CSS_PLL_CLK;
  // ожидание стабилизации задающей частоты
  while( !(AT91C_BASE_PMC->PMC_SR & AT91C_PMC_MCKRDY) );
  // отключение сторожевого таймера
  AT91C_BASE_WDTC->WDTC_WDMR = AT91C_WDTC_WDDIS;
  // разрешение тактирования PIO
  AT91F_PMC_EnablePeriphClock ( AT91C_BASE_PMC, 1 << AT91C_ID_PIOA ) ;
  // конфигурирование линий  PIO как выходов обслуживания светодиодов LED1,...LED4
  AT91F_PIO_CfgOutput( AT91C_BASE_PIOA, LED_MASK ) ;
  // установка выходов - гашение светодиодов
  AT91F_PIO_SetOutput( AT91C_BASE_PIOA, LED_MASK ) ;
  // конфигурирование линии  PIO как выхода генерации частоты отриц напряж для LCD
  AT91F_PIO_CfgOutput( AT91C_BASE_PIOA, U_NEG ) ;
  // сброс выхода генерации частоты отриц напряж для LCD
  AT91F_PIO_ClearOutput( AT91C_BASE_PIOA, U_NEG ) ;
  // конфигурирование линий  PIO как выходов обслуживания ЖКИ
  AT91F_PIO_CfgOutput( AT91C_BASE_PIOA, LCD_MASK ) ;
  // сброс выходов обслуживания ЖКИ
  AT91F_PIO_ClearOutput( AT91C_BASE_PIOA, LCD_MASK ) ;
  }

