//////////////////////////////////////////////////////////////////////////////////
// Module Name: Image Generator
// Description: Reads converted pixels from IDCT and writes into image RAM
//////////////////////////////////////////////////////////////////////////////////

`timescale 1ns / 1ps

module Image_Generator
#(
    parameter IMAGE_WIDTH = 320,
    parameter IMAGE_HEIGHT = 240,
    parameter PIXEL_WIDTH = 8,
    parameter TABLE_SIZE = 64,
    parameter IMAGE_RAM_ADDRESS_WIDTH = $rtoi($ceil($clog2(IMAGE_WIDTH*IMAGE_HEIGHT)))
)(
    input clk, rst,
    input[TABLE_SIZE*PIXEL_WIDTH-1:0] image_table,
    input is_new,
    output reg[IMAGE_RAM_ADDRESS_WIDTH-1:0] image_RAM_address,
    output reg[PIXEL_WIDTH-1:0] image_RAM_data,
    output reg image_RAM_WE
);
    localparam TABLE_EDGE_SIZE = $rtoi($sqrt(TABLE_SIZE));
    localparam TABLE_EDGE_INDEX_SIZE = $rtoi($ceil($clog2(TABLE_EDGE_SIZE)));
    localparam BLOCK_COUNT = IMAGE_WIDTH*IMAGE_HEIGHT/TABLE_SIZE;
    localparam BLOCK_WIDTH_SIZE = IMAGE_WIDTH/TABLE_EDGE_SIZE;
    localparam BLOCK_WIDTH_INDEX_SIZE = $rtoi($ceil($clog2(BLOCK_WIDTH_SIZE)));
    localparam BLOCK_HEIGHT_SIZE = IMAGE_HEIGHT/TABLE_EDGE_SIZE;
    localparam BLOCK_HEIGHT_INDEX_SIZE = $rtoi($ceil($clog2(BLOCK_HEIGHT_SIZE)));

    reg[BLOCK_WIDTH_INDEX_SIZE-1:0] block_width_index;
    reg[BLOCK_HEIGHT_INDEX_SIZE-1:0] block_height_index;
    reg[TABLE_EDGE_INDEX_SIZE-1:0] table_width_index;
    reg[TABLE_EDGE_INDEX_SIZE-1:0] table_height_index;

    always @(clk) begin
        if(rst) begin
            block_width_index <= {BLOCK_WIDTH_INDEX_SIZE{1'b0}};
            block_height_index <= {BLOCK_HEIGHT_INDEX_SIZE{1'b0}};
            table_width_index <= {TABLE_EDGE_INDEX_SIZE{1'b0}};
            table_height_index <= {TABLE_EDGE_INDEX_SIZE{1'b0}};
        end else begin
            if(table_width_index == TABLE_EDGE_SIZE-1) begin
                table_width_index <= {TABLE_EDGE_INDEX_SIZE{1'b0}};
            
                if(table_height_index == TABLE_EDGE_SIZE-1) begin
                    table_height_index <= {TABLE_EDGE_INDEX_SIZE{1'b0}};
                    
                    if(block_width_index == BLOCK_WIDTH_SIZE) begin
                        block_width_index <= {BLOCK_WIDTH_INDEX_SIZE{1'b0}};
                        
                        if(block_height_index == BLOCK_HEIGHT_SIZE) begin
                            block_height_index <= {BLOCK_HEIGHT_INDEX_SIZE{1'b0}};
                        end else begin
                            block_height_index <= block_height_index + 1;
                        end
                    end else begin
                        block_width_index <= block_width_index + 1;
                    end
                end else begin
                    table_height_index <= table_height_index + 1;
                end
            end else begin
                table_width_index <= table_width_index + 1;
            end
        end
    end

endmodule



























