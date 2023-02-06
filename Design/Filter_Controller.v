//////////////////////////////////////////////////////////////////////////////////
// Module Name: Filter Controller
// Description: Controls filtering operations
//////////////////////////////////////////////////////////////////////////////////

`timescale 1ns / 1ps

module Filter_Controller
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
    input[PIXEL_WIDTH-1:0] filtered_pixel,
    input is_image_RAM_available,
    input[HISTOGRAM_RAM_DATA_WIDTH-1:0] histogram_RAM_data,
    inout[PIXEL_WIDTH-1:0] old_value_RAM_data,
    inout[PIXEL_WIDTH-1:0] image_RAM_data,
    output reg[SWIPER_SIZE*PIXEL_WIDTH-1:0] swiper_output,
    output reg[HISTOGRAM_RAM_DATA_WIDTH-1:0] CDF,
    output reg[HISTOGRAM_RAM_ADDRESS_WIDTH-1:0] histogram_RAM_address,
    output reg old_value_RAM_WE,
    output reg[OLD_VALUE_RAM_ADDRESS_WIDTH-1:0] old_value_RAM_address,
    output reg image_RAM_CE,
    output reg image_RAM_WE,
    output reg[IMAGE_RAM_ADDRESS_WIDTH-1:0] image_RAM_address
);
    //Constants
    localparam SWIPER_EDGE_SIZE = $rtoi($sqrt(SWIPER_SIZE));
    localparam SWIPER_EDGE_INDEX_SIZE = $rtoi($ceil($clog2(SWIPER_EDGE_SIZE)));
    localparam BLOCK_EDGE_SIZE = $rtoi($sqrt(BLOCK_SIZE));
    localparam IMAGE_WIDTH_INDEX_SIZE = $rtoi($ceil($clog2(IMAGE_WIDTH)));
    localparam IMAGE_HEIGHT_INDEX_SIZE = $rtoi($ceil($clog2(IMAGE_HEIGHT)));
    localparam PADDING_SIZE = SWIPER_EDGE_SIZE/2;
    localparam PADDED_IMAGE_WIDTH_INDEX_SIZE = $rtoi($ceil($clog2(IMAGE_WIDTH+PADDING_SIZE+1)));
    localparam PADDED_IMAGE_HEIGHT_INDEX_SIZE = $rtoi($ceil($clog2(IMAGE_HEIGHT+PADDING_SIZE+1)));
    
    //States
    localparam IDLE = 0;
    localparam FETCH_PIXEL = 1;
    localparam LOAD_PIXEL = 2;
    localparam WRITE_BACK_PIXELS = 3;
    
    //Index value
    integer i, j;

    //Registers
    reg[PIXEL_WIDTH-1:0] swiper [SWIPER_SIZE-1:0];      //5x5 8bit swiper area
    reg[SWIPER_EDGE_INDEX_SIZE-1:0] swiper_width_index;
    reg[SWIPER_EDGE_INDEX_SIZE-1:0] swiper_height_index;
    reg[IMAGE_WIDTH_INDEX_SIZE-1:0] image_width_index;
    reg[IMAGE_HEIGHT_INDEX_SIZE-1:0] image_height_index;
    reg[1:0] state;
    
    //Swiper control signals
    reg fill;
    
    //Swiper filler pixel value
    reg[PIXEL_WIDTH-1:0] pixel_value;
    
    //Helper signals
    wire is_leftmost_block;
    
    //Signals that indicate padded image coordinates
    wire[PADDED_IMAGE_WIDTH_INDEX_SIZE-1:0] absolute_image_width_index;
    wire[PADDED_IMAGE_HEIGHT_INDEX_SIZE-1:0] absolute_image_height_index;    
    wire is_coordinate_outside_of_image;
    
    //RAM signals
    reg[PIXEL_WIDTH-1:0] old_value_RAM_data_signal;
    reg[PIXEL_WIDTH-1:0] image_RAM_data_signal;
    
    assign is_leftmost_block = image_width_index == {IMAGE_WIDTH_INDEX_SIZE{1'b0}};
    
    assign absolute_image_width_index = image_width_index + swiper_width_index - PADDING_SIZE;
    assign absolute_image_height_index = image_height_index + swiper_height_index - PADDING_SIZE;
    assign is_coordinate_outside_of_image = 
                    absolute_image_width_index < {PADDED_IMAGE_WIDTH_INDEX_SIZE{1'b0}} ||
                    absolute_image_height_index < {PADDED_IMAGE_HEIGHT_INDEX_SIZE{1'b0}} ||
                    absolute_image_width_index >= IMAGE_WIDTH ||
                    absolute_image_height_index >= IMAGE_HEIGHT;
    
    assign old_value_RAM_data = old_value_RAM_WE ? old_value_RAM_data_signal : {PIXEL_WIDTH{1'bZ}};
    assign image_RAM_data = image_RAM_CE && image_RAM_WE ? image_RAM_data_signal : {PIXEL_WIDTH{1'bZ}};
    
    always @(*) begin
        for(i=0; i<SWIPER_SIZE; i=i+1) begin
            swiper_output[i*PIXEL_WIDTH +: PIXEL_WIDTH] <= swiper[i];
        end
    end
    
    always @(*) begin
        CDF <= histogram_RAM_data;
        histogram_RAM_address <= {HISTOGRAM_RAM_ADDRESS_WIDTH{1'b0}};
        old_value_RAM_WE <= 1'b0;
        old_value_RAM_address <= {OLD_VALUE_RAM_ADDRESS_WIDTH{1'b0}};
        old_value_RAM_data_signal <= {PIXEL_WIDTH{1'b0}};
        image_RAM_CE <= 1'b0;
        image_RAM_WE <= 1'b0;
        image_RAM_address <= {IMAGE_RAM_ADDRESS_WIDTH{1'b0}};
        image_RAM_data_signal <= {PIXEL_WIDTH{1'b0}};
        fill <= 1'b0;
        pixel_value <= {PIXEL_WIDTH{1'b0}};
    
        case(state)
            IDLE: begin
            end
            FETCH_PIXEL: begin
                if(!is_coordinate_outside_of_image) begin
                    if(swiper_height_index < PADDING_SIZE) begin
                        if(image_height_index[0] == swiper_height_index[0]) begin
                            old_value_RAM_address <= absolute_image_width_index;
                        end else begin
                            old_value_RAM_address <= absolute_image_width_index + IMAGE_WIDTH;
                        end
                    end else if(is_image_RAM_available) begin
                        image_RAM_CE <= 1'b1;
                        image_RAM_address <= absolute_image_width_index + absolute_image_height_index * IMAGE_WIDTH;
                    end
                end             
            end
            LOAD_PIXEL: begin
                fill <= 1'b1;
                histogram_RAM_address <= swiper[(SWIPER_SIZE-1)/2];
            
                if(is_coordinate_outside_of_image) begin
                    pixel_value <= {PIXEL_WIDTH{1'b0}};
                end else begin
                    if(swiper_height_index < PADDING_SIZE) begin
                        pixel_value <= old_value_RAM_data;
                    end else begin
                        pixel_value <= image_RAM_data;
                        old_value_RAM_WE <= 1'b1;
                        old_value_RAM_data_signal <= image_RAM_data;
                        
                        if(image_height_index[0] == 1'b0) begin
                            old_value_RAM_address <= absolute_image_width_index;
                        end else begin
                            old_value_RAM_address <= absolute_image_width_index + IMAGE_WIDTH;
                        end
                    end
                end
            end
            WRITE_BACK_PIXELS: begin
                image_RAM_CE <= 1'b1;
                image_RAM_WE <= 1'b1;
                image_RAM_address <= image_width_index + image_height_index * IMAGE_WIDTH;
                image_RAM_data_signal <= filtered_pixel;
            end
        endcase
    end


    //Swiper Control
    always @(posedge clk) begin
        if(rst) begin
            reset_swiper;
            swiper_width_index <= {SWIPER_EDGE_INDEX_SIZE{1'b0}};
            swiper_height_index <= {SWIPER_EDGE_INDEX_SIZE{1'b0}};
            image_width_index <= {IMAGE_WIDTH_INDEX_SIZE{1'b0}};
            image_height_index <= {IMAGE_HEIGHT_INDEX_SIZE{1'b0}};
        end else begin
            if(!stop) begin
                if(fill) begin
                    swiper[swiper_width_index+swiper_height_index*SWIPER_EDGE_SIZE] <= pixel_value;
                            
                    if(!is_leftmost_block && swiper_height_index == {SWIPER_EDGE_INDEX_SIZE{1'b0}}) begin
                        //Shift Swiper to the left (Don't do anything to rightmost slots, they will be filled one by one)
                        for(i=0; i<SWIPER_EDGE_SIZE; i=i+1) begin
                            for(j=0; j<SWIPER_EDGE_SIZE; j=j+1) begin
                                if(i != SWIPER_EDGE_SIZE-1) begin
                                    swiper[i+j*SWIPER_EDGE_SIZE] <= swiper[i+j*SWIPER_EDGE_SIZE+1];
                                end
                            end
                        end
                    end 
    
                    if(swiper_width_index == SWIPER_EDGE_SIZE-1) begin             
                        if(swiper_height_index == SWIPER_EDGE_SIZE-1) begin
                            swiper_height_index <= {SWIPER_EDGE_INDEX_SIZE{1'b0}};
                            
                            if(image_width_index == IMAGE_WIDTH-1) begin
                                image_width_index <= {IMAGE_WIDTH_INDEX_SIZE{1'b0}};
                                
                                if(image_height_index == IMAGE_HEIGHT-1) begin
                                    image_height_index <= {IMAGE_HEIGHT_INDEX_SIZE{1'b0}};
                                end else begin
                                    image_height_index <= image_height_index + 1;
                                end
                            end else begin
                                image_width_index <= image_width_index + 1;
                            end
                        end else begin
                            if(is_leftmost_block) begin
                                swiper_width_index <= {SWIPER_EDGE_INDEX_SIZE{1'b0}};
                            end
                        
                            swiper_height_index <= swiper_height_index + 1;
                        end
                    end else if(is_leftmost_block) begin
                        swiper_width_index <= swiper_width_index + 1;
                    end
                end
            end
        end
    end
    
    //State Control
    always @(posedge clk) begin
        if(rst) begin
            state <= IDLE;
        end else begin
            if(!stop) begin
                case(state)
                    IDLE: begin
                        state <= FETCH_PIXEL;
                    end
                    FETCH_PIXEL: begin
                        if(is_coordinate_outside_of_image || swiper_height_index < PADDING_SIZE || is_image_RAM_available) begin
                            state <= LOAD_PIXEL;
                        end
                    end
                    LOAD_PIXEL: begin
                        if(swiper_width_index == SWIPER_EDGE_SIZE-1 && swiper_height_index == SWIPER_EDGE_SIZE-1) begin
                            state <= WRITE_BACK_PIXELS;
                        end else begin
                            state <= FETCH_PIXEL;
                        end
                    end
                    WRITE_BACK_PIXELS: begin
                        state <= FETCH_PIXEL;
                    end
                endcase
            end
        end
    end


    //Reset swiper area
    task reset_swiper;
        for(i=0; i<SWIPER_SIZE; i=i+1) begin
            swiper[i] <= {PIXEL_WIDTH{1'b0}};
        end
    endtask

endmodule



























