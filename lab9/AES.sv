/************************************************************************
AES Decryption Core Logic

Dong Kai Wang, Fall 2017

For use with ECE 385 Experiment 9
University of Illinois ECE Department
************************************************************************/

module AES (
	input  logic CLK,
	input  logic RESET,
	input  logic AES_START,
	output logic AES_DONE,
	input  logic [127:0] AES_KEY,
	input  logic [127:0] AES_MSG_ENC,
	output logic [127:0] AES_MSG_DEC
	);
	
	logic [1:0] mux_select;
	logic mux_en;

	
	
	ISDU statemachine(.Clk(CLK), .Reset(RESET), .AES_START, .AES_DONE, .mux_en, .mux_select, .stateNumber(), .Round());
	
	mux4 mux4Instance (.iark(), .isb(). imc(), .isr(), .s(mux_select), .o());
	
	
	
	
endmodule
