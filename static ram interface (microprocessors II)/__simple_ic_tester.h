
#define UNKNOWN 0	
#define AND 1	
#define OR 2	
#define NAND 3
#define NOT 4	

// truth tables
char and_table[4]={0,0,0,1};
char or_table[4]={0,1,1,1};
char nand_table[4]={1,1,1,0}; 
char not_table[2]={0,0,1,1};
char type,IC_fault;
///////////////////////////////////////////////////////////////////////////////////////////////////////////////
void PrintString(char* string)
{
int i,j;
int length;

	for(i = 0; string[i] != '\0'; ++i);
length=i;
for(j=0;j<length;j++)
	{
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
    SCON  = 0x50;		        		/* SCON: mode 1, 8-bit UART, enable rcvr      */
    TMOD |= 0x20;               /* TMOD: timer 1, mode 2, 8-bit reload        */
    TH1   = 250;                /* TH1:  reload value for 9600 baud @ 22.1184MHz   */
    TR1   = 1;                  /* TR1:  timer 1 run                          */
    //TI    = 1;                  /* TI:   set TI to send first char of UART    */
	
}

int test_single_gate(char* G,char* table){
	int i;
	for(i=1;i<=4;i++)
		{	if(G[i]!=table[i])
			{
				return 1
			};	
		};
		return 0
};



////////////////////////////////////////////////////////////////////////////////////////////// TEST functions ///////////////////////////////
int test_and(){
	

	// testing IC and obtaining results vectors
	P1=0b00000000;
	char res1[4]={P20,P21,P22,P23};
	P1=0b01010101;
	char res2[4]={P20,P21,P22,P23};
	P1=0b10101010;
	char res3[4]={P20,P21,P22,P23};
	P1=0b11111111;
	char res4[4]={P20,P21,P22,P23};
	
	// generating gates results vectors from case results vectors
	char G1[4]={res1[1],res2[1],res3[1],res4[1]};
	char G2[4]={res1[2],res2[2],res3[2],res4[2]};
	char G3[4]={res1[3],res2[3],res3[3],res4[3]};
	char G4[4]={res1[4],res2[4],res3[4],res4[4]};		
	
	char gate_results[4][4]={G1,G2,G3,G4};
	
	IC_fault=0;
	type=UNKNOWN;
 	
	///////////////////////////
	if(!test_single_gate(G1,and_table))
	{
		type=AND;
		for(int i=2;i<=4;i++)
		{
			if(test_single_gate(gate_results(i),and_table))
			{ 
				IC_fault=1;
				break	
			}
		}
	}
		else if(!test_single_gate(G2,and_table))
	{
		type=AND;
		IC_fault=1;
	}
		else if(!test_single_gate(G3,and_table))
	{
		type=AND;
		IC_fault=1;
	}
	else if(!test_single_gate(G4,and_table))
	{
		type=AND;
		IC_fault=1;
	}
	else
		{
			type=UNKNOWN;
			IC_fault=0;
		}
		
	////////////////////////////////
if (type==AND)
	{
		if(IC_fault)
		{
			PrintString("defective 7408");
		}
		else
			PrintString("7408");
	return 1
	}
	else 
		return 0		
}

int test_or(){
	

	// testing IC and obtaining results vectors
	P1=0b00000000;
	char res1[4]={P20,P21,P22,P23};
	P1=0b01010101;
	char res2[4]={P20,P21,P22,P23};
	P1=0b10101010;
	char res3[4]={P20,P21,P22,P23};
	P1=0b11111111;
	char res4[4]={P20,P21,P22,P23};
	
	// generating gates results vectors from case results vectors
	char G1[4]={res1[1],res2[1],res3[1],res4[1]};
	char G2[4]={res1[2],res2[2],res3[2],res4[2]};
	char G3[4]={res1[3],res2[3],res3[3],res4[3]};
	char G4[4]={res1[4],res2[4],res3[4],res4[4]};		
	
	char gate_results[4][4]={G1,G2,G3,G4};
	
	IC_fault=0;
	type=UNKNOWN;
 	
	///////////////////////////
	if(!test_single_gate(G1,or_table))
	{
		type=OR;
		for(int i=2;i<=4;i++)
		{
			if(test_single_gate(gate_results(i),or_table))
			{ 
				IC_fault=1;
				break	
			}
		}
	}
		else if(!test_single_gate(G2,or_table))
	{
		type=OR;
		IC_fault=1;
	}
		else if(!test_single_gate(G3,or_table))
	{
		type=OR;
		IC_fault=1;
	}
	else if(!test_single_gate(G4,or_table))
	{
		type=OR;
		IC_fault=1;
	}
	else
		{
			type=UNKNOWN;
			IC_fault=0;
		}
		
	////////////////////////////////
if (type==OR)
	{
		if(IC_fault)
		{
			PrintString("defective 7432");
		}
		else
			PrintString("7432");
	return 1
	}
	else 
		return 0		
}



int test_nand(){
	

	// testing IC and obtaining results vectors
	P1=0b00000000;
	char res1[4]={P20,P21,P22,P23};
	P1=0b01010101;
	char res2[4]={P20,P21,P22,P23};
	P1=0b10101010;
	char res3[4]={P20,P21,P22,P23};
	P1=0b11111111;
	char res4[4]={P20,P21,P22,P23};
	
	// generating gates results vectors from case results vectors
	char G1[4]={res1[1],res2[1],res3[1],res4[1]};
	char G2[4]={res1[2],res2[2],res3[2],res4[2]};
	char G3[4]={res1[3],res2[3],res3[3],res4[3]};
	char G4[4]={res1[4],res2[4],res3[4],res4[4]};		
	
	char gate_results[4][4]={G1,G2,G3,G4};
	
	IC_fault=0;
	type=UNKNOWN;
 	
	///////////////////////////
	if(!test_single_gate(G1,nand_table))
	{
		type=NAND;
		for(int i=2;i<=4;i++)
		{
			if(test_single_gate(gate_results(i),nand_table))
			{ 
				IC_fault=1;
				break	
			}
		}
	}
		else if(!test_single_gate(G2,nand_table))
	{
		type=NAND;
		IC_fault=1;
	}
		else if(!test_single_gate(G3,nand_table))
	{
		type=NAND;
		IC_fault=1;
	}
	else if(!test_single_gate(G4,nand_table))
	{
		type=NAND;
		IC_fault=1;
	}
	else
		{
			type=UNKNOWN;
			IC_fault=0;
		}
		
	////////////////////////////////
if (type==NAND)
	{
		if(IC_fault)
		{
			PrintString("defective 7400");
		}
		else
			PrintString("7400");
	return 1
	}
	else 
		return 0		
}/
int test_not() { 
	
			P10 = 0;
			P14 = 0;
	
	if (P11 = 1 | P15 = 1  ){
		  type = NOT ;
		  P10 = 0 ;
	    P14 = 0 ;
	   	P20 = 0 ;
	   	P13 = 0 ;
		  P22 = 0 ;
		  P17 = 0 ;
		
			if(P11 != 1 ||  P15 != 1 || P12 != 1 || P16 != 1 || P21 != 1 || P23 != 1 )
				{
					IC_fault =1 ;
				}
			else 
				{ 
					IC_fault = 0 ; 
				}
	}
if (type==NOT)
	{
		if(IC_fault)
		{
			PrintString("defective 7404");
		}
		else
			PrintString("7404");
	return 1
	}
	else 
		return 0			
}



////////////////////////////////////////////////////////////////////////////////////////////////



//if (type== UNKNOWN)
//	{
//			PrintString("unknown IC"); 
//		return 0	
//}/
