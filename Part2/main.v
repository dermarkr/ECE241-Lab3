module main(SW, LEDR);

input [9:0] SW;
output [9:0] LEDR;

wire W1, W2, W3;

adder u0(.a(SW[4]), .b(SW[0]), .cIn(SW[8]), .s(LEDR[0]), .cOut(w1));
adder u1(.a(SW[5]), .b(SW[1]), .cIn(w1), .s(LEDR[1]), .cOut(w2));
adder u2(.a(SW[6]), .b(SW[2]), .cIn(w2), .s(LEDR[2]), .cOut(w3));
adder u3(.a(SW[7]), .b(SW[3]), .cIn(w3), .s(LEDR[3]), .cOut(LEDR[9]));

endmodule

module adder(a, b, cIn, s, cOut);

input a, b, cIn;
output s, cOut;

assign cOut = (a & b) | (cIn & a) | (cIn & b);
assign s = a ^ b ^ cIn;

endmodule

