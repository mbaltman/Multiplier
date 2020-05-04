module GameLogic(input logic Clk, Reset,
					  input logic [7:0] keycode,
					  input logic hitbottom,
					  output logic [15:0] blockstate_new, blockstate_hold,
					  output logic [5:0] spriteindex,
					  output logic resetBlocks, Pause);
					  
enum logic [4:0] { Wait, Drop, Falling, Hold1 , Bottom, PauseState1, PauseState2 } 
						State, Next_state;
						
logic canHold, canHold_in, resetPiece;
logic [5:0] spriteindex_in, spriteindex_hold, spriteindex_pick, spriteindex_hold_in;
logic [15:0] blockstate_in, blockstate_pick, blockstate_hold_in;
			
newPiece newPiecePicker(.pickPiece(resetPiece), .Clk(Clk), .blockstate_new(blockstate_pick), .spriteindex_new(spriteindex_pick));
			
	always_ff @ (posedge Clk)
	begin
		if (Reset)
			State <= Wait;
		else
		begin
			State <= Next_state;
			canHold <= canHold_in;
			spriteindex <= spriteindex_in;
			blockstate_new <= blockstate_in;
			
			blockstate_hold <= blockstate_hold_in;
			spriteindex_hold <= spriteindex_hold_in;
		end
	end

	always_comb
	begin
		Next_state = State;
		canHold_in =canHold;
		spriteindex_in = spriteindex;
		blockstate_in = blockstate_new;
		blockstate_hold_in = blockstate_hold;
		spriteindex_hold_in = spriteindex_hold;
		
		resetBlocks = 1'b0;
		resetPiece = 1'b0;
		Pause =1'b0;
		
		unique case(State)
			Wait :
				if(keycode == 8'h2C)//space key pressed
					Next_state = Drop;
			Drop:
				Next_state = Falling;
			
			Falling:
				begin
					if(hitbottom) //if you hit the bottom
						Next_state = Bottom;
						
					/*else if(keycode == 8'h13) //if pause is pressed
						Next_state = PauseState;
						
					else if(keycode == 8'h2b & canHold)//if you hit the tab button
						Next_state = Hold1;
						*/
						
					else if(keycode == 8'h29) //if you press esc reset the game
						Next_state = Wait;
						
					else
						Next_state = Falling;
				end
				
		/*	Hold1:
				Next_state = Drop;
			*/
			
			Bottom:
				Next_state = PauseState1;
				
			PauseState1://first half of pause if you just hold P you stay in this state
				if(keycode != 8'h13)
					Next_state = PauseState2;
				else
					Next_state = PauseState1;
					
			PauseState2://move to this state once you let go of P, if you press it you go back to falling 
				if(keycode == 8'h13)
					Next_state = Drop;
				else
					Next_state = PauseState2;
			
		
		endcase
		
		
		case(State)
			Wait:
			begin
				resetPiece = 1'b1;
				Pause = 1'b1;
			end
			
			Drop:
			begin
				resetPiece = 1'b1;
				blockstate_in = blockstate_pick;
		      spriteindex_in = spriteindex_pick;
				resetBlocks = 1'b1;

			end
			Falling:
		
			Hold:
				begin
					blockstate_hold_in = blockstate_new;
					/*resetPiece = 1'b1;
					blockstate_in = blockstate_pick;
					spriteindex_hold_in = spriteindex;
					spriteindex_in = spriteindex_pick;
					canHold_in = 1'b0;*/
				end
		
			Bottom:
				canHold_in = 1'b1;
		
			PauseState1, PauseState2:
				Pause = 1'b1;
			
			endcase
	end
endmodule
