`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Module Name: Filter
// Description: Reads image bit sequence and generates filtered image
//////////////////////////////////////////////////////////////////////////////////

`timescale 1ns / 1ps

module Filter
#(
    parameter IMAGE_WIDTH = 320,
    parameter IMAGE_HEIGHT = 240,
    parameter BLOCK_SIZE = 8*8,
    parameter SWIPER_SIZE = 5*5,
    parameter PIXEL_WIDTH = 8,
    parameter HISTOGRAM_RAM_ADDRESS_WIDTH = PIXEL_WIDTH,
    parameter HISTOGRAM_RAM_DATA_WIDTH = $rtoi($ceil($clog2(IMAGE_WIDTH*IMAGE_HEIGHT))),
    parameter OLD_VALUE_RAM_ADDRESS_WIDTH = $rtoi($ceil($clog2(IMAGE_WIDTH*$rtoi($sqrt(SWIPER_SIZE))/2))),
    parameter IMAGE_RAM_ADDRESS_WIDTH = $rtoi($ceil($clog2(IMAGE_WIDTH*IMAGE_HEIGHT)))
)(
    input clk, rst,
    input stop,
    input[15:0] command,
    input is_image_RAM_available,
    input[HISTOGRAM_RAM_DATA_WIDTH-1:0] histogram_RAM_data,
    inout[PIXEL_WIDTH-1:0] old_value_RAM_data,
    inout[PIXEL_WIDTH-1:0] image_RAM_data,

    output[HISTOGRAM_RAM_ADDRESS_WIDTH-1:0] histogram_RAM_address,
    output old_value_RAM_WE,
    output[OLD_VALUE_RAM_ADDRESS_WIDTH-1:0] old_value_RAM_address,
    output image_RAM_CE,
    output image_RAM_WE,
    output[IMAGE_RAM_ADDRESS_WIDTH-1:0] image_RAM_address
);
    localparam INNER_SWIPER_SIZE = 3*3;
    localparam INNER_SWIPER_OFFSET = 6*PIXEL_WIDTH;
    
    localparam EDGE_DETECTION = 16'hA010;    
    localparam EDGE_ENHANCEMENT = 16'hA020;    
    localparam NOISE_FILTERING = 16'hA030;    
    localparam HISTOGRAM_STATISTICS = 16'hA040;    
    localparam HISTOGRAM_EQUALIZATION = 16'hA050;    
    localparam BOUNDARY_EXTRACTION = 16'hA060;    
    
    reg[PIXEL_WIDTH-1:0] filtered_pixel;
    wire[SWIPER_SIZE*PIXEL_WIDTH-1:0] swiper_output;
    wire[HISTOGRAM_RAM_DATA_WIDTH-1:0] CDF;
    
    wire[PIXEL_WIDTH-1:0] edge_x_pixel;
    wire[PIXEL_WIDTH-1:0] edge_y_pixel;
    wire[PIXEL_WIDTH-1:0] edge_log_pixel;
    wire[PIXEL_WIDTH-1:0] median_pixel;
    wire[PIXEL_WIDTH-1:0] hist_eq_pixel;
    wire[PIXEL_WIDTH-1:0] erosion_pixel;
    
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

    Edge_X edge_x(
        .image_in(swiper_output),
        .pixel_out(edge_x_pixel)
    );
    
    Edge_Y edge_y(
        .image_in(swiper_output),
        .pixel_out(edge_y_pixel)
    );
    
    Edge_Log edge_log(
        .image_in(swiper_output),
        .pixel_out(edge_log_pixel)
    );
    
    Filter_Median filter_median(
        .image_in(swiper_output[INNER_SWIPER_OFFSET +: INNER_SWIPER_SIZE*PIXEL_WIDTH]),
        .pixel_out(median_pixel)
    );
    
    Hist_Eq hist_eq(
        .cdf(CDF),
        .cdf_min(0),                //TODO: find proper input for this
        .pixel_out(hist_eq_pixel)
    );
    
    Erosion erosion(
        .image_in(swiper_output[INNER_SWIPER_OFFSET +: INNER_SWIPER_SIZE*PIXEL_WIDTH]),
        .pixel_out(erosion_pixel)
    );
    
    always @(*) begin
        filtered_pixel <= {PIXEL_WIDTH{1'b0}};    
    
        case(command)
            EDGE_DETECTION: begin
                filtered_pixel <= edge_x_pixel[6:0] + edge_y_pixel[6:0]; //TODO: check if this absolute sum is right
            end
            EDGE_ENHANCEMENT: begin
                filtered_pixel <= edge_log_pixel;
            end
            NOISE_FILTERING: begin
                filtered_pixel <= median_pixel;
            end
            HISTOGRAM_STATISTICS: begin
            end
            HISTOGRAM_EQUALIZATION: begin
                filtered_pixel <= hist_eq_pixel;
            end
            BOUNDARY_EXTRACTION: begin
                filtered_pixel <= erosion_pixel;
            end
        endcase
    end

endmodule





























