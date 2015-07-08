//--------------------------------------------------------------------
// Заголовки к ПО обслуживания PWM
//--------------------------------------------------------------------

#include "Board.h"

// Константы задания тактирования  PWM
#define         MCK_toPWM     0
#define         MCK_2toPWM    1
#define         MCK_4toPWM    2
#define         MCK_8toPWM    3
#define         MCK_16toPWM   4
#define         MCK_32toPWM   5
#define         MCK_64toPWM   6
#define         MCK_128toPWM  7
#define         MCK_256toPWM  8
#define         MCK_512toPWM  9
#define         MCK_1024toPWM 10
#define         CLHAtoPWM     11
#define         CLHBtoPWM     12

// Константы настройки параметров импульсной последовательности PWM
#define         CALG_OFF       0    //выравнивание по левой границе
#define         CALG_ON       1<<8  //выравнивание по центру

#define         CPOL_OFF      0<<0  // старт с низкого уровня
#define         CPOL_ON       1<<9  // старт с высокого уровня

#define         CPD_ON        1<<10 // обновление периода
#define         CPD_OFF       0<<10 // обновление рабочего цикла

//Объявление функции инициализации PWM
void AT91F_PWM_Open(U8, U8);

//Объявление функции настройки канала 0 PWM
void AT91F_Set_PWM_Channel0(U16, U16);

//Объявление функции корректной активации периода канала 0 PWM
void AT91F_Set_PWM_Channel0_period(U16);

//Объявление функции корректной активации рабочего цикла канала 0 PWM
void AT91F_Set_PWM_Channel0_duty(U16);

//Объявление функции индикации значения делителя синхрочастоты PWM
void Ind_DIVID(U8);

//Объявление функции индикации значения периода PWM
void  Ind_PERIOD(U16);

//Объявление функции индикации значения рабочего цикла PWM
void  Ind_DUTY(U16);
//-------------------------------------------------------------------------

