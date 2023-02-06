`timescale 1ns / 100ps

module Filter_Controller_Test;
    //Period of the clock
    localparam PERIOD = 100;
    
    //Parameters of the module
    localparam IMAGE_WIDTH = 320;
    localparam IMAGE_HEIGHT = 240;
    localparam BLOCK_SIZE = 8*8;
    localparam SWIPER_SIZE = 5*5;
    localparam PIXEL_WIDTH = 8;
    localparam HISTOGRAM_RAM_ADDRESS_WIDTH = PIXEL_WIDTH;
    localparam HISTOGRAM_RAM_DATA_WIDTH = $rtoi($ceil($clog2(IMAGE_WIDTH*IMAGE_HEIGHT)));
    localparam OLD_VALUE_RAM_ADDRESS_WIDTH = $rtoi($ceil($clog2(IMAGE_WIDTH*$rtoi($sqrt(SWIPER_SIZE))/2)));
    localparam IMAGE_RAM_ADDRESS_WIDTH = $rtoi($ceil($clog2(IMAGE_WIDTH*IMAGE_HEIGHT)));

    //Registers given as input to the module
    reg clk = 1'b0, rst = 1'b0;
    reg stop = 1'b0;
    reg[PIXEL_WIDTH-1:0] filtered_pixel;
    reg is_image_RAM_available;

    //Registers given as input/output to the module
    wire[HISTOGRAM_RAM_DATA_WIDTH-1:0] histogram_RAM_data;
    wire[PIXEL_WIDTH-1:0] old_value_RAM_data;
    wire[PIXEL_WIDTH-1:0] image_RAM_data;
    
    //Outputs of the module
    wire[SWIPER_SIZE*PIXEL_WIDTH-1:0] swiper_output;
    wire CDF;
    wire histogram_RAM_WE;
    wire[HISTOGRAM_RAM_DATA_WIDTH-1:0] histogram_RAM_address;
    wire old_value_RAM_WE;
    wire[OLD_VALUE_RAM_ADDRESS_WIDTH-1:0] old_value_RAM_address;
    wire image_RAM_CE;
    wire image_RAM_WE;
    wire[IMAGE_RAM_ADDRESS_WIDTH-1:0] image_RAM_address;
    
    //Change clock with given period
    always #(PERIOD/2) clk = ~clk;

    Filter_Controller #(
        .IMAGE_WIDTH(IMAGE_WIDTH),
        .IMAGE_HEIGHT(IMAGE_HEIGHT),
        .BLOCK_SIZE(BLOCK_SIZE),
        .SWIPER_SIZE(SWIPER_SIZE),
        .PIXEL_WIDTH(PIXEL_WIDTH),
        .HISTOGRAM_RAM_ADDRESS_WIDTH(HISTOGRAM_RAM_ADDRESS_WIDTH),
        .HISTOGRAM_RAM_DATA_WIDTH(HISTOGRAM_RAM_DATA_WIDTH),
        .OLD_VALUE_RAM_ADDRESS_WIDTH(OLD_VALUE_RAM_ADDRESS_WIDTH),
        .IMAGE_RAM_ADDRESS_WIDTH(IMAGE_RAM_ADDRESS_WIDTH)
    )
    filter_controller(
        .clk(clk), 
        .rst(rst),
        .stop(stop),
        .filtered_pixel(filtered_pixel),
        .is_image_RAM_available(is_image_RAM_available),
        .histogram_RAM_data(histogram_RAM_data),
        .old_value_RAM_data(old_value_RAM_data),
        .image_RAM_data(image_RAM_data),
        .swiper_output(swiper_output),
        .CDF(CDF),
        .histogram_RAM_address(histogram_RAM_address),
        .old_value_RAM_WE(old_value_RAM_WE),
        .old_value_RAM_address(old_value_RAM_address),
        .image_RAM_CE(image_RAM_CE),
        .image_RAM_WE(image_RAM_WE),
        .image_RAM_address(image_RAM_address)
    );

    assign histogram_RAM_data = 17;
    assign image_RAM_data = (image_RAM_CE && image_RAM_WE) ? 8'bZ : 8'b1;
    assign old_value_RAM_data = old_value_RAM_WE ? 8'bZ : 8'b1;

    initial begin
        //Reset Module
        @(posedge clk)
        rst <= 1'b1;
        @(posedge clk)
        rst <= 1'b0;
        
        filtered_pixel <= 8'h33;
        is_image_RAM_available <= 1'b1;
    end
    
endmodule
