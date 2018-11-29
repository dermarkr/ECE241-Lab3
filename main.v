module part1(SW, LEDR);

    input [9:0] SW;
	 output [9:0] LEDR;
	 
	 
    mux7to1 u0(.muxSelect(SW[9:7]), .in(SW[6:0]), .out(LEDR[0]));

endmodule

module mux7to1(muxSelect, in, out);

	input [2:0]muxSelect;
	input [6:0]in;
	output out;

	reg out;

	always@(*)
	
	begin
		case(muxSelect[2:0])
			3'b000: out = in[0];
			3'b001: out = in[1];
			3'b010: out = in[2];
			3'b011: out = in[3];
			3'b100: out = in[4];
			3'b101: out = in[5];
			3'b110: out = in[6];
			default: out = 0;
		endcase
	end
	
endmodule