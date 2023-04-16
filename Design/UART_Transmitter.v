//////////////////////////////////////////////////////////////////////////////////
// Module Name: UART Transmitter
// Description: Takes data as byte and outputs UART signals
//////////////////////////////////////////////////////////////////////////////////

`timescale 1ns / 1ps

module UART_Transmitter
#(
    parameter CLK_FREQ = 100_000_000,
    parameter BAUD_RATE = 115_200
)(
    input clk, rst,
    input[7:0] data,
    input is_new,         //Indicates input data is new
    output reg tx,        //Transmitted UART signal
    output reg ready      //UART module is ready to take new data
);
    localparam TIMER_LIMIT = CLK_FREQ/BAUD_RATE;                        //Number of clock cycles that module has to wait
    localparam TIMER_REG_LENGTH = $rtoi($ceil($clog2(TIMER_LIMIT)));    //Register length that will be hold timer value

    //States
    localparam IDLE = 0;
    localparam START = 1;
    localparam TRANSMISSION = 2;
    localparam STOP = 3;
    
    //Registers
    reg[1:0] state;                     //State of the UART
    reg[TIMER_REG_LENGTH-1:0] timer;    //Timer value that is used to meet baud rate
    reg[2:0] bit_counter;               //Holds transmitted bit count
    reg[7:0] data_reg;                  //Holds data
    
    //UART state transition
    always @(posedge clk) begin
        if(rst) begin
            tx <= 1'b0;
            ready <= 1'b1;
            state <= 2'b0;
            timer <= {TIMER_REG_LENGTH{1'b0}};
            bit_counter <= 3'b0;
            data_reg <= 8'b0;
        end else begin
            case(state)
                IDLE: begin
                    //initialize bit_counter and timer
                    bit_counter <= 3'b0;
                    timer <= {TIMER_REG_LENGTH{1'b0}};
                    
                    //Start transfer if input signal is 1
                    if(is_new == 1'b1) begin
                        data_reg <= data;
                        ready <= 1'b0;
                        state <= START;
                    end
                end
                START: begin
                    tx <= 1'b0;
                    
                    //Transmit start signal until TIMER_LIMIT reached
                    if(timer == TIMER_LIMIT-1) begin
                        timer <= {TIMER_REG_LENGTH{1'b0}};
                        state <= TRANSMISSION;
                    end else begin
                        //Increment timer
                        timer <= timer + 1;
                    end
                end
                TRANSMISSION: begin
                    tx <= data_reg[0];
                
                    //Transmit data until TIMER_LIMIT reached
                    if(timer == TIMER_LIMIT-1) begin
                        timer <= {TIMER_REG_LENGTH{1'b0}};
                        
                        if(bit_counter == 7) begin
                            tx <= 1'b1;
                            state <= STOP;
                        end else begin
                            data_reg[6:0] <= data_reg[7:1];
                            bit_counter <= bit_counter + 1;
                        end
                    end else begin
                        //Increment timer
                        timer <= timer + 1;
                    end
                end
                STOP: begin
                    if(timer == TIMER_LIMIT-1) begin
                        //When stop bit is came go back to IDLE state
                        ready <= 1'b1;
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




























