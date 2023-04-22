//////////////////////////////////////////////////////////////////////////////////
// Module Name: Filter
// Description: Reads image bit sequence and generates filtered image
//////////////////////////////////////////////////////////////////////////////////

`timescale 1ns / 1ps

module Filter
#(
    parameter IMAGE_WIDTH = 320,
    parameter IMAGE_HEIGHT = 240,
    parameter SWIPER_SIZE = 5*5,
    parameter PIXEL_WIDTH = 8,
    parameter TABLE_SIZE = 64,
    parameter TABLE_EDGE_SIZE = $rtoi($sqrt(TABLE_SIZE)),
    parameter BLOCK_WIDTH_SIZE = IMAGE_WIDTH/TABLE_EDGE_SIZE,
    parameter BLOCK_WIDTH_INDEX_SIZE = $rtoi($ceil($clog2(BLOCK_WIDTH_SIZE))),
    parameter BLOCK_HEIGHT_SIZE = IMAGE_HEIGHT/TABLE_EDGE_SIZE,
    parameter BLOCK_HEIGHT_INDEX_SIZE = $rtoi($ceil($clog2(BLOCK_HEIGHT_SIZE))),
    parameter HISTOGRAM_RAM_ADDRESS_WIDTH = PIXEL_WIDTH,
    parameter HISTOGRAM_RAM_DATA_WIDTH = $rtoi($ceil($clog2(IMAGE_WIDTH*IMAGE_HEIGHT))),
    parameter OLD_VALUE_RAM_ADDRESS_WIDTH = $rtoi($ceil($clog2(IMAGE_WIDTH*$rtoi($sqrt(SWIPER_SIZE))/2))),
    parameter IMAGE_RAM_ADDRESS_WIDTH = $rtoi($ceil($clog2(IMAGE_WIDTH*IMAGE_HEIGHT)))
)(
    input clk, rst,
    input UART_ready,
    input stop,
    input[15:0] command,
    input is_image_RAM_available, is_histogram_RAM_available,
    input[BLOCK_WIDTH_INDEX_SIZE-1:0] decoded_width_block_index,
    input[BLOCK_HEIGHT_INDEX_SIZE-1:0] decoded_height_block_index,
    input image_generated, histogram_generated, CDF_generated,
    input[HISTOGRAM_RAM_DATA_WIDTH-1:0] CDF_min,
    input[HISTOGRAM_RAM_DATA_WIDTH-1:0] histogram_RAM_data_input,
    input[PIXEL_WIDTH-1:0] old_value_RAM_data_input,
    input[PIXEL_WIDTH-1:0] image_RAM_data_input,
    output[PIXEL_WIDTH-1:0] old_value_RAM_data_output,
    output[PIXEL_WIDTH-1:0] image_RAM_data_output,
    output histogram_RAM_CE,
    output[HISTOGRAM_RAM_ADDRESS_WIDTH-1:0] histogram_RAM_address,
    output old_value_RAM_WE,
    output[OLD_VALUE_RAM_ADDRESS_WIDTH-1:0] old_value_RAM_address,
    output image_RAM_CE,
    output image_RAM_WE,
    output[IMAGE_RAM_ADDRESS_WIDTH-1:0] image_RAM_address,
    output[7:0] UART_data,
    output UART_is_new
);
    //Constants
    localparam SWIPER_EDGE_SIZE =$rtoi($sqrt(SWIPER_SIZE)); 
    localparam INNER_SWIPER_SIZE = SWIPER_SIZE - 4*SWIPER_EDGE_SIZE + 4;
    localparam INNER_SWIPER_OFFSET = SWIPER_EDGE_SIZE + 1;
    
    //Commands
    localparam EDGE_DETECTION = 16'hA010;    
    localparam EDGE_ENHANCEMENT = 16'hA020;    
    localparam NOISE_FILTERING = 16'hA030;    
    localparam HISTOGRAM_STATISTICS = 16'hA040;    
    localparam HISTOGRAM_EQUALIZATION = 16'hA050;    
    localparam BOUNDARY_EXTRACTION = 16'hA060;    
    
    //Filter controller commands
    localparam NO_COMMAND = 0;
    localparam FILTER_AND_TRANSFER_IMAGE = 1;
    localparam TRANSFER_HISTOGRAM = 2;
    
    //Signals
    reg[1:0] filter_controller_command;
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
        .SWIPER_SIZE(SWIPER_SIZE),
        .PIXEL_WIDTH(PIXEL_WIDTH),
        .TABLE_SIZE(TABLE_SIZE),
        .TABLE_EDGE_SIZE(TABLE_EDGE_SIZE),
        .BLOCK_WIDTH_SIZE(BLOCK_WIDTH_SIZE),
        .BLOCK_WIDTH_INDEX_SIZE(BLOCK_WIDTH_INDEX_SIZE),
        .BLOCK_HEIGHT_SIZE(BLOCK_HEIGHT_SIZE),
        .BLOCK_HEIGHT_INDEX_SIZE(BLOCK_HEIGHT_INDEX_SIZE),
        .HISTOGRAM_RAM_ADDRESS_WIDTH(HISTOGRAM_RAM_ADDRESS_WIDTH),
        .HISTOGRAM_RAM_DATA_WIDTH(HISTOGRAM_RAM_DATA_WIDTH),
        .OLD_VALUE_RAM_ADDRESS_WIDTH(OLD_VALUE_RAM_ADDRESS_WIDTH),
        .IMAGE_RAM_ADDRESS_WIDTH(IMAGE_RAM_ADDRESS_WIDTH)
    )
    filter_controller(
        .clk(clk), 
        .rst(rst),
        .UART_ready(UART_ready),
        .stop(stop),
        .command(filter_controller_command),
        .filtered_pixel(filtered_pixel),
        .is_image_RAM_available(is_image_RAM_available),
        .is_histogram_RAM_available(is_histogram_RAM_available),
        .decoded_width_block_index(decoded_width_block_index),
        .decoded_height_block_index(decoded_height_block_index),
        .image_generated(image_generated),
        .histogram_RAM_data_input(histogram_RAM_data_input),
        .old_value_RAM_data_input(old_value_RAM_data_input),
        .image_RAM_data_input(image_RAM_data_input),
        .old_value_RAM_data_output(old_value_RAM_data_output),
        .image_RAM_data_output(image_RAM_data_output),
        .swiper_output(swiper_output),
        .CDF(CDF),
        .histogram_RAM_CE(histogram_RAM_CE),
        .histogram_RAM_address(histogram_RAM_address),
        .old_value_RAM_WE(old_value_RAM_WE),
        .old_value_RAM_address(old_value_RAM_address),
        .image_RAM_CE(image_RAM_CE),
        .image_RAM_WE(image_RAM_WE),
        .image_RAM_address(image_RAM_address),
        .UART_data(UART_data),
        .UART_is_new(UART_is_new)
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
        .image_in(swiper_output[INNER_SWIPER_OFFSET*PIXEL_WIDTH +: INNER_SWIPER_SIZE*PIXEL_WIDTH]),
        .pixel_out(median_pixel)
    );
    
    Hist_Eq hist_eq(
        .cdf(CDF),
        .cdf_min(CDF_min),
        .pixel_out(hist_eq_pixel)
    );
    
    Erosion erosion(
        .image_in(swiper_output[INNER_SWIPER_OFFSET*PIXEL_WIDTH +: INNER_SWIPER_SIZE*PIXEL_WIDTH]),
        .pixel_out(erosion_pixel)
    );
    
    always @(*) begin
        filtered_pixel <= {PIXEL_WIDTH{1'b0}};
        filter_controller_command <= NO_COMMAND;   
    
        case(command)
            EDGE_DETECTION: begin
                filtered_pixel <= edge_x_pixel[6:0] + edge_y_pixel[6:0]; //TODO: check if this absolute sum is right
                filter_controller_command <= FILTER_AND_TRANSFER_IMAGE;
            end
            EDGE_ENHANCEMENT: begin
                filtered_pixel <= edge_log_pixel;
                filter_controller_command <= FILTER_AND_TRANSFER_IMAGE;
            end
            NOISE_FILTERING: begin
                filtered_pixel <= median_pixel;
                filter_controller_command <= FILTER_AND_TRANSFER_IMAGE;
            end
            HISTOGRAM_STATISTICS: begin
                if(histogram_generated) begin
                    filter_controller_command <= TRANSFER_HISTOGRAM;
                end
            end
            HISTOGRAM_EQUALIZATION: begin
                filtered_pixel <= hist_eq_pixel;

                if(CDF_generated) begin
                    filter_controller_command <= FILTER_AND_TRANSFER_IMAGE;
                end
            end
            BOUNDARY_EXTRACTION: begin
                filtered_pixel <= erosion_pixel;
                filter_controller_command <= FILTER_AND_TRANSFER_IMAGE;
            end
        endcase
    end

endmodule





























