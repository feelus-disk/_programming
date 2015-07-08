//-------------------------------------------------------------------------------
// ПО обслуживания PIT
//-------------------------------------------------------------------------------

#include "Board.h"

#define PIT_INTERRUPT_LEVEL	1
#define PIV_PERIOD 		1000     	//период прерывания от PIT -
                                                // 0,3 мс для 48 МГц

static U8 U_NEG_old_state=0; //переменная сост выхода генерации отриц напр для LCD

//обработчик прерывания от PIT
void Periodic_Interval_Timer_handler(void)
{
    unsigned int status;
    //сброс прерывания от PIT
    status = AT91C_BASE_PITC->PITC_PIVR;
	status =status; //чтобы не генерировалось замечание о неиспольз переменной

    //* действия при прерывании
    opros_kn1(); // опрос кнопки 1
    opros_kn2(); // опрос кнопки 2
    opros_kn3(); // опрос кнопки 3
    opros_kn4(); // опрос кнопки 4

     //смена состояния выхода генерации отриц напр для LCD
            if (U_NEG_old_state==OFF)
                     {
                     AT91F_PIO_ClearOutput( AT91C_BASE_PIOA, U_NEG); // сброс U_NEG
                     U_NEG_old_state=ON;
                     }
            else
                     {
                     AT91F_PIO_SetOutput( AT91C_BASE_PIOA, U_NEG); // уст U_NEG
                     U_NEG_old_state=OFF;
                     }
}

//функция инициализации PIT
void PIT_init( void )
{
        //конфигурирование AIC
	AT91F_AIC_ConfigureIt ( AT91C_BASE_AIC, AT91C_ID_SYS, PIT_INTERRUPT_LEVEL,
                               AT91C_AIC_SRCTYPE_INT_POSITIVE_EDGE,
                               Periodic_Interval_Timer_handler);
	//разрешение PIT, разрешение прерывания от PIT с заданием его периода
	AT91C_BASE_PITC->PITC_PIMR = AT91C_PITC_PITEN | AT91C_PITC_PITIEN | PIV_PERIOD;
        AT91F_AIC_EnableIt (AT91C_BASE_AIC, AT91C_ID_SYS);
}
