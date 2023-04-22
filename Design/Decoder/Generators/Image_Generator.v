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
    parameter DC_OFFSET = 128,
    parameter TABLE_SIZE = 64,
    parameter TABLE_EDGE_SIZE = $rtoi($sqrt(TABLE_SIZE)),
    parameter BLOCK_WIDTH_SIZE = IMAGE_WIDTH/TABLE_EDGE_SIZE,
    parameter BLOCK_WIDTH_INDEX_SIZE = $rtoi($ceil($clog2(BLOCK_WIDTH_SIZE))),
    parameter BLOCK_HEIGHT_SIZE = IMAGE_HEIGHT/TABLE_EDGE_SIZE,
    parameter BLOCK_HEIGHT_INDEX_SIZE = $rtoi($ceil($clog2(BLOCK_HEIGHT_SIZE))),
    parameter IMAGE_RAM_ADDRESS_WIDTH = $rtoi($ceil($clog2(IMAGE_WIDTH*IMAGE_HEIGHT)))
)(
    input clk, rst,
    input[TABLE_SIZE*PIXEL_WIDTH-1:0] image_table,
    input start,
    output reg[IMAGE_RAM_ADDRESS_WIDTH-1:0] image_RAM_address,
    output reg[PIXEL_WIDTH-1:0] image_RAM_data,
    output reg image_RAM_CE, image_RAM_WE,
    output[BLOCK_WIDTH_INDEX_SIZE-1:0] decoded_width_block_index,
    output[BLOCK_HEIGHT_INDEX_SIZE-1:0] decoded_height_block_index,
    output reg image_generated
);
    //Constants
    localparam TABLE_EDGE_INDEX_SIZE = $rtoi($ceil($clog2(TABLE_EDGE_SIZE)));
    
    //States
    localparam WAIT_FOR_TABLE = 0;
    localparam GENERATE_IMAGE = 1;

    //Registers
    reg state;
    reg[BLOCK_WIDTH_INDEX_SIZE-1:0] block_width_index;
    reg[BLOCK_HEIGHT_INDEX_SIZE-1:0] block_height_index;
    reg[TABLE_EDGE_INDEX_SIZE-1:0] table_width_index;
    reg[TABLE_EDGE_INDEX_SIZE-1:0] table_height_index;
    
    assign decoded_width_block_index = block_width_index;
    assign decoded_height_block_index = block_height_index;

    //Control signals
    always @(*) begin
        image_RAM_address <= {IMAGE_RAM_ADDRESS_WIDTH{1'b0}};
        image_RAM_data <= {PIXEL_WIDTH{1'b0}};
        image_RAM_CE <= 1'b0;
        image_RAM_WE <= 1'b0;
        
        if(state == GENERATE_IMAGE) begin
            image_RAM_address <= block_width_index*TABLE_EDGE_SIZE + table_width_index + (block_height_index*TABLE_EDGE_SIZE + table_height_index)*IMAGE_WIDTH;
            image_RAM_data <= image_table[(table_width_index + table_height_index*TABLE_EDGE_SIZE)*PIXEL_WIDTH +: PIXEL_WIDTH] + DC_OFFSET;
            image_RAM_CE <= 1'b1;
            image_RAM_WE <= 1'b1;
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
                        state <= GENERATE_IMAGE;
                    end
                end
                GENERATE_IMAGE: begin
                    if(table_width_index == TABLE_EDGE_SIZE-1 && table_height_index == TABLE_EDGE_SIZE-1) begin
                        state <= WAIT_FOR_TABLE;
                    end
                end
                
            endcase
        end
    end

    //Index increment
    always @(posedge clk) begin
        if(rst) begin
            block_width_index <= {BLOCK_WIDTH_INDEX_SIZE{1'b0}};
            block_height_index <= {BLOCK_HEIGHT_INDEX_SIZE{1'b0}};
            table_width_index <= {TABLE_EDGE_INDEX_SIZE{1'b0}};
            table_height_index <= {TABLE_EDGE_INDEX_SIZE{1'b0}};
            image_generated <= 1'b0;
        end else begin
            image_generated <= 1'b0;
        
            if(state == GENERATE_IMAGE) begin
                if(table_width_index == TABLE_EDGE_SIZE-1) begin
                    table_width_index <= {TABLE_EDGE_INDEX_SIZE{1'b0}};
                
                    if(table_height_index == TABLE_EDGE_SIZE-1) begin
                        table_height_index <= {TABLE_EDGE_INDEX_SIZE{1'b0}};
                        
                        if(block_width_index == BLOCK_WIDTH_SIZE-1) begin
                            block_width_index <= {BLOCK_WIDTH_INDEX_SIZE{1'b0}};
                            
                            if(block_height_index == BLOCK_HEIGHT_SIZE-1) begin
                                block_height_index <= {BLOCK_HEIGHT_INDEX_SIZE{1'b0}};
                                image_generated <= 1'b1;
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
    end

endmodule



























