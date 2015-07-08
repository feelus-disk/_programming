//-------------------------------------------------------------------------
// Основная программа обслуживания PWM
//-------------------------------------------------------------------------

#include "Board.h"
#include "lib_pwm.h"

static U16 PERIOD_SIZE = 10000;  //нач значение периода PWM
static U16 DUTY_SIZE = 2000; //нач значение длит импульса (рабочего цикла) PWM
static U8 DIVID = 48;      //нач значение делителя PWM

//флаги нажатия кнопок
volatile extern U8 flagn_kn1, flagn_kn2, flagn_kn3, flagn_kn4;

static U8 led1_old_state=0;  //-----------------------------------
static U8 led2_old_state=0;  // переменные состояния светодиодов
static U8 led3_old_state=0;  //
static U8 led4_old_state=0;  //-----------------------------------

//начало основной программы
void main(void)
{
  CPUinit();         //инициализация системы
  timer_init();      //инициализация таймеров-счетчиков
  AT91F_PWM_Open(MCK_toPWM, DIVID);   //инициализация PWM
  AT91F_Set_PWM_Channel0(PERIOD_SIZE, DUTY_SIZE); //настройка канала 0 PWM
  LCDinit_clear();   //нач инициализация и сброс ЖКИ
  Ind_DIVID(DIVID);//индикация значения делителя синхрочастоты PWM
  Ind_PERIOD(PERIOD_SIZE); //индикация значения периода PWM
  Ind_DUTY(DUTY_SIZE);   //индикация значения рабочего цикла PWM

  // Вывод на ЖКИ начальной заставки
  lcd_pro_data('P', 0);
  lcd_tek_data('W');
  lcd_tek_data('M');
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
                     AT91F_PIO_ClearOutput( AT91C_BASE_PIOA, LED1); // зажечь сетодиод 1
                     led1_old_state=ON;
                     }
            else
                     {
                     AT91F_PIO_SetOutput( AT91C_BASE_PIOA, LED1); // погасить светодиод 1
                     led1_old_state=OFF;
                     }
            DIVID = DIVID + 1;     //инкремент делителя синхрочастоты PWM
            if (DIVID == 255)  DIVID = 1;
            AT91F_PWM_Open(MCK_toPWM, DIVID);   //инициализация PWM
            AT91F_Set_PWM_Channel0(PERIOD_SIZE, DUTY_SIZE); //настройка канала 0 PWM
            Ind_DIVID(DIVID);//индикация значения делителя синхрочастоты PWM
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
            PERIOD_SIZE = PERIOD_SIZE + 1000;     //инкремент периода PWM
            if (PERIOD_SIZE > 65000)  PERIOD_SIZE = 1000;
            AT91F_Set_PWM_Channel0_period(PERIOD_SIZE); //корректная активация периода PWM
            Ind_PERIOD(PERIOD_SIZE); //индикация значения периода PWM
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
            DUTY_SIZE = DUTY_SIZE + 100;     //инкремент рабочего цикла PWM
            if (DUTY_SIZE > 20000)  DUTY_SIZE = 100;
            AT91F_Set_PWM_Channel0_duty(DUTY_SIZE); //корректная активация рабочего цикла PWM
            Ind_DUTY(DUTY_SIZE);   //индикация значения рабочего цикла PWM
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




