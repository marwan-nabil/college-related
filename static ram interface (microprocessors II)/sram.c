#include <reg52.h>
#include "sram.h"

#DEFINE MEM_LENGTH 65535


void fill_memory();
void test_memory();

void main(void){
	SetupSerial();
    char inchar;
    PrintString("===== SRAM programmer =====\n");
	while(1){
        PrintString("\nplease enter (p) to fill memory, or (t) to test it\n");
        PrintString(">");
        inchar = read_char();
        case(inchar){
        'p':
            fill_memory();
            break;
        't':
            test_memory();
            break;
        default:
            PrintString("\nplease enter a valid command\n");
        }
	}
}

void fill_memory(){
    //fills even memory addresses with the byte 0X55 and odd addresses with the byte 0XAA
	xdata cp=0; // or something similar
		
	for(int i = 0; i <= MEM_LENGTH/2; i++)
		{
			*cp = 0x55;
			cp++;
			*cp = 0xAA;
			cp++;
		}
}

void test_memory(){
    //If all match, sends to the terminal the string “Verification with no errors” otherwise sends the string “Errors found”
	xdata cp=0; 
	char err_flag=0;
	
	for(int i = 0; i <= (MEM_LENGTH/2); i++)
		{
			if(*cp != 0x55) err_flag=1;
			cp++;
			if(*cp != 0xAA) err_flag=1;
			cp++;
		}
	if (err_flag == 0)
		printString("\nVerification with no errors\n");
	else
		printString("\nErrors found\n");
}
