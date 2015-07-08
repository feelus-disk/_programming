//-------------------------------------------------------------------------
// Основная программа    (AT91SAM7X128)
//-------------------------------------------------------------------------

#include "Board.h"

//флаги нажатия кнопок
volatile extern U8 flagn_kn1, flagn_kn2, flagn_kn3, flagn_kn4, flagn_kn5;

static U8 led1_old_state=0;  //-----------------------------------
static U8 led2_old_state=0;  // переменные состояния светодиодов
static U8 led3_old_state=0;  //
static U8 led4_old_state=0;  //-----------------------------------

//начало основной программы
void main(void)
{
  CPUinit();         //инициализация системы
  timer_init();      //инициализация таймеров-счетчиков
  LCDinit_clear();   //нач инициализация и сброс ЖКИ

  // Вывод на ЖКИ начальной заставки
  lcd_pro_data('L', 0);
  lcd_tek_data('c');
  lcd_tek_data('d');
  lcd_tek_data('_');
  lcd_tek_data('k');
  lcd_tek_data('n');
  lcd_tek_data('o');
  lcd_tek_data('p');
  lcd_tek_data('_');
  lcd_tek_data('X');
  lcd_tek_data('_');
  lcd_tek_data('F');
  lcd_tek_data('L');
  lcd_tek_data('A');
  lcd_tek_data('S');
  lcd_tek_data('H');

    //начало основного цикла
    for (;;)
    {
      if  (flagn_kn1==1)    // нажималась ли кнопка 1
     	    {
            flagn_kn1=0;    //да, сбросить флаг нажатия

            //смена состояния выхода светодиода LED1
            if (led1_old_state==OFF)
                     {
                     AT91F_PIO_ClearOutput( AT91C_BASE_PIOB, LED1); // зажечь сетодиод 1
                     led1_old_state=ON;
                     }
            else
                     {
                     AT91F_PIO_SetOutput( AT91C_BASE_PIOB, LED1); // погасить светодиод 1
                     led1_old_state=OFF;
                     }

            // Вывод на ЖКИ слова  "Privet!"
            lcd_pro_data('P',64);
            lcd_tek_data('r');
            lcd_tek_data('i');
            lcd_tek_data('v');
            lcd_tek_data('e');
            lcd_tek_data('t');
            lcd_tek_data('!');
            }

     if  (flagn_kn2==1)    // нажималась ли кнопка 2
	    {
	    flagn_kn2=0;    //да, сбросить флаг нажатия

           //смена состояния выхода светодиода LED2
           if (led2_old_state==OFF)
                     {
                     AT91F_PIO_ClearOutput( AT91C_BASE_PIOB, LED2); // зажечь сетодиод 2
                     led2_old_state=ON;
                     }
            else
                     {
                     AT91F_PIO_SetOutput( AT91C_BASE_PIOB, LED2); // погасить светодиод 2
                     led2_old_state=OFF;
                     }

           // Вывод на ЖКИ заставки - слова  "Привет!"
           lcd_pro_data(rus_P, 72);
           lcd_tek_data('p');
           lcd_tek_data(rus_i);
           lcd_tek_data(rus_v);
           lcd_tek_data('e');
           lcd_tek_data(rus_t);
           lcd_tek_data('!');
           }

     if  (flagn_kn3==1)    // нажималась ли кнопка 3
	    {
	    flagn_kn3=0;    //да, сбросить флаг нажатия

           //смена состояния выхода светодиода LED3
           if (led3_old_state==OFF)
                     {
                     AT91F_PIO_ClearOutput( AT91C_BASE_PIOB, LED3); // зажечь сетодиод 3
                     led3_old_state=ON;
                     }
            else
                     {
                     AT91F_PIO_SetOutput( AT91C_BASE_PIOB, LED3); // погасить светодиод 3
                     led3_old_state=OFF;
                     }

            lcd_clear();          //очистка ЖКИ
            }

     if  (flagn_kn4==1)    // нажималась ли кнопка 4
	    {
	    flagn_kn4=0;    //да, сбросить флаг нажатия

           //смена состояния выхода светодиода LED4
           if (led4_old_state==OFF)
                     {
                     AT91F_PIO_ClearOutput( AT91C_BASE_PIOB, LED4); // зажечь сетодиод 4
                     led4_old_state=ON;
                     }
            else
                     {
                     AT91F_PIO_SetOutput( AT91C_BASE_PIOB, LED4); // погасить светодиод 4
                     led4_old_state=OFF;
                     }
            // Вывод на ЖКИ слова  "Privet!"
            lcd_pro_data('P',72);
            lcd_tek_data('r');
            lcd_tek_data('i');
            lcd_tek_data('v');
            lcd_tek_data('e');
            lcd_tek_data('t');
            lcd_tek_data('!');
            }

       if  (flagn_kn5==1)    // нажималась ли кнопка 5
	    {
	    flagn_kn5=0;    //да, сбросить флаг нажатия

           //смена состояния выхода светодиода LED4
           if (led4_old_state==OFF)
                     {
                     AT91F_PIO_ClearOutput( AT91C_BASE_PIOB, LED4); // зажечь сетодиод 4
                     led4_old_state=ON;
                     }
            else
                     {
                     AT91F_PIO_SetOutput( AT91C_BASE_PIOB, LED4); // погасить светодиод 4
                     led4_old_state=OFF;
                     }
            lcd_init();           //инициализация ЖКИ
            }
      }
}




