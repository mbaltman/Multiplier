/************************************************************************
Lab 9 Nios Software

Dong Kai Wang, Fall 2017
Christine Chen, Fall 2013

For use with ECE 385 Experiment 9
University of Illinois ECE Department
************************************************************************/

#include <stdlib.h>
#include <stdio.h>
#include <time.h>
#include "aes.h"

// Pointer to base address of AES module, make sure it matches Qsys
volatile unsigned int * AES_PTR = (unsigned int *) 0x00000100;

// Execution mode: 0 for testing, 1 for benchmarking
int run_mode = 0;

/** charToHex
 *  Convert a single character to the 4-bit value it represents.
 *  
 *  Input: a character c (e.g. 'A')
 *  Output: converted 4-bit value (e.g. 0xA)
 */
char charToHex(char c)
{
	char hex = c;

	if (hex >= '0' && hex <= '9')
		hex -= '0';
	else if (hex >= 'A' && hex <= 'F')
	{
		hex -= 'A';
		hex += 10;
	}
	else if (hex >= 'a' && hex <= 'f')
	{
		hex -= 'a';
		hex += 10;
	}
	return hex;
}

/** charsToHex
 *  Convert two characters to byte value it represents.
 *  Inputs must be 0-9, A-F, or a-f.
 *  
 *  Input: two characters c1 and c2 (e.g. 'A' and '7')
 *  Output: converted byte value (e.g. 0xA7)
 */
char charsToHex(char c1, char c2)
{
	char hex1 = charToHex(c1);
	char hex2 = charToHex(c2);
	return (hex1 << 4) + hex2;
}

/** encrypt
 *  Perform AES encryption in software.
 *
 *  Input: msg_ascii - Pointer to 32x 8-bit char array that contains the input message in ASCII format
 *         key_ascii - Pointer to 32x 8-bit char array that contains the input key in ASCII format
 *  Output:  msg_enc - Pointer to 4x 32-bit int array that contains the encrypted message
 *               key - Pointer to 4x 32-bit int array that contains the input key
 */
void encrypt(unsigned char * msg_ascii, unsigned char * key_ascii, unsigned int * msg_enc, unsigned int * key)
{
	  
    char msg_hex[16];
    char key_hex[16];
    
    //convert msg_ascii characs to hex values
    for(int i =0; i<16; i ++)
    {   //gets bits 2 at a time
        char currM = charsToHex((char)msg_ascii[2* i], (char)msg_ascii[2* i +1]);
        char currK = charsToHex((char)key_ascii[2*i], (char)key_ascii[2*i +1]);
        
        msg_hex[i]= currM;
        key_hex[i]= currK;
    }
    
    char key_schedule[16*11] = keyExpansion(key_hex);
    
    msg_hex= addRoundKey(0,key_schedule, msg_hex);
    for(int round=1; round < 10; round++)
    {
        msg_hex = subBytes(msg_hex);
        msg_hex = ShiftRows(msg_hex);
        msg_hex = MixColumns(msg_hex);
        msg_hex = (round,key_schedule, msg_hex);
        
    }
    msg_hex = subBytes(msg_hex);
    msg_hex = ShiftRows(msg_hex);
    msg_hex = (10,key_schedule, msg_hex);
    
    int msg_int[4];
    int key_int[4];
    

}

char* addRoundKey(int currRound, char * key_schedule, char * state)
{
    char returnVal[16];
    for(int i =0; i<16; i++ )
    {
        returnVal[i]= state[i] ^ key_scheuld(currRound* 16 +i);
    }
    return returnVal;
    
}
/*
keyE
*/
char* keyExpanasion(char* key)
{
    char lastXbits
    unsigned  mask;
    mask = (1 << 8) - 1;
    
    
    
    char key_schedule[16*11];
    
    char temp0;//stores one column at a time
    char temp1;
    char temp2;
    char temp3;
    //store first key
    
    //sets up columns 0-3
    for(int i =0; i < 16, i++)
    {
        key_schedule[i]= key[i];
    }
    
    
    int i =4;
    
    while(i< (16*11))
    {
        
       //look at the previous column 
         temp1 = key_schedule[0+(i*3)];
         temp2 = key_schedule[1+(i*3)];
         temp3 = key_schedule[2+(i*3)];
         temp4 = key_schedule[3+(i*3)];
        
         if(i % 4 ==0)
         {
             unsigned int curr = Rcon[i/4]
                curr = curr<<24;
             lastXbits =  curr & mask;
             temp1 = subWord(temp2) ^ lastXbits;
             temp2 = subWord(temp3);
             temp3 = subWord(temp4); 
             temp4 = subWord(temp1);
             
         }
        key_schedule[0+(i*4)]= key_schedule[0 + (i-4)*4] ^ temp1;
        key_schedule[1+(i*4)]= key_schedule[0 + (i-4)*4] ^ temp2;
        key_schedule[2+(i*4)]= key_schedule[0 + (i-4)*4] ^ temp3;
        key_schedule[3+(i*4)]= key_schedule[0 + (i-4)*4] ^ temp4;          
    }
    
    return key_schedule;
    
}

char * subBytes(char * state)
{
    for(int i =0; i<16;i++)
    {
        state[i] = subWord(state[i]);
    }
    
    return state[i];
}

char subWord(char currChar)
{
    int firstNumber;
    int secondNumber;
    
    if((INPUT >> 7) & 1==1)
    {
        firstNumber = firstNumber+8;
    }
    if((INPUT >> 6) & 1==1)
    {
        firstNumber = firstNumber+4;
    }
    if((INPUT >> 5) & 1==1)
    {
        firstNumber = firstNumber+2;
    }
    if((INPUT >> 4) & 1==1)
    {
        firstNumber = firstNumber+1;
    }
    
    if((INPUT >> 3) & 1==1)
    {
        secondNumber = secondNumber+8;
    }
    if((INPUT >> 2) & 1==1)
    {
        secondNumber = secondNumber+4;
    }
    if((INPUT >> 1) & 1==1)
    {
        secondNumber = secondNumber+2;
    }
    if((INPUT >> 0) & 1==1)
    {
        secondNumber = secondNumber+1;
    }
    
    
    char curr=  aes_sbox[16*firstNumber + secondNumber];
       
    return curr;
}





/** decrypt
 *  Perform AES decryption in hardware.
 *
 *  Input:  msg_enc - Pointer to 4x 32-bit int array that contains the encrypted message
 *              key - Pointer to 4x 32-bit int array that contains the input key
 *  Output: msg_dec - Pointer to 4x 32-bit int array that contains the decrypted message
 */
void decrypt(unsigned int * msg_enc, unsigned int * msg_dec, unsigned int * key)
{
	// Implement this function
}

/** main
 *  Allows the user to enter the message, key, and select execution mode
 *
 */
int main()
{
	// Input Message and Key as 32x 8-bit ASCII Characters ([33] is for NULL terminator)
	unsigned char msg_ascii[33];
	unsigned char key_ascii[33];
	// Key, Encrypted Message, and Decrypted Message in 4x 32-bit Format to facilitate Read/Write to Hardware
	unsigned int key[4];
	unsigned int msg_enc[4];
	unsigned int msg_dec[4];

	printf("Select execution mode: 0 for testing, 1 for benchmarking: ");
	scanf("%d", &run_mode);
    int flag =1;
	if (run_mode == 0) {
		// Continuously Perform Encryption and Decryption
		while (flag) {
			int i = 0;
			printf("\nEnter Message:\n");
			scanf("%s", msg_ascii);
			printf("\n");
			printf("\nEnter Key:\n");
			scanf("%s", key_ascii);
			printf("\n");
			encrypt(msg_ascii, key_ascii, msg_enc, key);
			printf("\nEncrpted message is: \n");
			for(i = 0; i < 4; i++){
				printf("%08x", msg_enc[i]);
			}
			printf("\n");
			decrypt(msg_enc, msg_dec, key);
			printf("\nDecrypted message is: \n");
			for(i = 0; i < 4; i++){
				printf("%08x", msg_dec[i]);
			}
			printf("\n");
            flag =0;
		}
	}
	else {
		// Run the Benchmark
		int i = 0;
		int size_KB = 2;
		// Choose a random Plaintext and Key
		for (i = 0; i < 32; i++) {
			msg_ascii[i] = 'a';
			key_ascii[i] = 'b';
		}
		// Run Encryption
		clock_t begin = clock();
		for (i = 0; i < size_KB * 64; i++)
			encrypt(msg_ascii, key_ascii, msg_enc, key);
		clock_t end = clock();
		double time_spent = (double)(end - begin) / CLOCKS_PER_SEC;
		double speed = size_KB / time_spent;
		printf("Software Encryption Speed: %f KB/s \n", speed);
		// Run Decryption
		begin = clock();
		for (i = 0; i < size_KB * 64; i++)
			decrypt(msg_enc, msg_dec, key);
		end = clock();
		time_spent = (double)(end - begin) / CLOCKS_PER_SEC;
		speed = size_KB / time_spent;
		printf("Hardware Encryption Speed: %f KB/s \n", speed);
	}
	return 0;
}


