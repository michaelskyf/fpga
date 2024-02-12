module mUartTx
#(
    parameter CLOCK_SPEED,
    parameter BAUD_RATE,
)
(
    input wire clock,
    output reg uart_tx,

    output reg complete = 1,
    input wire send,

    input wire [7:0] dataIn,
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

reg [7:0] txBuf;
reg shouldSend = 0;

task handleTx();
    begin
        case(txState)
            TX_STATE_IDLE: if(shouldSend) begin // Start bit
                shouldSend <= 0;
                uart_tx <= 0;
                complete <= 0;
                txState <= TX_STATE_DATA;
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
                complete <= 1;
                txState <= TX_STATE_IDLE;
                txCounter <= 0;
            end
        endcase
    end

endtask

always_ff @( posedge clock )
begin

    if(complete && send)
    begin
        shouldSend <= 1;
        txBuf <= dataIn;
    end

    clockCounter <= clockCounter + 1;
    if(clockCounter == CLOCK_DELAY)
    begin
        clockCounter <= 0;

        handleTx();

    end

end

endmodule