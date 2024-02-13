module test();
  reg clk = 0;
  reg uart_rx = 1;
  wire uart_tx;
  wire complete;
  wire [7:0] rxData;
  wire completeTx;

  always
    #1 clk = ~clk;

  mUartRx #(8, 1) u(clk, uart_rx, complete, rxData);
  mUartTx #(8, 1) u2(clk, uart_tx, completeTx, complete, rxData);

    initial begin
    $display("Starting UART RX");
    $monitor("Complete Value %b", complete);
    for (int i=0; i<100; i=i+1) begin
      #16 uart_rx=0;
      #16 uart_rx=1;
      #16 uart_rx=1;
      #16 uart_rx=1;
      #16 uart_rx=1;
      #16 uart_rx=1;
      #16 uart_rx=1;
      #16 uart_rx=1;
      #16 uart_rx=1;
      #16 uart_rx=1;

      #16 uart_rx=0;
      #16 uart_rx=0;
      #16 uart_rx=0;
      #16 uart_rx=0;
      #16 uart_rx=0;
      #16 uart_rx=0;
      #16 uart_rx=0;
      #16 uart_rx=0;
      #16 uart_rx=0;
      #16 uart_rx=1;
    end
    #1000 $finish;
  end

  initial begin
    $dumpfile("uart.vcd");
    $dumpvars(0,test);
  end

endmodule