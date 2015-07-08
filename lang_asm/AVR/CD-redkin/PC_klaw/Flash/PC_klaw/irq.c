//-------------------------------------------------------------------------
// ПО обслуживания PC-клавиатуры с помощью внешнего прерывания
//-------------------------------------------------------------------------

#include "Board.h"

#define IRQ1_INTERRUPT_LEVEL	2

volatile U8 st_bit  = 0; //счетчик битов в принимаемом байте от PC-клавиатуры
static U8 DATA  = 0; //принимаемый байт из PC-клавиатуры
volatile U8 DATA_KB = 0; //принятый байт из PC-клавиатуры
volatile  U8 flag_rd_kb=0; // флаг "принят байт из PC-клавиатуры"
volatile extern U8 DEL_ST_KL; //делитель задания интервала сброса ошибки PC-клавиатуры

//Объвление входа внешнего прерывания IRQ1
#define IRQ_1 	(1<<30)	 // PA30  вход синхросигнала от PC-клавиатуры

//Объвление входа данных от PC-клавиатуры
#define IN_DATA_PC (1<<4)  // PA4  вход данных от PC-клавиатуры

// функция инициализации внешних прерываний IRQ для работы с PC-клавиатурой
void irq_pio_init ( void )
{
        // конфигурирование ножки внешнего прерывания IRQ
   	AT91F_PIO_CfgInput(AT91C_BASE_PIOA,IRQ_1);
        AT91F_PIO_CfgPeriph(AT91C_BASE_PIOA,IRQ_1,0);
   	// конфигурирование и разрешение внешнего прерывания IRQ1 по спаду
       AT91F_AIC_ConfigureIt (AT91C_BASE_AIC, AT91C_ID_IRQ1, IRQ1_INTERRUPT_LEVEL,
                              AT91C_AIC_SRCTYPE_EXT_NEGATIVE_EDGE,
                              at91_IRQ1_handler);
       AT91F_AIC_EnableIt (AT91C_BASE_AIC, AT91C_ID_IRQ1);

       //конфигурирование входа данных от PC-клавиатуры
       AT91F_PIO_CfgInput( AT91C_BASE_PIOA,IN_DATA_PC) ;
}


// функция-обработчик данных от PC-клавиатуры с помощью внешнего прерывания IRQ1
void at91_IRQ1_handler ( void )
{
  U32 dum=0;

  st_bit++; //инкремент счетчика битов

  if (st_bit == 11) //не закончен ли прием байта?
      {
       st_bit = 0; //сбросить счетчик битов
       flag_rd_kb=1; //уст флаг "принят байт из клавиатуры"
       DATA_KB = DATA; //копировать принятый байт в переменную хранения
       DEL_ST_KL = 0;//обнулить делитель задания интервала сброса ошибки
       goto  RET;
      }
  if (st_bit == 10)   goto  RET; //если это бит  четности, ничего не делать
  if (st_bit == 1)    goto  RET; //если это стартовый бит, ничего не делать

  //иначе, если это бит данных, обработать его
  if ((AT91F_PIO_GetInput(AT91C_BASE_PIOA) & IN_DATA_PC)==0)
    {  BIT_CLEAR(DATA,(st_bit-2)); }
  else   { BIT_SET(DATA,(st_bit-2));}

  RET:
  //разрешить следующее прерывание IRQ1
  dum =AT91C_BASE_PIOA->PIO_ISR;
  dum =dum; //чтобы не генерировалось замечание о неиспольз переменной
}
