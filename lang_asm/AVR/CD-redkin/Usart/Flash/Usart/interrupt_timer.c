//----------------------------------------------------------------------------
// ПО обслуживания таймеров-счетчиков
//----------------------------------------------------------------------------

#include "Board.h"

#define TIMER0_INTERRUPT_LEVEL		1
#define TIMER1_INTERRUPT_LEVEL		4

static U8 U_NEG_old_state=0; //переменная сост выхода генерации отриц напр для LCD

// выбор тактирования таймеров-счетчиков
#define TC_CLKS                  0x7 //внешний синхросигнал ТС
#define TC_CLKS_MCK2             0x0 //----------------------------------
#define TC_CLKS_MCK8             0x1 //
#define TC_CLKS_MCK32            0x2 //  внутренние синхросигналы ТС
#define TC_CLKS_MCK128           0x3 //
#define TC_CLKS_MCK1024          0x4 //----------------------------------

//Инициализация канала таймера-счетчика и разрешение тактирования
//Входные параметры     : <tc_pt> = указатель дескриптора канала
//                        <mode> = режим таймера счетчика
//                      : <TimerId> = определение идентификатора периферийного
//                      : устройства (таймера)
//Выходные параметры    : нет
void AT91F_TC_Open ( AT91PS_TC TC_pt, unsigned int Mode, unsigned int TimerId)
{
    unsigned int dummy;
    //разрешение тактирования таймера TIMER
    	AT91F_PMC_EnablePeriphClock ( AT91C_BASE_PMC, 1<< TimerId ) ;
    //отключение тактирования и прерываний
        TC_pt->TC_CCR = AT91C_TC_CLKDIS ;
	TC_pt->TC_IDR = 0xFFFFFFFF ;
    //очистка бита статуса
        dummy = TC_pt->TC_SR;
        dummy = dummy; //чтобы не генерировалось замечание о неиспольз переменной
    //задание режима таймера-счетчика
	TC_pt->TC_CMR = Mode ;
    //разрешение тактирования
	TC_pt->TC_CCR = AT91C_TC_CLKEN ;
}

// функция - обработчик прерывания от timer0
void timer0_c_irq_handler(void)
{
	AT91PS_TC TC_pt = AT91C_BASE_TC0;
    unsigned int dummy;
    //* определение состояния прерывания
    dummy = TC_pt->TC_SR;
    dummy = dummy; //чтобы не генерировалось замечание о неиспольз переменной

    //* действия при прерывании
    //
    //
}

// функция - обработчик прерывания от timer1
void timer1_c_irq_handler(void)
{
	AT91PS_TC TC_pt = AT91C_BASE_TC1;
    unsigned int dummy;
    //* определение состояния прерывания
    dummy = TC_pt->TC_SR;
    dummy = dummy; //чтобы не генерировалось замечание о неиспольз переменной

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

// функция инициализации таймеров-счетчиков
void timer_init ( void )
{
    // разрешение timer 0
     //	AT91F_TC_Open(AT91C_BASE_TC0,TC_CLKS_MCK1024,AT91C_ID_TC0);
    // разрешение прерываний от  Timer 0
     //	AT91F_AIC_ConfigureIt ( AT91C_BASE_AIC, AT91C_ID_TC0,
     // TIMER0_INTERRUPT_LEVEL,AT91C_AIC_SRCTYPE_INT_HIGH_LEVEL, timer0_c_irq_handler);
     //	AT91C_BASE_TC0->TC_IER = AT91C_TC_COVFS;  //  разрешение прерывания по переполнению
     //	AT91F_AIC_EnableIt (AT91C_BASE_AIC, AT91C_ID_TC0);
    // разрешение timer 1
	AT91F_TC_Open(AT91C_BASE_TC1,TC_CLKS_MCK2,AT91C_ID_TC1);
    // разрешение прерываний от  Timer 1
	AT91F_AIC_ConfigureIt ( AT91C_BASE_AIC, AT91C_ID_TC1,
        TIMER1_INTERRUPT_LEVEL,AT91C_AIC_SRCTYPE_INT_HIGH_LEVEL, timer1_c_irq_handler);
	AT91C_BASE_TC1->TC_IER  = AT91C_TC_CPCS;  //разрешение прерывания при совпадении с RC
	AT91F_AIC_EnableIt (AT91C_BASE_AIC, AT91C_ID_TC1);
        AT91C_BASE_TC1->TC_RC = 0x1000 ; // задание значения RC (определяет период прерываний)
        AT91C_BASE_TC1->TC_CMR  = AT91C_TC_CPCTRG ; //задание триггера при совпадении с RC
    // сброс и запуск timer0
      //  AT91C_BASE_TC0->TC_CCR = AT91C_TC_SWTRG ;
    // сброс и запуск timer1
        AT91C_BASE_TC1->TC_CCR = AT91C_TC_SWTRG ;
}
