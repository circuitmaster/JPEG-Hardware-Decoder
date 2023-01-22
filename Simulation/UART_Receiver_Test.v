`timescale 1ns / 1ps

module UART_Receiver_Test;
    //Period of the clock
    localparam PERIOD = 10;
    
    //Module parameters
    localparam CLK_FREQ = 1_000_000_000/PERIOD;
    localparam BAUD_RATE = 115_200;

    //BAUD_PERIOD
    localparam BAUD_PERIOD = 1_000_000_000/BAUD_RATE;
    
    //Registers given as input to the module
    reg clk = 1'b0, rst = 1'b0;
    reg rx = 1'b0;
    
    //Outputs of the module
    wire bit;
    wire is_new;
    
    //Change clock with given period
    always #(PERIOD/2) clk = ~clk;
   
    UART_Receiver #(
        .CLK_FREQ(CLK_FREQ),
        .BAUD_RATE(BAUD_RATE)
    )
    uart_receiver(
        .clk(clk), 
        .rst(rst),
        .rx(rx),
        .bit(bit),
        .is_new(is_new)
    );

    initial begin
        //Reset Module
        @(posedge clk)
        rst <= 1'b1;
        @(posedge clk)
        rst <= 1'b0;
        
        rx <= 1'b0;
        #(BAUD_PERIOD)
        rx <= 1'b1;
        #(BAUD_PERIOD)
        rx <= 1'b0;
        #(BAUD_PERIOD)
        rx <= 1'b1;
        #(BAUD_PERIOD)
        rx <= 1'b1;
        #(BAUD_PERIOD)
        rx <= 1'b1;
        #(BAUD_PERIOD)
        rx <= 1'b0;
        #(BAUD_PERIOD)
        rx <= 1'b0;
        #(BAUD_PERIOD)
        rx <= 1'b0;
        #(BAUD_PERIOD)
        rx <= 1'b1;
    end
    
endmodule
















