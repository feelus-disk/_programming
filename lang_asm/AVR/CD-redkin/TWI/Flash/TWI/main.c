//-------------------------------------------------------------------------
// Основная программа обслуживания TWI
//-------------------------------------------------------------------------

#include "Board.h"
#include "twi.h"

//флаги нажатия кнопок
volatile extern U8 flagn_kn1, flagn_kn2, flagn_kn3, flagn_kn4;

//адрес ведомого устройства I2C
//0x57=0b1010111: тип устройства I2C - EEPROM (1010), адрес устр I2C на шине (111)
#define AT91C_EEPROM_I2C_ADDRESS  	(0x57<<16)

U16 int_addr_I2C = 0; //внутренний адрес ведомого устройства TWI

U16 I2C_addr_i; //внутренний адрес ведомого устройства TWI для индикации

char write_byte = 'A', read_byte = 0; //байты данных для записи и чтения TWI

//начало основной программы
void main(void)
{
  CPUinit();         //инициализация системы
  timer_init();      //инициализация таймеров-счетчиков
  AT91F_TWI_Open();  //инициализация TWI
  LCDinit_clear();   //нач инициализация и сброс ЖКИ

  // Вывод на ЖКИ начальной заставки
  lcd_pro_data('T', 0);
  lcd_tek_data('W');
  lcd_tek_data('I');
  lcd_tek_data('_');
  lcd_tek_data('F');
  lcd_tek_data('L');
  lcd_tek_data('A');
  lcd_tek_data('S');
  lcd_tek_data('H');

  lcd_pro_data(write_byte, 64); //индикация байта, подлежащего записи

  //преобразоание внутреннего адреса ведомого в дес вид и его индикация
            Preobr_ind_int_addr(int_addr_I2C);

  //произвести чтение из ведомого устройства TWI (2-байтовый внутр адрес)
            AT91F_TWI_ReadByte(AT91C_BASE_TWI, AT91C_EEPROM_I2C_ADDRESS |
                                        AT91C_TWI_IADRSZ_2_BYTE, int_addr_I2C, &read_byte, 1);

            lcd_pro_data(read_byte, 71); //индикация прочитанного байта

    //начало основного цикла
    for (;;)
    {

      if  (flagn_kn1==1)    // нажималась ли кнопка 1
     	    {
            flagn_kn1=0;    //да, сбросить флаг нажатия

            //выбор и индикация значения, подлежащего записи в ведомое устройство
            write_byte ++;
            if (write_byte == 'z')  write_byte = 'A';
            lcd_pro_data(write_byte, 64); //индикация байта, подлежащего записи
            }

     if  (flagn_kn2==1)    // нажималась ли кнопка 2
	    {
	    flagn_kn2=0;    //да, сбросить флаг нажатия
            //выбор и индикация внуреннего адреса ведомого устройства
            int_addr_I2C += 50;
            if (int_addr_I2C > 8150) int_addr_I2C = 0;

            //преобразоание внутреннего адреса ведомого в дес вид и его индикация
            Preobr_ind_int_addr(int_addr_I2C);

            //произвести чтение из ведомого устройства TWI (2-байтовый внутр адрес)
            AT91F_TWI_ReadByte(AT91C_BASE_TWI, AT91C_EEPROM_I2C_ADDRESS |
                                        AT91C_TWI_IADRSZ_2_BYTE, int_addr_I2C, &read_byte, 1);

            lcd_pro_data(read_byte, 71); //индикация прочитанного байта
            }

     if  (flagn_kn3==1)    // нажималась ли кнопка 3
	    {
	    flagn_kn3=0;    //да, сбросить флаг нажатия

            //произвести запись в ведомое устройство TWI (2-байтовый внутр адрес)
            AT91F_TWI_WriteByte(AT91C_BASE_TWI, AT91C_EEPROM_I2C_ADDRESS |
                                        AT91C_TWI_IADRSZ_2_BYTE, int_addr_I2C, &write_byte, 1);

            lcd_pro_data(write_byte, 76); //индикация записанного байта

            delay(800000);      //задержка на запись (не менее 5 мс)

            //произвести чтение из ведомого устройства TWI (2-байтовый внутр адрес)
            AT91F_TWI_ReadByte(AT91C_BASE_TWI, AT91C_EEPROM_I2C_ADDRESS |
                                        AT91C_TWI_IADRSZ_2_BYTE, int_addr_I2C, &read_byte, 1);

            lcd_pro_data(read_byte, 71); //индикация прочитанного байта
            }

     if  (flagn_kn4==1)    // нажималась ли кнопка 4
	    {
	    flagn_kn4=0;    //да, сбросить флаг нажатия

            //произвести чтение из ведомого устройства TWI (2-байтовый внутр адрес)
            AT91F_TWI_ReadByte(AT91C_BASE_TWI, AT91C_EEPROM_I2C_ADDRESS |
                                        AT91C_TWI_IADRSZ_2_BYTE, int_addr_I2C, &read_byte, 1);

            lcd_pro_data(read_byte, 71); //индикация прочитанного байта
            }
    }
}




