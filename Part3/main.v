module main(SW, KEY, LEDR, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5);

input [9:0] SW;
input [2:0] KEY;
output [9:0]LEDR;
output [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;

ALU a0(.select(KEY[2:0]),
			.a(SW[7:4]), 
			.b(SW[3:0]), 
			.ALUout(LEDR[7:0]), 
			.hex0(HEX0[6:0]), 
			.hex1(HEX1[6:0]), 
			.hex2(HEX2[6:0]), 
			.hex3(HEX3[6:0]),
			.hex4(HEX4[6:0]),
			.hex5(HEX5[6:0]));


endmodule


module ALU(select, a, b, ALUout, hex0, hex1, hex2, hex3, hex4, hex5);

input [2:0] select;
input [3:0] a;
input [3:0] b;
output reg [7:0] ALUout;
output [6:0] hex0, hex1,hex2, hex3, hex4, hex5;

wire [7:0] case0, case1, case2, case5, case6;
wire [3:0] Sum;
wire COUT;

reg [7:0] case3, case4;



rippleAdder u0( .aIn(a[3:0]), .bIn(b[3:0]), .s(Sum[3:0]), .cOut(COUT));


assign case1 = a+b;

assign case2[7:4] = ~(a | b);
assign case2[3:0] = ~(a & b);

always@(*)
begin
	if(a[3:0] | b[3:0])
		case3 = 8'b11000000;
	else
		case3 = 8'b00000000;
	
	
	if(((~a[3]&~a[2]&a[1]&a[0])
		|(~a[3]&a[2]&~a[1]&a[0])
		|(~a[3]&a[2]&a[1]&~a[0])
		|(a[3]&~a[2]&~a[1]&a[0])
		|(a[3]&~a[2]&a[1]&~a[0])
		|(a[3]&a[2]&~a[1]&~a[0]))
		&((~b[3]&b[2]&b[1]&b[0])
		|(b[3]&~b[2]&b[1]&b[0])
		|(b[3]&b[2]&~b[1]&b[0])
		|(b[3]&b[2]&b[1]&~b[0])))
		case4 = 8'b00111111;
	else
		case4 = 8'b00000000;

end

assign {case5[7:4]} = {b[3:0]};
assign {case5[3:0]} = ~{a[3:0]};

assign case6[7:4] = a ^ b;
assign case6[3:0] = a ~^ b;

always@(*)
	begin
		case(select[2:0])
			3'b000 : {ALUout[7:0]} = {{3{1'b0}}, COUT, Sum[3:0]};
			3'b001 : {ALUout[7:0]} = case1;
			3'b010 : {ALUout[7:0]} = case2;
			3'b011 : {ALUout[7:0]} = case3;
			3'b100 : {ALUout[7:0]} = case4;
			3'b101 : {ALUout[7:0]} = case5;
			3'b110 : {ALUout[7:0]} = case6;
			default: {ALUout[7:0]} = 'b00000000;
		endcase
	end

hexOut h0(.num(b[3:0]), .hex(hex0[6:0]));
hexOut h1(.num('b0000), .hex(hex1[6:0]));
hexOut h2(.num(a[3:0]), .hex(hex2[6:0]));
hexOut h3(.num('b0000), .hex(hex3[6:0]));
hexOut h4(.num(ALUout[3:0]), .hex(hex4[6:0]));
hexOut h5(.num(ALUout[7:4]), .hex(hex5[6:0]));
	
	
endmodule




module hexOut(num, hex);
input [3:0] num;
output reg [6:0] hex;

always@(*)
	begin
		case(num[3:0])
			4'b0000: {hex[6:0]} = 'b1000000; //0
			4'b0001: {hex[6:0]} = 'b1111001; //1
			4'b0010: {hex[6:0]} = 'b0100100; //2
			4'b0011: {hex[6:0]} = 'b0110000; //3
			4'b0100: {hex[6:0]} = 'b0011001; //4
			4'b0101: {hex[6:0]} = 'b0010010; //5
			4'b0110: {hex[6:0]} = 'b0000010; //6
			4'b0111: {hex[6:0]} = 'b1111000; //7
			4'b1000: {hex[6:0]} = 'b0000000; //8
			4'b1001: {hex[6:0]} = 'b0010000; //9
			4'b1010: {hex[6:0]} = 'b0001000; //A
			4'b1011: {hex[6:0]} = 'b0000011; //b
			4'b1100: {hex[6:0]} = 'b1000110; //C
			4'b1101: {hex[6:0]} = 'b0100001; //d
			4'b1110: {hex[6:0]} = 'b0000110; //E
			4'b1111: {hex[6:0]} = 'b0001110; //F
			default: {hex[6:0]} = 'b0000000; 
		endcase
	end
	
endmodule


module rippleAdder(aIn, bIn, s, cOut);

input [3:0] aIn;
input [3:0] bIn;
output [3:0] s;
output cOut;

wire w1, w2, w3;

adder u0(.A(aIn[0]), .B(bIn[0]), .cIn(0), .S(s[0]), .COut(w1));
adder u1(.A(aIn[1]), .B(bIn[1]), .cIn(w1), .S(s[1]), .COut(w2));
adder u2(.A(aIn[2]), .B(bIn[2]), .cIn(w2), .S(s[2]), .COut(w3));
adder u3(.A(aIn[3]), .B(bIn[3]), .cIn(w3), .S(s[3]), .COut(cOut));

endmodule

module adder(A, B, cIn, S, COut);

input A;
input B;
input cIn;
output S;
output COut;

assign COut = (A & B) | (cIn & A) | (cIn & B);
assign S = A ^ B ^ cIn;

endmodule
