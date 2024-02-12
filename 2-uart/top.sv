`include "uart/mUartRx.sv"
`include "uart/mUartTx.sv"

module top
(
    input btn1,
    input clk,
    input uart_rx,
    output uart_tx,
    output [5:0] led,
);

localparam CLK_SPEED = 27000000; // 27MHz
localparam BAUD_RATE = 115200;
reg [7:0] tx = "!";
wire [7:0] rx;
wire complete;
wire reset;
wire dummy;

mUartTx #(CLK_SPEED, BAUD_RATE) uartTx(clk, uart_tx, dummy, complete, rx);
mUartRx #(CLK_SPEED, BAUD_RATE) uartRx(clk, uart_rx, complete, rx);

assign led[0] = ~complete;
assign led[1] = ~uart_rx;
assign led[2] = ~uart_tx;
assign led[3] = ~dummy;
assign led[5:4] = 5'b11111;

endmodule