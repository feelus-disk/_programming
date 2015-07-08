//------------------------------------------------------------------------
//ПО поддержки ЖКИ HD44780. Данные передаются в ЖКИ по 4-битной шине.
//Если ЖКИ опрашивается, то команды "lcd_opros();" надо раскомментировать,
//а команды "delay(3000);" и "delay(100000);" закомментировать, если ЖКИ
//не опрашивается, то наоборот.
//------------------------------------------------------------------------

#include "Board.h"

void delay(U32 ticks)   //задержка для ожидания готовности ЖКИ
  {
     for(; ticks; --ticks)
	    {
		asm ("nop");
	    }
  }

void lcd_pulse_E()  //импульс стробирования записи/чтения ЖКИ
  {
  delay(100);
  AT91F_PIO_SetOutput( AT91C_BASE_PIOA, E);  // фронт импульса E
  delay(100);
  AT91F_PIO_ClearOutput( AT91C_BASE_PIOA, E);  // спад импульса E
  delay(100);
  }

void lcd_send_byte(U8 byte) //передача в ЖКИ байта двумя тетрадами
  {
    if (BIT_TEST(byte,4))  AT91F_PIO_SetOutput( AT91C_BASE_PIOA, DB4); //---
    else   AT91F_PIO_ClearOutput( AT91C_BASE_PIOA, DB4);               //
    if (BIT_TEST(byte,5))  AT91F_PIO_SetOutput( AT91C_BASE_PIOA, DB5); //
    else   AT91F_PIO_ClearOutput( AT91C_BASE_PIOA, DB5);               //
    if (BIT_TEST(byte,6))  AT91F_PIO_SetOutput( AT91C_BASE_PIOA, DB6); // передача ст тетрады
    else   AT91F_PIO_ClearOutput( AT91C_BASE_PIOA, DB6);               //
    if (BIT_TEST(byte,7))  AT91F_PIO_SetOutput( AT91C_BASE_PIOA, DB7); //
    else   AT91F_PIO_ClearOutput( AT91C_BASE_PIOA, DB7);               //
  lcd_pulse_E();                                                       //---
    if (BIT_TEST(byte,0))  AT91F_PIO_SetOutput( AT91C_BASE_PIOA, DB4); //---
    else   AT91F_PIO_ClearOutput( AT91C_BASE_PIOA, DB4);               //
    if (BIT_TEST(byte,1))  AT91F_PIO_SetOutput( AT91C_BASE_PIOA, DB5); //
    else   AT91F_PIO_ClearOutput( AT91C_BASE_PIOA, DB5);               // передача мл тетрады
    if (BIT_TEST(byte,2))  AT91F_PIO_SetOutput( AT91C_BASE_PIOA, DB6); //
    else   AT91F_PIO_ClearOutput( AT91C_BASE_PIOA, DB6);               //
    if (BIT_TEST(byte,3))  AT91F_PIO_SetOutput( AT91C_BASE_PIOA, DB7); //
    else   AT91F_PIO_ClearOutput( AT91C_BASE_PIOA, DB7);               //
  lcd_pulse_E();                                                       //---
  }

// запись в ЖКИ одного символа данных по произвольному адресу ОЗУ ЖКИ
//если ЖКИ опрашивается, то команды "lcd_opros();" надо раскомментировать,
//а команды "delay(3000);" закомментировать, в противном случае - наоборот
void lcd_pro_data(U8 date, U8 addr)
  {
   AT91F_PIO_ClearOutput( AT91C_BASE_PIOA, RW);         //режим записи в ЖКИ
   AT91F_PIO_ClearOutput( AT91C_BASE_PIOA, RS);        //будет передаваться команда
   BIT_SET(addr,7);     //будет передаваться адрес ОЗУ ЖКИ
   lcd_send_byte(addr); //передача адреса
   delay(3000);         //задержка 50 мкс для готовности ЖКИ
   //lcd_opros(); //ожидание готовности ЖКИ
   AT91F_PIO_SetOutput( AT91C_BASE_PIOA, RS);          //будут передаваться данные
   if (date < 10)  lcd_send_byte(date + 0x30); //передается десятичн цифра
   else   lcd_send_byte(date);                //передается симв (не цифра)
   delay(3000);//задержка 50 мкс для готовности ЖКИ
   //lcd_opros(); //ожидание готовности ЖКИ
  }

// запись в ЖКИ одного символа данных по текущему адресу ОЗУ ЖКИ
//если ЖКИ опрашивается, то команду "lcd_opros();" надо раскомментировать,
//а команду "delay(3000);" закомментировать, в противном случае - наоборот
void lcd_tek_data(U8 date)
  {
   AT91F_PIO_ClearOutput( AT91C_BASE_PIOA, RW);       //режим записи в ЖКИ
   AT91F_PIO_SetOutput( AT91C_BASE_PIOA, RS);         //будут передаваться данные
   if (date < 10) lcd_send_byte(date + 0x30); //передается десятичн цифра
   else    lcd_send_byte(date);               //передается симв (не цифра)
   delay(3000);//задержка 50 мкс для готовности ЖКИ
   //lcd_opros(); //ожидание готовности ЖКИ
  }

void lcd_com(U8 comand) // запись в ЖКИ команды
//если ЖКИ опрашивается, то команду "lcd_opros();" надо раскомментировать,
//а команду "delay(100000);" закомментировать, в противном случае - наоборот
  {
   AT91F_PIO_ClearOutput( AT91C_BASE_PIOA, RW);  //режим записи в ЖКИ
   AT91F_PIO_ClearOutput( AT91C_BASE_PIOA, RS);  //будет передаваться команда
   lcd_send_byte(comand); //передача команды
   delay(100000); //задержка 2000 мкс для готовности ЖКИ
   //lcd_opros(); //ожидание готовности ЖКИ
  }

void lcd_init() // инициализация ЖКИ
  {
   lcd_com(0x28);   //4-х битная шина, 2 строки, символ 5х7
   lcd_com(0x01);   //очистка дисплея, курсор в нач положение
   lcd_com(0x06);   //дисплей не сдвигать, курсор сдвигать
   lcd_com(0x0C);   //включить дисплей,погасить  курсор
  }

void lcd_clear()  //очистка экрана ЖКИ
  {
   lcd_com(0x01);   //очистка дисплея, курсор в нач положение
  }

void LCDinit_clear() //начальная инициализация и сброс ЖКИ после вкл питания
  {
  U8 i = 20;
  delay(5000000);       //задержка на сброс ЖКИ
  for(; i; --i)
    {
      lcd_init();           // Инициализация ЖКИ
    delay(1000000);          //
    }
  lcd_clear();            //очистка ЖКИ
  delay(1000000);          //
  }

//Опрос ЖКИ на предмет его готовности принимать команды и данные
void lcd_opros()
  {
   AT91F_PIO_SetOutput( AT91C_BASE_PIOA, RW);         //режим чтения из ЖКИ
   AT91F_PIO_ClearOutput( AT91C_BASE_PIOA, RS);  //будет читаться команда
   // сделать шину даных ЖКИ входами
   AT91F_PIO_CfgInput( AT91C_BASE_PIOA, LCD_DMASK ) ;
  Opros:
   delay(100);       //
   AT91F_PIO_SetOutput( AT91C_BASE_PIOA, E);  // фронт импульса E
   delay(100);       //
  //(опрос флага BUSY) свободен ли ЖКИ ?
  if ( (AT91F_PIO_GetInput(AT91C_BASE_PIOA) & DB7) == 1)
     {
     delay(100); //
     AT91F_PIO_ClearOutput( AT91C_BASE_PIOA, E);  // спад импульса E
     delay(100); //
     lcd_pulse_E();  //импульс стробирования записи/чтения ЖКИ
     goto  Opros;  //
     }
  else
     {
     delay(100); //
     AT91F_PIO_ClearOutput( AT91C_BASE_PIOA, E);  // спад импульса E
     delay(100); //
     lcd_pulse_E();  //импульс стробирования записи/чтения ЖКИ
     }
   AT91F_PIO_ClearOutput( AT91C_BASE_PIOA, RW);  //режим записи в ЖКИ
   // сделать шину даных ЖКИ выходами
   AT91F_PIO_CfgOutput( AT91C_BASE_PIOA, LCD_DMASK ) ;
   delay(100);  //
   }












