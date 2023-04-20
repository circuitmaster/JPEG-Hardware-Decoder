//////////////////////////////////////////////////////////////////////////////////
// Module Name: Packet_Parser
// Description: Detects commands for the system
//////////////////////////////////////////////////////////////////////////////////

`timescale 1ns / 1ps

module Packet_Parser
#(
    parameter COMMAND_WIDTH = 16
)(
    input clk, rst,
    input input_bit, is_new_input_bit,
    output reg output_bit, is_new_output_bit,
    output reg[COMMAND_WIDTH-1:0] command
);
    //Defines
    localparam COMMAND_INDEX_WIDTH = $rtoi($ceil($clog2(COMMAND_WIDTH)));
    localparam HEADER = 16'hBACD;

    //States
    localparam DECODE_HEADER = 0;
    localparam DECODE_COMMAND = 1;
    localparam DECODE_IMAGE = 2;
    
    reg[1:0] state;
    reg[COMMAND_WIDTH-1:0] data_reg;
    reg[COMMAND_INDEX_WIDTH-1:0] data_reg_index;
    
    always @(posedge clk) begin
        if(rst) begin
            output_bit <= 1'b0;
            is_new_output_bit <= 1'b0;
            command <= {COMMAND_WIDTH{1'b0}};
            state <= 2'b0;
            data_reg <= {COMMAND_WIDTH{1'b0}};
            data_reg_index <= {COMMAND_INDEX_WIDTH{1'b0}};
        end else begin
            if(is_new_input_bit) begin
                case(state)
                    DECODE_HEADER: begin
                        data_reg[data_reg_index] <= input_bit;
                    
                        if(data_reg_index == {COMMAND_INDEX_WIDTH{1'b0}}) begin
                            data_reg_index <= COMMAND_WIDTH-1;
                            if({data_reg[COMMAND_WIDTH-1:1], input_bit} == HEADER) begin
                                state <= DECODE_COMMAND;
                            end
                        end else begin
                            data_reg_index <= data_reg_index - 1;
                        end
                    end
                    DECODE_COMMAND: begin
                        data_reg[data_reg_index] <= input_bit;
                    
                        if(data_reg_index == {COMMAND_INDEX_WIDTH{1'b0}}) begin
                            data_reg_index <= COMMAND_WIDTH-1;
                            command <= {data_reg[COMMAND_WIDTH-1:1], input_bit};
                            state <= DECODE_IMAGE;
                        end else begin
                            data_reg_index <= data_reg_index - 1;
                        end
                    end
                    DECODE_IMAGE: begin
                        output_bit <= input_bit;
                        is_new_output_bit <= is_new_input_bit;
                    end
                endcase
            end
        end
    end

endmodule




























