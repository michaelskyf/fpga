/*module counter
(
    input clk,
    input btn1,
    input btn2,
    output [5:0] led
);

reg [5:0] ledCounter = 0;
reg [31:0] clockCounter = 0;
reg mode = 0;
wire btn_xor;
localparam WAIT_TIME = 27000000;

always_ff @(posedge btn_xor)
begin

	case({btn1, btn2})
		2'b01: mode <= 0;
		2'b10: mode <= 1;
	endcase

end

always_ff @(posedge clk)
begin
    clockCounter <= clockCounter + 1;
    if(WAIT_TIME == clockCounter)
    begin
        clockCounter <= 0;

		case(mode)
			1'b0: ledCounter <= ledCounter + 1;
			1'b1: ledCounter <= ledCounter - 1;
		endcase
    end

end

always_comb
begin
	led = ~ledCounter;
	btn_xor = btn1 ^ btn2;
end

endmodule*/

module counter
(
	input btn1,
	output [5:0] led
);

wire x1, x2, x3;

always_comb
begin
	led[0] = x1;
	x1 = ~btn1 & ~x3;
	x2 = ~x1;
	x3 = ~x2;
end

endmodule
