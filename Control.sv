module control(input logic Clk, Reset, Run, clra_ldb,
					input logic[1:0] bctrl,
					output logic OutCleara, OutLoadb, OutShift,OutAdd,OutSub);
	//these are the states
		enum logic [4:0] 	{Start, Clear,Halt,ClearLoad,
							Add1, Add2, Add3, Add4,Add5,Add6,Add7,Sub8,
							Shift1, Shift2, Shift3, Shift4, Shift5,Shift6,Shift7,Shift8}
							curr_state, next_state;
							
	//updates flip flop, Current state is the only one
	always_ff @ (posedge Clk)  
    begin
        if (Reset)
            curr_state <= Start;
        else 
            curr_state <= next_state;
    end
	 
	 always_comb
	 begin
		next_state  = curr_state;
		
		unique case(curr_state)
			
			Start: if(Run)
							next_state = Clear;
					 else if(clra_ldb)
							next_state = ClearLoad;
							
			ClearLoad:  next_state = Start;
			
			Clear: if(bctrl[0])
							next_state = Add1;
					 else
							next_state = Shift1;		
							
			Add1: next_state= Shift1;
			
			Shift1: if(bctrl[1])
							next_state = Add2;
							
					  else
							next_state = Shift2;
							
			Add2: next_state = Shift2;
			
			Shift2: if(bctrl[1])
							next_state = Add3;
					  else
							next_state = Shift3;
			Add3: next_state = Shift3;
			
			Shift3: if(bctrl[1])
							next_state = Add4;
					  else
							next_state = Shift4;
			Add4: next_state = Shift4;
			
			Shift4: if(bctrl[1])
							next_state = Add5;
					  else
							next_state = Shift5;
			Add5: next_state = Shift5;
			
			Shift5: if(bctrl[1])
							next_state = Add6;
					  else
							next_state = Shift6;
			Add6: next_state = Shift6;
			
			Shift6: if(bctrl[1])
							next_state = Add7;
					  else
							next_state = Shift7;
			
			Add7: next_state = Shift7;
			
			
			Shift7: if(bctrl[1])
							next_state = Sub8;
					  else 
							next_state = Shift8;
			Sub8: next_state = Shift8;
			Shift8: next_state = Halt;
			Halt: if(~Run)
						next_state = Start;
		endcase
		
		case(curr_state)
			Start,Halt:
			begin
				 OutCleara = 1'b0;
				 OutLoadb = 1'b0;
				 OutShift= 1'b0;
				 OutAdd = 1'b0;
				 OutSub = 1'b0;
			end
			Clear:
			begin
				 OutCleara = 1'b1;
				 OutLoadb = 1'b0;
				 OutShift= 1'b0;
				 OutAdd = 1'b0;
				 OutSub = 1'b0;
			end
			ClearLoad:
			begin
				 OutCleara = 1'b1;
				 OutLoadb = 1'b1;
				 OutShift= 1'b0;
				 OutAdd = 1'b0;
				 OutSub = 1'b0;
			end
			
			Add1, Add2, Add3, Add4, Add5, Add6, Add7 :
			begin
				 OutCleara = 1'b0;
				 OutLoadb = 1'b0;
				 OutShift= 1'b0;
				 OutAdd = 1'b1;
				 OutSub = 1'b0;
			end
			Shift1, Shift2, Shift3, Shift4, Shift5, Shift6, Shift7, Shift8:
			begin
				 OutCleara = 1'b0;
				 OutLoadb = 1'b0;
				 OutShift= 1'b1;
				 OutAdd = 1'b0;
				 OutSub = 1'b0;
			end
			Sub8:
			begin
				 OutCleara = 1'b0;
				 OutLoadb = 1'b0;
				 OutShift= 1'b0;
				 OutAdd = 1'b0;
				 OutSub = 1'b1;
			end
		
			
		endcase
	 end
				
endmodule
