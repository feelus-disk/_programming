//-------------------------------------------------------------------------
// Основная программа обслуживания таймера реального времени RTT
//-------------------------------------------------------------------------

#include "Board.h"
#include "rtt.h"

//флаги нажатия кнопок
volatile extern U8 flagn_kn1, flagn_kn2, flagn_kn3, flagn_kn4;

static U8 led1_old_state=0;  //-----------------------------------
static U8 led2_old_state=0;  // переменные состояния светодиодов
static U8 led3_old_state=0;  //
static U8 led4_old_state=0;  //------------------------------------

static U32 period_RTTC  = 1500; //нач значение периода предделителя таймера RTT

//начало основной программы
void main(void)
{
  CPUinit();         //инициализация системы
  timer_init();      //инициализация таймеров-счетчиков
  RTTC_init_res (period_RTTC);   //инициализация  и рестарт RTT
  LCDinit_clear();   //нач инициализация и сброс ЖКИ

  // Вывод на ЖКИ начальной заставки
  lcd_pro_data('R', 0);
  lcd_tek_data('T');
  lcd_tek_data('T');
  lcd_tek_data('_');
  lcd_tek_data('F');
  lcd_tek_data('L');
  lcd_tek_data('A');
  lcd_tek_data('S');
  lcd_tek_data('H');

  RTTC_Time_pres_ind (period_RTTC); //индикация текущего значения преддел таймера RTT

    //начало основного цикла
    for (;;)
    {
    delay(50000);
    RTTC_Time_ind (); //ндикация текущего значения таймера RTT


      if  (flagn_kn1==1)    // нажималась ли кнопка 1
     	    {
            flagn_kn1=0;    //да, сбросить флаг нажатия

            period_RTTC  = period_RTTC  + 1000;
            if (period_RTTC > 65000)   period_RTTC  = 1500;
            RTTC_Time_pres_ind (period_RTTC); //индикация текущего значения преддел таймера RTT
            RTTC_init (period_RTTC);   //инициализация  RTT

            //смена состояния выхода светодиода LED1
            if (led1_old_state==OFF)
                     {
                     AT91F_PIO_ClearOutput( AT91C_BASE_PIOA, LED1); // зажечь сетодиод 1
                     led1_old_state=ON;
                     }
            else
                     {
                     AT91F_PIO_SetOutput( AT91C_BASE_PIOA, LED1); // погасить светодиод 1
                     led1_old_state=OFF;
                     }
            }

     if  (flagn_kn2==1)    // нажималась ли кнопка 2
	    {
	    flagn_kn2=0;    //да, сбросить флаг нажатия

            period_RTTC  = period_RTTC  - 1000;
            if (period_RTTC < 1500)   period_RTTC  = 65000;
            RTTC_Time_pres_ind (period_RTTC); //индикация текущего значения преддел таймера RTT
            RTTC_init (period_RTTC);   //инициализация  RTT

           //смена состояния выхода светодиода LED2
           if (led2_old_state==OFF)
                     {
                     AT91F_PIO_ClearOutput( AT91C_BASE_PIOA, LED2); // зажечь сетодиод 2
                     led2_old_state=ON;
                     }
            else
                     {
                     AT91F_PIO_SetOutput( AT91C_BASE_PIOA, LED2); // погасить светодиод 2
                     led2_old_state=OFF;
                     }
           }

     if  (flagn_kn3==1)    // нажималась ли кнопка 3
	    {
	    flagn_kn3=0;    //да, сбросить флаг нажатия

           //смена состояния выхода светодиода LED3
           if (led3_old_state==OFF)
                     {
                     AT91F_PIO_ClearOutput( AT91C_BASE_PIOA, LED3); // зажечь сетодиод 3
                     led3_old_state=ON;
                     }
            else
                     {
                     AT91F_PIO_SetOutput( AT91C_BASE_PIOA, LED3); // погасить светодиод 3
                     led3_old_state=OFF;
                     }

            period_RTTC = 0x8000;
            RTTC_init (period_RTTC);   //инициализация  RTT значением, соотв периоду 1 Гц
            RTTC_Time_pres_ind (period_RTTC); //индикация текущего значения преддел таймера RTT
            }

     if  (flagn_kn4==1)    // нажималась ли кнопка 4
	    {
	    flagn_kn4=0;    //да, сбросить флаг нажатия

            //смена состояния выхода светодиода LED4
           if (led4_old_state==OFF)
                     {
                     AT91F_PIO_ClearOutput( AT91C_BASE_PIOA, LED4); // зажечь сетодиод 3
                     led4_old_state=ON;
                     }
            else
                     {
                     AT91F_PIO_SetOutput( AT91C_BASE_PIOA, LED4); // погасить светодиод 3
                     led4_old_state=OFF;
                     }

            period_RTTC = 0x8000;
            RTTC_init_res (period_RTTC);   //инициализация  и рестарт RTT
                                      //значением, соотв периоду 1 Гц
            RTTC_Time_pres_ind (period_RTTC); //индикация текущего значения преддел таймера RTT
            }
    }
}




