//-------------------------------------------------------------------------
// Основная программа обслуживания PC-клавиатуры
//-------------------------------------------------------------------------

#include "Board.h"

//флаги нажатия кнопок
volatile extern U8 flagn_kn1, flagn_kn2, flagn_kn3, flagn_kn4;

volatile extern U8 DATA_KB; //принятый байт из PC-клавиатуры
volatile extern U8 flag_rd_kb; // флаг "принят байт из PC-клавиатуры"

static  U8 J=0;            //адрес в ОЗУ ЖКИ (адрес индикации символа)


//начало основной программы
void main(void)
{
  CPUinit();         //инициализация системы
  timer_init();      //инициализация таймеров-счетчиков
  irq_pio_init();    // инициализация внешних прерываний
  LCDinit_clear();   //нач инициализация и сброс ЖКИ

  // Вывод на ЖКИ начальной заставки
  lcd_pro_data('P', 0);
  lcd_tek_data('C');
  lcd_tek_data('_');
  lcd_tek_data('k');
  lcd_tek_data('l');
  lcd_tek_data('a');
  lcd_tek_data('w');
  lcd_tek_data('_');
  lcd_tek_data('S');
  lcd_tek_data('R');
  lcd_tek_data('A');
  lcd_tek_data('M');

    //начало основного цикла
    for (;;)
    {

    // если принят байт из PC-клавиатуры, то обработать его прием
    if  (flag_rd_kb==1)
           {
           flag_rd_kb = 0; // сбросить флаг "принят байт из лавиатуры"

           lcd_pro_data(DATA_KB,J); //индицировать принятый байт

           J++;
           if (J == 16) J = 64;
           if (J == 80)
              {
              J = 0;
              lcd_clear();  //очистка экрана ЖКИ
              }

          //клавиши  3  4  PC-клавиатуры
          if (DATA_KB == 0x26) AT91F_PIO_ClearOutput( AT91C_BASE_PIOA, LED4); // зажечь сетодиод 4
          if (DATA_KB == 0x25)   AT91F_PIO_SetOutput( AT91C_BASE_PIOA, LED4); // погасить светодиод 4
          //клавиши  5  6  PC-клавиатуры
          if (DATA_KB == 0x2E) AT91F_PIO_ClearOutput( AT91C_BASE_PIOA, LED3); // зажечь сетодиод 3
          if (DATA_KB == 0x36)   AT91F_PIO_SetOutput( AT91C_BASE_PIOA, LED3); // погасить светодиод 3
          //клавиши  7  8  PC-клавиатуры
          if (DATA_KB == 0x3D) AT91F_PIO_ClearOutput( AT91C_BASE_PIOA, LED2); // зажечь сетодиод 2
          if (DATA_KB == 0x3E)   AT91F_PIO_SetOutput( AT91C_BASE_PIOA, LED2); // погасить светодиод 2
          //клавиши  9  0  PC-клавиатуры
          if (DATA_KB == 0x46) AT91F_PIO_ClearOutput( AT91C_BASE_PIOA, LED1); // зажечь сетодиод 1
          if (DATA_KB == 0x45)   AT91F_PIO_SetOutput( AT91C_BASE_PIOA, LED1); // погасить светодиод 1
          DATA_KB = 0;
          }

      if  (flagn_kn1==1)    // нажималась ли кнопка 1
     	    {
            flagn_kn1=0;    //да, сбросить флаг нажатия
            AT91F_PIO_ClearOutput( AT91C_BASE_PIOA, LED4); // зажечь сетодиод 4
            }

     if  (flagn_kn2==1)    // нажималась ли кнопка 2
	    {
	    flagn_kn2=0;    //да, сбросить флаг нажатия
            AT91F_PIO_ClearOutput( AT91C_BASE_PIOA, LED3); // зажечь сетодиод 3
            }

     if  (flagn_kn3==1)    // нажималась ли кнопка 3
	    {
	    flagn_kn3=0;    //да, сбросить флаг нажатия
            AT91F_PIO_ClearOutput( AT91C_BASE_PIOA, LED2); // зажечь сетодиод 2
            }

     if  (flagn_kn4==1)    // нажималась ли кнопка 4
	    {
	    flagn_kn4=0;    //да, сбросить флаг нажатия
            AT91F_PIO_ClearOutput( AT91C_BASE_PIOA, LED1); // зажечь сетодиод 1
            }
    }
}




