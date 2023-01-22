//////////////////////////////////////////////////////////////////////////////////
// Module Name: UART Receiver
// Description: Takes UART signals and outputs bit by bit
//////////////////////////////////////////////////////////////////////////////////

`timescale 1ns / 1ps

module UART_Receiver 
#(
    parameter CLK_FREQ = 100_000_000,
    parameter BAUD_RATE = 115_200
)(
    input clk, rst,
    input rx,           //Received UART signal
    output reg bit,     //Output bit value
    output reg is_new   //Indicates if output is valid
);
    //Constants
    localparam TIMER_LIMIT = CLK_FREQ/BAUD_RATE;                        //Number of clock cycles that module has to wait
    localparam TIMER_REG_LENGTH = $rtoi($ceil($clog2(TIMER_LIMIT)));    //Register length that will be hold timer value
    
    //States
    localparam IDLE = 0;
    localparam START = 1;
    localparam TRANSMISSION = 2;
    localparam STOP = 3;
    
    //Registers
    reg bit_reg;                        //Holds outgoing bit
    reg is_new_reg;                     //Indicates if outgoing bit is valid
    reg[1:0] state;                     //State of the UART
    reg[TIMER_REG_LENGTH-1:0] timer;    //Timer value that is used to meet baud rate
    reg[2:0] bit_counter;               //Holds received bit count
    
    //Output signals
    always @(*) begin
        bit <= bit_reg;
        is_new <= is_new_reg;
    end
    
    //UART state transation
    always @(posedge clk) begin
        if(rst) begin
            bit_reg <= 1'b0;
            is_new_reg <= 1'b0;
            state <= 2'b0;
            timer <= {TIMER_REG_LENGTH{1'b0}};
            bit_counter <= 3'b0;
        end else begin
            case(state)
                IDLE: begin
                    //initialize bit_counter and timer
                    bit_counter <= 3'b0;
                    timer <= {TIMER_REG_LENGTH{1'b0}};
                    
                    //Start transfer if input signal is 0
                    if(rx == 1'b0)
                        state <= START;
                end
                START: begin
                    //When timer is half of TIMER_LIMIT sample rx
                    //This makes it possible to sample rx in the middle. So it is safer.
                    if(timer == TIMER_LIMIT/2-1) begin
                        if(rx == 1'b0) begin
                            //Signal is still 0 so start data transfer
                            timer <= {TIMER_REG_LENGTH{1'b0}};
                            state <= TRANSMISSION;
                        end else begin
                            //Signal is 1 so it is unreliable. Go back to IDLE state
                            state <= IDLE;
                        end
                    end else begin
                        //Increment timer
                        timer <= timer + 1;
                    end
                end
                TRANSMISSION: begin
                    //If timer reaches to TIMER_LIMIT sample rx and use it as data bit
                    if(timer == TIMER_LIMIT-1) begin
                        timer <= {TIMER_REG_LENGTH{1'b0}};
                        bit_reg <= rx;
                        is_new_reg <= 1'b1;
                        
                        if(bit_counter == 3'd7)
                            //If bit count reaches 8 transfer is completed
                            state <= STOP;
                        else
                            //Increment bit count until 8 bit is get
                            bit_counter <= bit_counter + 1;
                    end else begin
                        //Increment timer
                        is_new_reg <= 1'b0;
                        timer <= timer + 1;
                    end
                end
                STOP: begin
                    is_new_reg <= 1'b0;
                
                    if(timer == TIMER_LIMIT-1) begin
                        //When stop bit is came go back to IDLE state
                        state <= IDLE;
                    end else begin
                        //Increment timer
                        timer <= timer + 1;
                    end
                end
            endcase
        end
    end
    
endmodule
















