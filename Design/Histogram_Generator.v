//////////////////////////////////////////////////////////////////////////////////
// Module Name: Histogram Generator
// Description: Reads converted pixels from IDCT, calculates histogram and 
//              writes it into histogram RAM
//////////////////////////////////////////////////////////////////////////////////

`timescale 1ns / 1ps

module Histogram_Generator
#(
    parameter IMAGE_WIDTH = 320,
    parameter IMAGE_HEIGHT = 240,
    parameter PIXEL_WIDTH = 8,
    parameter TABLE_SIZE = 64,
    parameter HISTOGRAM_RAM_ADDRESS_WIDTH = PIXEL_WIDTH,
    parameter HISTOGRAM_RAM_DATA_WIDTH = $rtoi($ceil($clog2(IMAGE_WIDTH*IMAGE_HEIGHT)))
)(
    input clk, rst,
    input[TABLE_SIZE*PIXEL_WIDTH-1:0] image_table,
    input start, is_first_table,
    inout[HISTOGRAM_RAM_DATA_WIDTH-1:0] histogram_RAM_data,
    output reg[HISTOGRAM_RAM_ADDRESS_WIDTH-1:0] histogram_RAM_address,
    output reg histogram_RAM_WE
);
    //Constants
    localparam TABLE_EDGE_SIZE = $rtoi($sqrt(TABLE_SIZE));
    localparam TABLE_EDGE_INDEX_SIZE = $rtoi($ceil($clog2(TABLE_EDGE_SIZE)));
    
    //States
    localparam WAIT_FOR_TABLE = 0;
    localparam READ_HISTOGRAM = 1;
    localparam WRITE_HISTOGRAM = 2;

    //Registers
    reg[1:0] state;
    reg[HISTOGRAM_RAM_DATA_WIDTH-1:0] histogram_RAM_data_reg;
    reg[TABLE_EDGE_INDEX_SIZE-1:0] table_width_index;
    reg[TABLE_EDGE_INDEX_SIZE-1:0] table_height_index;

    //RAM signals
    reg[HISTOGRAM_RAM_DATA_WIDTH-1:0] histogram_RAM_data_signal;
    
    //RAM signal assignments
    assign histogram_RAM_data = histogram_RAM_WE ? histogram_RAM_data_signal : {HISTOGRAM_RAM_DATA_WIDTH{1'bZ}}; 


    //Control signals
    always @(*) begin
        histogram_RAM_address <= image_table[(table_width_index + table_height_index*TABLE_EDGE_SIZE)*PIXEL_WIDTH +: PIXEL_WIDTH];
        histogram_RAM_data_signal <= is_first_table ? 1 : histogram_RAM_data_reg + 1;
        histogram_RAM_WE <= 1'b0;
        
        if(state == WRITE_HISTOGRAM) begin
            histogram_RAM_WE <= 1'b1;
        end
    end

    //State control
    always @(posedge clk) begin
        if(rst) begin
            state <= WAIT_FOR_TABLE;
        end else begin
            case(state)
                WAIT_FOR_TABLE: begin
                    if(start) begin
                        if(is_first_table) begin
                            state <= WRITE_HISTOGRAM;
                        end else begin
                            state <= READ_HISTOGRAM;
                        end
                    end
                end
                READ_HISTOGRAM: begin
                    histogram_RAM_data_reg <= histogram_RAM_data;
                    state <= WRITE_HISTOGRAM;
                end
                WRITE_HISTOGRAM: begin
                    if(table_width_index == TABLE_EDGE_SIZE-1 && table_height_index == TABLE_EDGE_SIZE-1) begin
                        state <= WAIT_FOR_TABLE;
                    end else if(!is_first_table) begin
                        state <= READ_HISTOGRAM;
                    end
                end
                
            endcase
        end
    end

    //Index increment
    always @(posedge clk) begin
        if(rst) begin
            table_width_index <= {TABLE_EDGE_INDEX_SIZE{1'b0}};
            table_height_index <= {TABLE_EDGE_INDEX_SIZE{1'b0}};
        end else begin
            if(state == WRITE_HISTOGRAM) begin
                if(table_width_index == TABLE_EDGE_SIZE-1) begin
                    table_width_index <= {TABLE_EDGE_INDEX_SIZE{1'b0}};
                
                    if(table_height_index == TABLE_EDGE_SIZE-1) begin
                        table_height_index <= {TABLE_EDGE_INDEX_SIZE{1'b0}};
                    end else begin
                        table_height_index <= table_height_index + 1;
                    end
                end else begin
                    table_width_index <= table_width_index + 1;
                end
            end
        end
    end

endmodule



























