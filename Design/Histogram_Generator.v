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
    input start_histogram, start_CDF,
    inout[HISTOGRAM_RAM_DATA_WIDTH-1:0] histogram_RAM_data,
    output reg[HISTOGRAM_RAM_ADDRESS_WIDTH-1:0] histogram_RAM_address,
    output reg histogram_RAM_WE
);
    //Constants
    localparam TABLE_EDGE_SIZE = $rtoi($sqrt(TABLE_SIZE));
    localparam TABLE_EDGE_INDEX_SIZE = $rtoi($ceil($clog2(TABLE_EDGE_SIZE)));
    
    //States
    localparam WAIT_FOR_COMMAND = 0;
    localparam READ_HISTOGRAM = 1;
    localparam WRITE_HISTOGRAM = 2;
    localparam READ_CDF = 3;
    localparam WRITE_CDF = 4;

    //Registers
    reg[1:0] state;
    reg[HISTOGRAM_RAM_DATA_WIDTH-1:0] histogram_RAM_data_reg;
    reg[TABLE_EDGE_INDEX_SIZE-1:0] table_width_index;
    reg[TABLE_EDGE_INDEX_SIZE-1:0] table_height_index;
    reg[HISTOGRAM_RAM_ADDRESS_WIDTH-1:0] CDF_index;
    
    //RAM signal assignments
    assign histogram_RAM_data = histogram_RAM_WE ? histogram_RAM_data_reg : {HISTOGRAM_RAM_DATA_WIDTH{1'bZ}}; 


    //Control signals
    always @(*) begin
        if(state == READ_HISTOGRAM || state == WRITE_HISTOGRAM) begin
            histogram_RAM_address <= image_table[(table_width_index + table_height_index*TABLE_EDGE_SIZE)*PIXEL_WIDTH +: PIXEL_WIDTH];
        end else begin
            histogram_RAM_address <= CDF_index;            
        end
        histogram_RAM_WE <= 1'b0;
        
        if(state == WRITE_HISTOGRAM || state == WRITE_CDF) begin
            histogram_RAM_WE <= 1'b1;
        end
    end

    //State control
    always @(posedge clk) begin
        if(rst) begin
            state <= WAIT_FOR_COMMAND;
            histogram_RAM_data_reg <= {HISTOGRAM_RAM_DATA_WIDTH{1'b0}};
        end else begin
            case(state)
                WAIT_FOR_COMMAND: begin
                    if(start_histogram) begin
                        state <= READ_HISTOGRAM;
                    end else if(start_CDF) begin
                        state <= READ_CDF;
                    end
                end
                READ_HISTOGRAM: begin
                    histogram_RAM_data_reg <= histogram_RAM_data + 1;
                    state <= WRITE_HISTOGRAM;
                end
                WRITE_HISTOGRAM: begin
                    if(table_width_index == TABLE_EDGE_SIZE-1 && table_height_index == TABLE_EDGE_SIZE-1) begin
                        state <= WAIT_FOR_COMMAND;
                    end else begin
                        state <= READ_HISTOGRAM;
                    end
                end
                READ_CDF: begin
                    histogram_RAM_data_reg <= histogram_RAM_data_reg + histogram_RAM_data;
                    state <= WRITE_CDF;
                end
                WRITE_CDF: begin
                    if(CDF_index == $pow(HISTOGRAM_RAM_ADDRESS_WIDTH, 2) - 1) begin
                        state <= WAIT_FOR_COMMAND;
                    end else begin
                        state <= READ_CDF;
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
            CDF_index <= {HISTOGRAM_RAM_ADDRESS_WIDTH{1'b0}};
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
            end else if (state == WRITE_CDF) begin
                if(CDF_index == $pow(HISTOGRAM_RAM_ADDRESS_WIDTH, 2) - 1) begin
                    CDF_index <= {HISTOGRAM_RAM_ADDRESS_WIDTH{1'b0}};
                end else begin
                    CDF_index <= CDF_index + 1;
                end
            end
        end
    end

endmodule



























