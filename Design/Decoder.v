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
    parameter IMAGE_RAM_ADDRESS_WIDTH = $rtoi($ceil($clog2(IMAGE_WIDTH*IMAGE_HEIGHT))),
    parameter HISTOGRAM_RAM_ADDRESS_WIDTH = PIXEL_WIDTH,
    parameter HISTOGRAM_RAM_DATA_WIDTH = $rtoi($ceil($clog2(IMAGE_WIDTH*IMAGE_HEIGHT)))
)(
    input clk, rst,
    input bit,
    input is_new,
    inout[HISTOGRAM_RAM_DATA_WIDTH-1:0] histogram_RAM_data,
    output[HISTOGRAM_RAM_ADDRESS_WIDTH-1:0] histogram_RAM_address,
    output histogram_RAM_WE,
    output[IMAGE_RAM_ADDRESS_WIDTH-1:0] image_RAM_address,
    output[PIXEL_WIDTH-1:0] image_RAM_data,
    output image_RAM_WE
);

    wire[3:0] r_value;
    wire[7:0] coefficient;
    wire is_new_coefficient;
    
    wire[64*8-1:0] table_value;
    wire is_table_valid;
    
    wire[64*8-1:0] idct_out;
    wire is_idct_valid;
    
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
    
    idct_complete idct(
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
        .IMAGE_RAM_ADDRESS_WIDTH(IMAGE_RAM_ADDRESS_WIDTH)
    )
    image_generator(
        .clk(clk), 
        .rst(rst),
        .image_table(idct_out),
        .start(is_idct_valid),
        .image_RAM_address(image_RAM_address),
        .image_RAM_data(image_RAM_data),
        .image_RAM_WE(image_RAM_WE)
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
        .start_CDF(1),                              //TODO: Connect cdf command to meaningfull thing
        .histogram_RAM_data(histogram_RAM_data),
        .histogram_RAM_address(histogram_RAM_address),
        .histogram_RAM_WE(histogram_RAM_WE)
    );

endmodule
























