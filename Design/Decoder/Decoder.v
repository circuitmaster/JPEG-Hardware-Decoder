//////////////////////////////////////////////////////////////////////////////////
// Module Name: Decoder
// Description: Reads encoded image bit sequence and generates decoded image
//////////////////////////////////////////////////////////////////////////////////

`timescale 1ns / 1ps

module Decoder
#(
    parameter IMAGE_WIDTH = 320,
    parameter IMAGE_HEIGHT = 240,
    parameter PIXEL_WIDTH = 8,
    parameter TABLE_SIZE = 64,    
    parameter TABLE_EDGE_SIZE = $rtoi($sqrt(TABLE_SIZE)),
    parameter BLOCK_WIDTH_SIZE = IMAGE_WIDTH/TABLE_EDGE_SIZE,
    parameter BLOCK_WIDTH_INDEX_SIZE = $rtoi($ceil($clog2(BLOCK_WIDTH_SIZE))),
    parameter BLOCK_HEIGHT_SIZE = IMAGE_HEIGHT/TABLE_EDGE_SIZE,
    parameter BLOCK_HEIGHT_INDEX_SIZE = $rtoi($ceil($clog2(BLOCK_HEIGHT_SIZE))),
    parameter IMAGE_RAM_ADDRESS_WIDTH = $rtoi($ceil($clog2(IMAGE_WIDTH*IMAGE_HEIGHT))),
    parameter HISTOGRAM_RAM_ADDRESS_WIDTH = PIXEL_WIDTH,
    parameter HISTOGRAM_RAM_DATA_WIDTH = $rtoi($ceil($clog2(IMAGE_WIDTH*IMAGE_HEIGHT)))
)(
    input clk, rst,
    input bit,
    input is_new,
    input[15:0] command,
    inout[HISTOGRAM_RAM_DATA_WIDTH-1:0] histogram_RAM_data,
    output[HISTOGRAM_RAM_ADDRESS_WIDTH-1:0] histogram_RAM_address,
    output histogram_RAM_CE, histogram_RAM_WE,
    output[IMAGE_RAM_ADDRESS_WIDTH-1:0] image_RAM_address,
    output[PIXEL_WIDTH-1:0] image_RAM_data,
    output image_RAM_CE, image_RAM_WE,
    output[BLOCK_WIDTH_INDEX_SIZE-1:0] decoded_width_block_index,
    output[BLOCK_HEIGHT_INDEX_SIZE-1:0] decoded_height_block_index,
    output histogram_generated,
    output CDF_generated,
    output[HISTOGRAM_RAM_DATA_WIDTH-1:0] CDF_min
);
    //Commands
    localparam EDGE_DETECTION = 16'hA010;    
    localparam EDGE_ENHANCEMENT = 16'hA020;    
    localparam NOISE_FILTERING = 16'hA030;    
    localparam HISTOGRAM_STATISTICS = 16'hA040;    
    localparam HISTOGRAM_EQUALIZATION = 16'hA050;    
    localparam BOUNDARY_EXTRACTION = 16'hA060;  
    
    wire[3:0] r_value;
    wire[7:0] coefficient;
    wire is_new_coefficient;
    
    wire[64*8-1:0] table_value;
    wire is_table_valid;
    
    wire[64*8-1:0] idct_out;
    wire is_idct_valid;
    
    wire start_CDF;
    assign start_CDF = (command == HISTOGRAM_EQUALIZATION && histogram_generated);
    
    
    Number_Generator number_generator(
        .clk(clk), 
        .rst(rst),
        .bit_input(bit),
        .is_new_bit(is_new),
        .r_value(r_value),
        .coefficient(coefficient),
        .is_new_coefficient(is_new_coefficient)
    );
    
    Table_Generator table_generator(
        .clk(clk), 
        .rst(rst),
        .is_new_coefficient(is_new_coefficient),
        .r_value(r_value),
        .coefficient(coefficient),
        .table_value(table_value),
        .valid(is_table_valid)
    );
    
    IDCT2 idct(
        .clk(clk),
        .rst(rst),
        .s_valid(is_table_valid),
        .data_in(table_value),
        .data_out(idct_out),
        .m_valid(is_idct_valid)
    );
    
    Image_Generator #(
        .IMAGE_WIDTH(IMAGE_WIDTH),
        .IMAGE_HEIGHT(IMAGE_HEIGHT),
        .PIXEL_WIDTH(PIXEL_WIDTH),
        .TABLE_SIZE(TABLE_SIZE),
        .TABLE_EDGE_SIZE(TABLE_EDGE_SIZE),
        .BLOCK_WIDTH_SIZE(BLOCK_WIDTH_SIZE),
        .BLOCK_WIDTH_INDEX_SIZE(BLOCK_WIDTH_INDEX_SIZE),
        .BLOCK_HEIGHT_SIZE(BLOCK_HEIGHT_SIZE),
        .BLOCK_HEIGHT_INDEX_SIZE(BLOCK_HEIGHT_INDEX_SIZE),
        .IMAGE_RAM_ADDRESS_WIDTH(IMAGE_RAM_ADDRESS_WIDTH)
    )
    image_generator(
        .clk(clk), 
        .rst(rst),
        .image_table(idct_out),
        .start(is_idct_valid),
        .image_RAM_address(image_RAM_address),
        .image_RAM_data(image_RAM_data),
        .image_RAM_CE(image_RAM_CE),
        .image_RAM_WE(image_RAM_WE),
        .decoded_width_block_index(decoded_width_block_index),
        .decoded_height_block_index(decoded_height_block_index)
    );
    
    Histogram_Generator #(
        .IMAGE_WIDTH(IMAGE_WIDTH),
        .IMAGE_HEIGHT(IMAGE_HEIGHT),
        .PIXEL_WIDTH(PIXEL_WIDTH),
        .TABLE_SIZE(TABLE_SIZE),
        .HISTOGRAM_RAM_ADDRESS_WIDTH(HISTOGRAM_RAM_ADDRESS_WIDTH),
        .HISTOGRAM_RAM_DATA_WIDTH(HISTOGRAM_RAM_DATA_WIDTH)
    )
    histogram_generator(
        .clk(clk), 
        .rst(rst),
        .image_table(idct_out),
        .start_histogram(is_idct_valid),
        .start_CDF(start_CDF),
        .histogram_RAM_data(histogram_RAM_data),
        .histogram_RAM_address(histogram_RAM_address),
        .histogram_RAM_CE(histogram_RAM_CE),
        .histogram_RAM_WE(histogram_RAM_WE),
        .histogram_generated(histogram_generated),
        .CDF_generated(CDF_generated),
        .CDF_min(CDF_min)
    );

endmodule
























