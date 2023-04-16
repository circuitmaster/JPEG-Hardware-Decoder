`timescale 1ns / 1ps

module Decoder_Test;
    //Period of the clock
    localparam PERIOD = 100;
    
    //Parameters of the module
    localparam IMAGE_WIDTH = 320;
    localparam IMAGE_HEIGHT = 240;
    localparam PIXEL_WIDTH = 8;
    localparam TABLE_SIZE = 64;
    localparam IMAGE_RAM_ADDRESS_WIDTH = $rtoi($ceil($clog2(IMAGE_WIDTH*IMAGE_HEIGHT)));
    localparam HISTOGRAM_RAM_ADDRESS_WIDTH = PIXEL_WIDTH;
    localparam HISTOGRAM_RAM_DATA_WIDTH = $rtoi($ceil($clog2(IMAGE_WIDTH*IMAGE_HEIGHT)));

    //Registers given as input to the module
    reg clk = 1'b0, rst = 1'b0;
    reg bit, is_new;
    reg[15:0] command;

    //Registers given as input/output to the module
    wire[HISTOGRAM_RAM_DATA_WIDTH-1:0] histogram_RAM_data;
    
    //Outputs of the module
    wire[HISTOGRAM_RAM_ADDRESS_WIDTH-1:0] histogram_RAM_address;
    wire histogram_RAM_WE;
    wire[IMAGE_RAM_ADDRESS_WIDTH-1:0] image_RAM_address;
    wire[PIXEL_WIDTH-1:0] image_RAM_data;
    wire image_RAM_WE;
    
    //Change clock with given period
    always #(PERIOD/2) clk = ~clk;

    Decoder #(
        .IMAGE_WIDTH(320),
        .IMAGE_HEIGHT(240),
        .PIXEL_WIDTH(8),
        .TABLE_SIZE(64),
        .IMAGE_RAM_ADDRESS_WIDTH($rtoi($ceil($clog2(IMAGE_WIDTH*IMAGE_HEIGHT)))),
        .HISTOGRAM_RAM_ADDRESS_WIDTH(PIXEL_WIDTH),
        .HISTOGRAM_RAM_DATA_WIDTH($rtoi($ceil($clog2(IMAGE_WIDTH*IMAGE_HEIGHT))))
    )
    decoder(
        .clk(clk), 
        .rst(rst),
        .bit(bit),
        .is_new(is_new),
        .command(command),
        .histogram_RAM_data(histogram_RAM_data),
        .histogram_RAM_address(histogram_RAM_address),
        .histogram_RAM_WE(histogram_RAM_WE),
        .image_RAM_address(image_RAM_address),
        .image_RAM_data(image_RAM_data),
        .image_RAM_WE(image_RAM_WE)
    );

    assign histogram_RAM_data = histogram_RAM_WE ? 8'bz : 8'b1;

    initial begin
        //Reset Module
        @(posedge clk)
        rst <= 1'b1;
        @(posedge clk)
        rst <= 1'b0;
        
        bit <= 1'b0;
        is_new <= 1'b1;
    end

endmodule
