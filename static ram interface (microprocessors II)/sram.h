//////// File header.h ////////
#include <reg52.h>

sbit Test_switch = P3^7;

sbit P00 = P0^0;
sbit P01 = P0^1;
sbit P02 = P0^2;
sbit P03 = P0^3;
sbit P04 = P0^4;
sbit P05 = P0^5;
sbit P06 = P0^6;
sbit P07 = P0^7;


sbit P20 = P2^0;
sbit P21 = P2^1;
sbit P22 = P2^2;
sbit P23 = P2^3;
sbit P24 = P2^4;
sbit P25 = P2^5;
sbit P26 = P2^6;
sbit P27 = P2^7;


sbit P10 = P1^0;
sbit P11 = P1^1;
sbit P12 = P1^2;
sbit P13 = P1^3;
sbit P14 = P1^4;
sbit P15 = P1^5;
sbit P16 = P1^6;
sbit P17 = P1^7;

char read_char(){
    // reads a character from the serial port
	char c;
	while(RI==0) ;
	c = SBUF;
	RI = 1;
	return c;
}

void delay()
{ 
	int x,y;
	for (x=0;x<=150;x++)
	  for(y = 0;y<=3000;y++);
}

void t_delay(int t)
{
	int n;
	for(n=0; n<t; n++) /* just loop */ ;
}

void PrintString(char* string)
{
    int i,j;
    int length;
    for(i = 0; string[i] != '\0'; ++i);
    length=i;
    for(j=0;j<length;j++){
            SendChar(string[j]);
        }
}

void SendChar(unsigned char ch)
{
    SBUF = ch;
    while(TI==0);
    TI = 0;
}

void SetupSerial()
{
/*------------------------------------------------
Setup the serial port for 9600 baud at 22.1184MHz.
------------------------------------------------*/
    SCON  = 0x50;		        /* SCON: mode 1, 8-bit UART, enable rcvr      */
    TMOD |= 0x20;               /* TMOD: timer 1, mode 2, 8-bit reload        */
    TH1   = 250;                /* TH1:  reload value for 9600 baud @ 22.1184MHz   */
    TR1   = 1;                  /* TR1:  timer 1 run                          */
    //TI    = 1;                /* TI:   hardware set when a char is sent     */
	//RI	= 1;				/* RI:   hardware set when a char is received    */
}
