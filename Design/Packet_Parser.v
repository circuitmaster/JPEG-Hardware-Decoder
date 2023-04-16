//////////////////////////////////////////////////////////////////////////////////
// Module Name: Packet_Parser
// Description: Detects commands for the system
//////////////////////////////////////////////////////////////////////////////////

`timescale 1ns / 1ps

module Packet_Parser(
    input clk, rst,
    input input_bit, is_new_input_bit,
    output reg output_bit, is_new_output_bit,
    output reg[15:0] command
);
    //Defines
    localparam HEADER = 16'hBACD;
    localparam EDGE_DETECTION_COMMAND = 16'hA010
;
    localparam EDGE_ENHANCEMENT_COMMAND = 16'hA020;
    localparam NOISE_FILTERING_COMMAND = 16'hA030;
    localparam HISTOGRAM_STATISTICS_COMMAND = 16'hA040;
    localparam HISTOGRAM_EQUALIZATION_COMMAND = 16'hA050;
    localparam BOUNDARY_EXTRACTION_COMMAND = 16'hA060;

    //States
    localparam DECODE_HEADER = 0;
    localparam DECODE_COMMAND = 1;
    localparam DECODE_IMAGE = 2;
    
    reg[1:0] state;
    reg[15:0] data_reg;
    reg[3:0] data_reg_index;
    
    always @(posedge clk) begin
        if(rst) begin
            output_bit <= 1'b0;
            is_new_output_bit <= 1'b0;
            command <= 16'b0;
            state <= 2'b0;
            data_reg <= 16'b0;
            data_reg_index <= 4'd15;
        end else begin
            if(is_new_input_bit) begin
                case(state)
                    DECODE_HEADER: begin
                        data_reg[data_reg_index] <= input_bit;
                    
                        if(data_reg_index == 4'b0) begin
                            data_reg_index <= 4'd15;
                            if({data_reg[7:1], input_bit} == HEADER) begin
                                state <= DECODE_COMMAND;
                            end
                        end else begin
                            data_reg_index <= data_reg_index - 1;
                        end
                    end
                    DECODE_COMMAND: begin
                        data_reg[data_reg_index] <= input_bit;
                    
                        if(data_reg_index == 4'b0) begin
                            data_reg_index <= 4'd15;
                            command <= {data_reg[7:1], input_bit};
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




























