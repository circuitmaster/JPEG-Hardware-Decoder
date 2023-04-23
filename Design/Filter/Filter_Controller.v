`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Module Name: Filter Controller
// Description: Controls filtering operations
//////////////////////////////////////////////////////////////////////////////////

`timescale 1ns / 1ps

module Filter_Controller
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
    input[1:0] command,
    input[PIXEL_WIDTH-1:0] filtered_pixel,
    input is_image_RAM_available, is_histogram_RAM_available,
    input[BLOCK_WIDTH_INDEX_SIZE-1:0] decoded_width_block_index,
    input[BLOCK_HEIGHT_INDEX_SIZE-1:0] decoded_height_block_index,
    input image_generated,
    input[HISTOGRAM_RAM_DATA_WIDTH-1:0] histogram_RAM_data_input,
    input[PIXEL_WIDTH-1:0] old_value_RAM_data_input,
    input[PIXEL_WIDTH-1:0] image_RAM_data_input,
    output reg[PIXEL_WIDTH-1:0] old_value_RAM_data_output,
    output reg[PIXEL_WIDTH-1:0] image_RAM_data_output,
    output reg[SWIPER_SIZE*PIXEL_WIDTH-1:0] swiper_output,
    output reg[HISTOGRAM_RAM_DATA_WIDTH-1:0] CDF,
    output reg histogram_RAM_CE,
    output reg[HISTOGRAM_RAM_ADDRESS_WIDTH-1:0] histogram_RAM_address,
    output reg old_value_RAM_WE,
    output reg[OLD_VALUE_RAM_ADDRESS_WIDTH-1:0] old_value_RAM_address,
    output reg image_RAM_CE,
    output reg image_RAM_WE,
    output reg[IMAGE_RAM_ADDRESS_WIDTH-1:0] image_RAM_address,
    output reg[7:0] UART_data,
    output reg UART_is_new 
);
    //Commands
    localparam NO_COMMAND = 0;
    localparam FILTER_AND_TRANSFER_IMAGE = 1;
    localparam TRANSFER_HISTOGRAM = 2;
    
    //Constants
    localparam SWIPER_EDGE_SIZE = $rtoi($sqrt(SWIPER_SIZE));
    localparam SWIPER_EDGE_INDEX_SIZE = $rtoi($ceil($clog2(SWIPER_EDGE_SIZE)));
    localparam IMAGE_WIDTH_INDEX_SIZE = $rtoi($ceil($clog2(IMAGE_WIDTH)));
    localparam IMAGE_HEIGHT_INDEX_SIZE = $rtoi($ceil($clog2(IMAGE_HEIGHT)));
    localparam PADDING_SIZE = SWIPER_EDGE_SIZE/2;
    localparam PADDED_IMAGE_WIDTH_INDEX_SIZE = $rtoi($ceil($clog2(IMAGE_WIDTH+PADDING_SIZE+1)));
    localparam PADDED_IMAGE_HEIGHT_INDEX_SIZE = $rtoi($ceil($clog2(IMAGE_HEIGHT+PADDING_SIZE+1)));
    
    //States
    localparam WAIT_FOR_COMMAND = 0;
    localparam FETCH_PIXEL = 1;
    localparam LOAD_PIXEL = 2;
    localparam WRITE_BACK_PIXEL = 3;
    localparam TRANSFER_IMAGE_READ = 4;
    localparam TRANSFER_IMAGE_WRITE = 5;
    localparam TRANSFER_HISTOGRAM_READ = 6;
    localparam TRANSFER_HISTOGRAM_WRITE = 7;
    
    //Index value
    integer i, j;

    //Registers
    reg[PIXEL_WIDTH-1:0] swiper [SWIPER_SIZE-1:0];      //5x5 8bit swiper area
    reg[SWIPER_EDGE_INDEX_SIZE-1:0] swiper_width_index;
    reg[SWIPER_EDGE_INDEX_SIZE-1:0] swiper_height_index;
    reg[IMAGE_WIDTH_INDEX_SIZE-1:0] image_width_index;
    reg[IMAGE_HEIGHT_INDEX_SIZE-1:0] image_height_index;
    reg[2:0] state;
    
    //Swiper control signals
    reg fill;
    
    //Helper registers
    reg[PIXEL_WIDTH-1:0] pixel_value;
    reg[HISTOGRAM_RAM_DATA_WIDTH-1:0] histogram_reg;
    reg image_filtered;
    reg[IMAGE_RAM_ADDRESS_WIDTH-1:0] image_transfer_index;
    reg[HISTOGRAM_RAM_ADDRESS_WIDTH-1:0] histogram_transfer_index;
    reg image_generated_reg;
    
    //Helper signals
    wire is_leftmost_block;
    wire is_there_enough_decoded_block;
    
    //Signals that indicate padded image coordinates
    wire signed[PADDED_IMAGE_WIDTH_INDEX_SIZE:0] absolute_image_width_index;
    wire signed[PADDED_IMAGE_HEIGHT_INDEX_SIZE:0] absolute_image_height_index;    
    wire is_coordinate_outside_of_image;
    
    //Helper assignments
    assign is_leftmost_block = image_width_index == {IMAGE_WIDTH_INDEX_SIZE{1'b0}};
    
    //Ram signal assignments
    assign absolute_image_width_index = image_width_index + swiper_width_index - PADDING_SIZE;
    assign absolute_image_height_index = image_height_index + swiper_height_index - PADDING_SIZE;
    assign is_coordinate_outside_of_image = 
                    absolute_image_width_index < $signed({PADDED_IMAGE_WIDTH_INDEX_SIZE+1{1'b0}}) ||
                    absolute_image_height_index < $signed({PADDED_IMAGE_HEIGHT_INDEX_SIZE+1{1'b0}}) ||
                    absolute_image_width_index >= $signed(IMAGE_WIDTH) ||
                    absolute_image_height_index >= $signed(IMAGE_HEIGHT);
                    
    assign is_there_enough_decoded_block  = 
                    image_generated_reg ||
                    absolute_image_height_index < $signed(decoded_height_block_index * TABLE_EDGE_SIZE) ||
                    (absolute_image_height_index < $signed((decoded_height_block_index + 1) * TABLE_EDGE_SIZE) &&
                    absolute_image_width_index <  $signed(decoded_width_block_index * TABLE_EDGE_SIZE));
    

    always @(*) begin
        for(i=0; i<SWIPER_SIZE; i=i+1) begin
            swiper_output[i*PIXEL_WIDTH +: PIXEL_WIDTH] <= swiper[i];
        end
    end
    
    
    //Control signals
    always @(*) begin
        CDF <= histogram_reg;
        histogram_RAM_CE <= 1'b0;
        histogram_RAM_address <= {HISTOGRAM_RAM_ADDRESS_WIDTH{1'b0}};
        old_value_RAM_WE <= 1'b0;
        old_value_RAM_address <= {OLD_VALUE_RAM_ADDRESS_WIDTH{1'b0}};
        old_value_RAM_data_output <= {PIXEL_WIDTH{1'b0}};
        image_RAM_CE <= 1'b0;
        image_RAM_WE <= 1'b0;
        image_RAM_address <= {IMAGE_RAM_ADDRESS_WIDTH{1'b0}};
        image_RAM_data_output <= {PIXEL_WIDTH{1'b0}};
        fill <= 1'b0;
        pixel_value <= {PIXEL_WIDTH{1'b0}};
        UART_data <= 8'b0;
        UART_is_new <= 1'b0;
    
        case(state)
            WAIT_FOR_COMMAND: begin
            end
            FETCH_PIXEL: begin
                histogram_RAM_CE <= 1'b1;
                histogram_RAM_address <= swiper[(SWIPER_SIZE-1)/2];
                
                if(!is_coordinate_outside_of_image) begin
                    if(swiper_height_index < PADDING_SIZE) begin
                        if(image_height_index[0] == swiper_height_index[0]) begin
                            old_value_RAM_address <= absolute_image_width_index;
                        end else begin
                            old_value_RAM_address <= absolute_image_width_index + IMAGE_WIDTH;
                        end
                    end else if(is_image_RAM_available && is_histogram_RAM_available && is_there_enough_decoded_block) begin
                        image_RAM_CE <= 1'b1;
                        image_RAM_address <= absolute_image_width_index + absolute_image_height_index * IMAGE_WIDTH;
                    end
                end             
            end
            LOAD_PIXEL: begin
                fill <= 1'b1;
            
                if(is_coordinate_outside_of_image) begin
                    pixel_value <= {PIXEL_WIDTH{1'b0}};
                end else begin
                    if(swiper_height_index < PADDING_SIZE) begin
                        pixel_value <= old_value_RAM_data_input;
                    end else begin
                        pixel_value <= image_RAM_data_input;
                        old_value_RAM_WE <= 1'b1;
                        old_value_RAM_data_output <= image_RAM_data_input;
                        
                        if(image_height_index[0] == 1'b0) begin
                            old_value_RAM_address <= absolute_image_width_index;
                        end else begin
                            old_value_RAM_address <= absolute_image_width_index + IMAGE_WIDTH;
                        end
                    end
                end
            end
            WRITE_BACK_PIXEL: begin
                if(is_image_RAM_available) begin
                    image_RAM_CE <= 1'b1;
                    image_RAM_WE <= 1'b1;
                    image_RAM_address <= image_width_index + image_height_index * IMAGE_WIDTH;
                    image_RAM_data_output <= filtered_pixel;
                end
            end
            TRANSFER_IMAGE_READ: begin
                if(is_image_RAM_available) begin
                    image_RAM_CE <= 1'b1;
                    image_RAM_address <= image_transfer_index;
                end                
            end
            TRANSFER_IMAGE_WRITE: begin
                if(UART_ready) begin
                    UART_data <= image_RAM_data_input;
                    UART_is_new <= 1'b1;
                end
            end
            TRANSFER_HISTOGRAM_READ: begin
                if(is_histogram_RAM_available) begin
                    histogram_RAM_CE <= 1'b1;
                    histogram_RAM_address <= histogram_transfer_index;
                end    
            end
            TRANSFER_HISTOGRAM_WRITE: begin
                if(UART_ready) begin
                    UART_data <= histogram_RAM_data_input;
                    UART_is_new <= 1'b1;
                end
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
            histogram_reg <= {HISTOGRAM_RAM_DATA_WIDTH{1'b0}};
            image_filtered <= 1'b0;
        end else begin 
            if(state == WRITE_BACK_PIXEL && is_image_RAM_available) begin
                image_filtered <= 1'b0;
            end
        
            if(!stop) begin
                if(fill) begin
                    swiper[swiper_width_index+swiper_height_index*SWIPER_EDGE_SIZE] <= pixel_value;
                    histogram_reg <= histogram_RAM_data_input;
                            
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
                                swiper_width_index <= {SWIPER_EDGE_INDEX_SIZE{1'b0}};
                                swiper_height_index <= {SWIPER_EDGE_INDEX_SIZE{1'b0}};
                                
                                if(image_height_index == IMAGE_HEIGHT-1) begin
                                    image_height_index <= {IMAGE_HEIGHT_INDEX_SIZE{1'b0}};
                                    image_filtered <= 1'b1;
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
            state <= WAIT_FOR_COMMAND;
            image_transfer_index <= {IMAGE_RAM_ADDRESS_WIDTH{1'b0}};
            histogram_transfer_index <= {HISTOGRAM_RAM_ADDRESS_WIDTH{1'b0}};
            image_generated_reg <= 1'b0;
        end else begin
            if(!stop) begin
                if(image_generated)
                    image_generated_reg <= 1'b1;
            
                case(state)
                    WAIT_FOR_COMMAND: begin
                        case(command)
                            FILTER_AND_TRANSFER_IMAGE: begin
                                state <= FETCH_PIXEL;
                            end
                            TRANSFER_HISTOGRAM: begin
                                state <= TRANSFER_HISTOGRAM_READ;
                            end
                        endcase
                    end
                    FETCH_PIXEL: begin
                        if(is_coordinate_outside_of_image || 
                           swiper_height_index < PADDING_SIZE || 
                           (is_image_RAM_available && is_histogram_RAM_available && is_there_enough_decoded_block)) 
                        begin
                            state <= LOAD_PIXEL;
                        end
                    end
                    LOAD_PIXEL: begin
                        if(swiper_width_index == SWIPER_EDGE_SIZE-1 && swiper_height_index == SWIPER_EDGE_SIZE-1) begin
                            state <= WRITE_BACK_PIXEL;
                        end else begin
                            state <= FETCH_PIXEL;
                        end
                    end
                    WRITE_BACK_PIXEL: begin
                        if(is_image_RAM_available) begin
                            if(image_filtered) begin
                                state <= TRANSFER_IMAGE_READ;
                            end else begin
                                state <= FETCH_PIXEL;
                            end
                        end
                    end
                    TRANSFER_IMAGE_READ: begin
                        if(is_image_RAM_available) begin
                            state <= TRANSFER_IMAGE_WRITE;
                        end
                    end
                    TRANSFER_IMAGE_WRITE: begin
                        if(UART_ready) begin
                            if(image_transfer_index == IMAGE_WIDTH*IMAGE_HEIGHT-1) begin
                                image_transfer_index = {IMAGE_RAM_ADDRESS_WIDTH{1'b0}};
                                image_generated_reg <= 1'b0;
                                state <= WAIT_FOR_COMMAND;
                            end else begin
                                image_transfer_index <= image_transfer_index + 1;
                                state <= TRANSFER_IMAGE_READ;
                            end
                        end
                    end
                    TRANSFER_HISTOGRAM_READ: begin
                        if(is_histogram_RAM_available) begin
                            state <= TRANSFER_HISTOGRAM_WRITE;
                        end
                    end
                    TRANSFER_HISTOGRAM_WRITE: begin
                        if(UART_ready) begin
                            if(histogram_transfer_index == 2**HISTOGRAM_RAM_ADDRESS_WIDTH-1) begin
                                histogram_transfer_index <= {HISTOGRAM_RAM_ADDRESS_WIDTH{1'b0}};
                                image_generated_reg <= 1'b0;
                                state <= WAIT_FOR_COMMAND;
                            end else begin
                                histogram_transfer_index <= histogram_transfer_index + 1;
                                state <= TRANSFER_HISTOGRAM_READ;
                            end
                        end
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



























