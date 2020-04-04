/************************************************************************
AES Decryption Core Logic

Dong Kai Wang, Fall 2017

For use with ECE 385 Experiment 9
University of Illinois ECE Department
************************************************************************/

module AES (
	input  logic [127:0] AES_KEY,
	input  logic [127:0] AES_MSG_ENC,
	output logic [127:0] AES_MSG_DEC,
	
	input logic    Clk,
						Reset,
						AES_START,
						Continue,

	output logic        AES_DONE, mux_en,
	output logic [1:0]  mux_select,
	output integer      stateNumber, Round, KeyClock);

	enum logic [2:0] {  Wait,
							Key_Expansion,
							IARK,
							ISR,
							ISB,
							IMC,
							Done
						 } State, Next_state; // internal state logic

						 
	always_ff @ (posedge Clk)
	begin
		if (Reset)
			State <= Wait;
		else
			State <= Next_state;
	end

	always_comb
	begin
		// default next state is staying at current state
		Next_state = State;
		stateNumber = 999;
		mux_en = 1'b0;

		// default controls signal values
		AES_DONE = 1'b0;
		mux_select =2'b0;

		// assign next state
		unique case (State) // state transtions
			Wait :
				if (AES_START)
					Next_state = Key_Expansion;
				
			Key_Expansion :
				if(KeyClock >0)
					Next_state = Key_Expansion;
				else
					Next_state =IARK;
			
			IARK :
				if(Round == 10)
					Next_state = ISR;
				else if(Round == -1)
					Next_state = Done;
				else
					Next_state = IMC;
				
			ISR :
				Next_state = ISB;
				
			ISB :
				Next_state = IARK;
				
			IMC :
				Next_state = ISR;
			
			Done:
				if(AES_START == 1'b0)
					Next_state = Wait;
				else
					Next_state = Done;

			default: ;
		endcase

		// assign control signals based on current state
		case (State)
			Wait: 
				begin
					AES_DONE = 1'b0;
					mux_select = 2'b0;
					Round = 10;
					stateNumber =0;
					KeyClock =5;
				end
			Key_Expansion: 
				begin
					mux_select = 2'b0;
					Round = 10;
					stateNumber =1;
					KeyClock = KeyClock -1;
				end
			
			IARK : 
				begin
					Round =Round -1;
					mux_select = 2'b00;
					mux_en =1'b1;
					
				end
			ISR : 
				begin
					mux_select = 2'b01;
					mux_en = 1'b1;
				end
			ISB : 
				begin
					mux_select = 2'b10;
					mux_en = 1'b1;
				end
			
			IMC:
				begin
					mux_select = 2'b11;
					mux_en = 1'b1;
				end
			
			Done :
				begin
					AES_DONE =1;
				end

				
			

			default: ;
		endcase
	end

endmodule
