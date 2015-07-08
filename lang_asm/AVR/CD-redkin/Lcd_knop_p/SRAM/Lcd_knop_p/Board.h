//----------------------------------------------------------------------------------
// Определения для отладочной платы
//----------------------------------------------------------------------------------
#ifndef Board_h
#define Board_h

#include "include/AT91SAM7S64.h"
#define __inline inline
#include "include/lib_AT91SAM7S64.h"

#define true	1
#define false	0
#define ON      1
#define OFF     0

//Определения типов величин
typedef unsigned int            U8;             /*  8 bit unsigned UPGRADE*/
typedef signed int              S8;             /*  8 bit signed   UPGRADE*/
typedef unsigned int            U16;            /* 16 bit unsigned */
typedef signed int              S16;            /* 16 bit signed */
typedef unsigned long int       U32;            /* 32 bit unsigned */
typedef signed long int         S32;            /* 32 bit signed */

//Макросы установки, сброса и тестирования бита
#define  BIT_SET(address,bit)     (address |= (1 << bit))
#define  BIT_CLEAR(address,bit)   (address &= ~(1 << bit))
#define  BIT_TEST(address,bit)    (address & (1 << bit))

// The AT91SAM7S64 embeds a 16-Kbyte SRAM bank, and 64 K-Byte Flash
#define  INT_SARM           0x00200000
#define  INT_SARM_REMAP	    0x00000000

#define  INT_FLASH          0x00000000
#define  INT_FLASH_REMAP    0x01000000

#define  FLASH_PAGE_NB		512
#define  FLASH_PAGE_SIZE	128

//0бъявления выходов светодиодов ---------------------------------------------------
/*                                 PIO   Flash    PA    PB   PIN */
#define LED1            (1<<0)	/* PA0 / PGMEN0 & PWM0 TIOA0  48 */
#define LED2            (1<<1)	/* PA1 / PGMEN1 & PWM1 TIOB0  47 */
#define LED3            (1<<2)	/* PA2          & PWM2 SCK0   44 */
#define LED4            (1<<3)	/* PA3          & TWD  NPCS3  43 */
#define NB_LEB			4
#define LED_MASK        (LED1|LED2|LED3|LED4)
//----------------------------------------------------------------------------------

//Объвление выхода генерации частоты формирования отрицательного напряжения для LCD
#define U_NEG 	(1<<30)	// PA30

//объявления, относящиеся к кнопкам ------------------------------------------------
/*                                 PIO    Flash    PA    PB   PIN */
#define SW1_MASK        (1<<19)	/* PA19 / PGMD7  & RK   FIQ     13 */
#define SW2_MASK        (1<<20)	/* PA20 / PGMD8  & RF   IRQ0    16 */
#define SW3_MASK        (1<<15)	/* PA15 / PGM3   & TF   TIOA1   20 */
#define SW4_MASK        (1<<14)	/* PA14 / PGMD2  & SPCK PWM3    21 */
#define SW_MASK         (SW1_MASK|SW2_MASK|SW3_MASK|SW4_MASK)
#define SW1 	(1<<19)	// PA19
#define SW2 	(1<<20)	// PA20
#define SW3 	(1<<15)	// PA15
#define SW4 	(1<<14)	// PA14

//объявление функций опроса кнопок
void opros_kn1(); // опрос кнопки 1
void opros_kn2(); // опрос кнопки 2
void opros_kn3(); // опрос кнопки 3
void opros_kn4(); // опрос кнопки 4

//константы подавления дребезга кнопок
#define  DREB_KN1_K   200
#define  DREB_KN2_K   200
#define  DREB_KN3_K   200
#define  DREB_KN4_K   200
//----------------------------------------------------------------------------------

//----------------------Объявления, относящиеся к системе --------------------------
//тактовые частоты
#define EXT_OC          18432000   // Exetrnal ocilator MAINCK
#define MCK             48054857   // MCK (PLLRC div by 2)
#define MCKKHz          (MCK/1000) //

//Объявление функции инициализации системы
void CPUinit();

// Объвление функции инициализации PIT
void PIT_init (void );
//----------------------------------------------------------------------------------

//----------------------Объявления, относящиеся к ЖКИ-------------------------------
//Макросы цепей ЖКИ
#define RW              (1<<7)	// PA7 - выв 1 XP9 "EXT3" - к выв 5 ЖКИ HD44780 WH1602
#define RS              (1<<8)	// PA8 - выв 2 XP9 "EXT3" - к выв 4 ЖКИ HD44780 WH1602
#define E               (1<<24)	// PA24 - выв 3 XP9 "EXT3" - к выв 6 ЖКИ HD44780 WH1602
#define DB4             (1<<23)	// PA23 - выв 4 XP9 "EXT3" - к выв 11 ЖКИ HD44780 WH1602
#define DB5             (1<<27)	// PA27 - выв 5 XP9 "EXT3" - к выв 12 ЖКИ HD44780 WH1602
#define DB6             (1<<28)	// PA28 - выв 6 XP9 "EXT3" - к выв 13 ЖКИ HD44780 WH1602
#define DB7             (1<<29)	// PA29 - выв 7 XP9 "EXT3" - к выв 14 ЖКИ HD44780 WH1602
//выв 9 XP9 "EXT3" (VCC) - к выв 2 (VCC) ЖКИ HD44780 WH1602
//выв 10 XP9 "EXT3" (GND) - к выв 1 (GND), 3 (VS) ЖКИ HD44780 WH1602

#define LCD_MASK        (RW|RS|E|DB4|DB5|DB6|DB7)
#define LCD_DMASK       (DB4|DB5|DB6|DB7)

//Объявление функции задержки для ожидания готовности ЖКИ
void  delay(U32); //для задержки 50 мкс при такт част 50 МГц  ticks=3000
                  //для задержки 1800 мкс при такт част 50 МГц  ticks=100000

//Объявление функции импульса стробирования записи/чтения ЖКИ
void lcd_pulse_E();

//Объявление функции передачи в ЖКИ байта
void lcd_send_byte(U8);

//Объявление функции записи в ЖКИ одного символа данных по
//произвольному адресу ОЗУ ЖКИ
void lcd_pro_data(U8, U8);

//Объявление функции записи в ЖКИ одного символа данных по
//текущему адресу ОЗУ ЖКИ
void lcd_tek_data(U8);

//Объявление функции записи в ЖКИ команды
void lcd_com(U8);

//Объявление функции инициализации ЖКИ
void lcd_init();

//Объявление функции очистки экрана ЖКИ
void lcd_clear();

//Объявление функции нач инициализации и сброса ЖКИ
void LCDinit_clear();

//Объявление функции опроса ЖКИ на предмет его готовности
//принимать команды и данные
void lcd_opros();

//Определения русских букв знакогенератора ЖКИ  HD44780
#define rus_b         0xB2  //  б
#define rus_v         0xB3  //  в
#define rus_g         0xB4  //  г
#define rus_d         0xE3  //  д
#define rus_eo        0xA2  //  e''
#define rus_j         0xB6  //  ж
#define rus_z         0xB7  //  з
#define rus_i         0xB8  //  и
#define rus_ik        0xB9  //  й
#define rus_k         0xBA  //  к
#define rus_l         0xBB  //  л
#define rus_m         0xBC  //  м
#define rus_n         0xBD  //  н
#define rus_p         0xBE  //  п
#define rus_t         0xBF  //  т
#define rus_f         0xE4  //  ф
#define rus_tz        0xE5  //  ц
#define rus_ch        0xC0  //  ч
#define rus_sch       0xC1  //  ш
#define rus_ssch      0xE6  //  щ
#define rus_m_zn      0xC4  //  ь
#define rus_t_zn      0xC2  //  ъ
#define rus_ii        0xC3  //  ы
#define rus_ei        0xC5  //  э
#define rus_ju        0xC6  //  ю
#define rus_ja        0xC7  //  я

#define rus_B         0xA0  //  Б
#define rus_G         0xA1  //  Г
#define rus_D         0xE0  //  Д
#define rus_J         0xA3  //  Ж
#define rus_Z         0xA4  //  З
#define rus_I         0xA5  //  И
#define rus_IK        0xA6  //  Й
#define rus_L         0xA7  //  Л
#define rus_P         0xA8  //  П
#define rus_U         0xA9  //  У
#define rus_F         0xAA  //  Ф
#define rus_TZ        0xE1  //  Ц
#define rus_CH        0xAB  //  Ч
#define rus_SCH       0xAC  //  Ш
#define rus_SSCH      0xE2  //  Щ
#define rus_T_ZN      0xAD  //  Ъ
#define rus_II        0xAE  //  Ы
#define rus_EI        0xAF  //  Э
#define rus_JU        0xB0  //  Ю
#define rus_JA        0xB1  //  Я
//-----------------------------------------------------------------------------------


#endif /* Board_h */
