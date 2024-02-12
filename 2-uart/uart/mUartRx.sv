module mUartRx
#(
    parameter CLOCK_SPEED,
    parameter BAUD_RATE,
)
(
    input wire clk,
    input wire uart_rx,

    output reg complete = 0,
    output reg [7:0] dataOut,
);

localparam CLOCK_DELAY = CLOCK_SPEED / BAUD_RATE;
localparam START_DELAY = CLOCK_DELAY / 2;
typedef enum {
    RX_STATE_IDLE,
    RX_STATE_DATA,
} eRxState;

reg [31:0] clkCounter = 0;
reg [3:0] dataCounter = 0;
eRxState rxState = RX_STATE_IDLE;

always_ff @( posedge clk )
begin

    clkCounter <= clkCounter + 1;
    complete <= 0;
    
    case(rxState)
        RX_STATE_IDLE: if(uart_rx == 0) begin
            if(clkCounter == START_DELAY)
            begin
                rxState <= RX_STATE_DATA;
                clkCounter <= 0;
            end
        end else
            clkCounter <= 0;
        RX_STATE_DATA: if(clkCounter == CLOCK_DELAY) begin
            clkCounter <= 0;

            if(dataCounter < 8) begin
                dataCounter <= dataCounter + 1;
                dataOut <= {uart_rx, dataOut[7:1]};
            end else if(uart_rx == 1) begin
                complete <= 1;
                dataCounter <= 0;
                rxState <= RX_STATE_IDLE;
            end
        end
    endcase
end

endmodule