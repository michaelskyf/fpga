module mUart
#(
    parameter CLOCK_SPEED,
    parameter BAUD_RATE,
)
(
    input wire clock,
    input wire uart_rx,
    output reg uart_tx,

    output reg txComplete = 1,
    input wire txReset,

    input wire [7:0] dataIn,
    output reg [7:0] dataOut,
);

localparam CLOCK_DELAY = CLOCK_SPEED / BAUD_RATE;

typedef enum {
    TX_STATE_IDLE,
    TX_STATE_DATA,
    TX_STATE_END
} eTxState;

reg [31:0] clockCounter;

eTxState txState = TX_STATE_IDLE;
reg [7:0] txCounter;
wire wasReset;
wire resetEvent;

reg [7:0] txBuf;

assign wasReset = txComplete && txReset + wasReset && txComplete;

task handleTx();
    begin
        case(txState)
            TX_STATE_IDLE: if(wasReset) begin // Start bit
                uart_tx <= 0;
                txComplete <= 0;
                txState <= TX_STATE_DATA;
                txBuf <= dataIn;
            end
            TX_STATE_DATA: begin // Data
                if(txCounter < 8) begin
                    txCounter <= txCounter + 1;
                    uart_tx <= txBuf[txCounter];
                end else begin
                    txState <= TX_STATE_END;
                end
            end
            TX_STATE_END: begin // Stop bit
                uart_tx <= 1;
                txComplete <= 1;
                txState <= TX_STATE_IDLE;
                txCounter <= 0;
            end
        endcase
    end

endtask

always_ff @( posedge clock )
begin
    clockCounter <= clockCounter + 1;
    if(clockCounter == CLOCK_DELAY)
    begin
        clockCounter <= 0;

        handleTx();

    end

end

endmodule

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
reg [7:0] rx;
wire txComplete;
reg txReset = 0;

mUart #(CLK_SPEED, BAUD_RATE) uart(clk, uart_rx, uart_tx, txComplete, txReset, tx, rx);

reg [31:0] test = 0;
always_ff @( posedge clk )
begin

    txReset <= 0;
    test <= test + 1;
    if(test == CLK_SPEED/10)
    begin
        test <= 0;
        if(txComplete == 1)
        begin
            if(tx == "~")
                tx <= "!";
            else
                tx <= tx + 1;

            txReset <= 1;
        end
    end
end

assign led[0] = txComplete;
assign led[5:1] = 5'b11111;

endmodule