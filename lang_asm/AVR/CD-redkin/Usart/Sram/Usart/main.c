//-------------------------------------------------------------------------
// Основная программа обслуживания USART
//-------------------------------------------------------------------------

#include "Board.h"
#include "usart.h"

//флаги нажатия кнопок
volatile extern U8 flagn_kn1, flagn_kn2, flagn_kn3, flagn_kn4;

static U8 led1_old_state=0;  //-----------------------------------
static U8 led2_old_state=0;  // переменные состояния светодиодов
static U8 led3_old_state=0;  //
static U8 led4_old_state=0;  //-----------------------------------

U8 ch0 = '!';     //переменная для операций с USART
char stroka[] = "ABCDEFGHIJKL"; //символьная строка для передачи в USART

//начало основной программы
void main(void)
{
  CPUinit();         //инициализация системы
  timer_init();      //инициализация таймеров-счетчиков
  LCDinit_clear();   //нач инициализация и сброс ЖКИ
  InitUSART0(115200);    //инициализация USART0 со скоростью обмена 115200 кбит/с

  // Вывод на ЖКИ начальной заставки
  lcd_pro_data('U', 0);
  lcd_tek_data('S');
  lcd_tek_data('A');
  lcd_tek_data('R');
  lcd_tek_data('T');
  lcd_tek_data('_');
  lcd_tek_data('S');
  lcd_tek_data('R');
  lcd_tek_data('A');
  lcd_tek_data('M');

    //начало основного цикла
    for (;;)
    {
      if  (flagn_kn1==1)    // нажималась ли кнопка 1
     	    {
            flagn_kn1=0;    //да, сбросить флаг нажатия

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
            //выбор значения для передачи в USART
            ch0++;
            if (ch0 == 'z')  ch0 = '!';
            lcd_pro_data(ch0, 64); //индикация символа, подлежащего передаче
            }

     if  (flagn_kn2==1)    // нажималась ли кнопка 2
	    {
	    flagn_kn2=0;    //да, сбросить флаг нажатия

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
            write_char_USART0(ch0); //передача символа через USART0
            lcd_pro_data(ch0, 66); //индикация переданного символа
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

             write_str_USART0(stroka); //передача в USART0 строки данных
            //индикация переданной строки
            U8 i = 0x0;
            while(stroka[i] != '\0')
                     {
                   lcd_pro_data(stroka[i], 68+i); //индикация переданного символа строки
                   i++;
                     }
            }

     if  (flagn_kn4==1)    // нажималась ли кнопка 4
	    {
	    flagn_kn4=0;    //да, сбросить флаг нажатия

           //смена состояния выхода светодиода LED4
           if (led4_old_state==OFF)
                     {
                     AT91F_PIO_ClearOutput( AT91C_BASE_PIOA, LED4); // зажечь сетодиод 4
                     led4_old_state=ON;
                     }
            else
                     {
                     AT91F_PIO_SetOutput( AT91C_BASE_PIOA, LED4); // погасить светодиод 4
                     led4_old_state=OFF;
                     }
            lcd_clear();          //очистка ЖКИ
            }
    }
}




