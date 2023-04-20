//////////////////////////////////////////////////////////////////////////////////
// Module Name: Image Processor
// Description: Decodes JPEG encoded image and filters it based on given command
//////////////////////////////////////////////////////////////////////////////////

`timescale 1ns / 1ps

module Image_Processor(
    input clk, rst,
    input rx,
    output tx
);
    //Parameters
    localparam CLK_FREQ = 100_000_000;
    localparam BAUD_RATE = 115_200;
    localparam COMMAND_WIDTH = 16;
    localparam IMAGE_WIDTH = 320;
    localparam IMAGE_HEIGHT = 240;
    localparam PIXEL_WIDTH = 8;
    localparam TABLE_SIZE = 64;
    localparam TABLE_EDGE_SIZE = $rtoi($sqrt(TABLE_SIZE));
    localparam BLOCK_WIDTH_SIZE = IMAGE_WIDTH/TABLE_EDGE_SIZE;
    localparam BLOCK_WIDTH_INDEX_SIZE = $rtoi($ceil($clog2(BLOCK_WIDTH_SIZE)));
    localparam BLOCK_HEIGHT_SIZE = IMAGE_HEIGHT/TABLE_EDGE_SIZE;
    localparam BLOCK_HEIGHT_INDEX_SIZE = $rtoi($ceil($clog2(BLOCK_HEIGHT_SIZE)));
    localparam BLOCK_SIZE = 8*8;
    localparam SWIPER_SIZE = 5*5;
    localparam IMAGE_RAM_ADDRESS_WIDTH = $rtoi($ceil($clog2(IMAGE_WIDTH*IMAGE_HEIGHT)));
    localparam OLD_VALUE_RAM_ADDRESS_WIDTH = $rtoi($ceil($clog2(IMAGE_WIDTH*$rtoi($sqrt(SWIPER_SIZE))/2)));
    localparam HISTOGRAM_RAM_ADDRESS_WIDTH = PIXEL_WIDTH;
    localparam HISTOGRAM_RAM_DATA_WIDTH = $rtoi($ceil($clog2(IMAGE_WIDTH*IMAGE_HEIGHT)));


    //Wires
    //UART
    wire UART_receiver_bit, UART_receiver_is_new;
    wire[7:0] UART_transmitter_data;
    wire UART_transmitter_is_new, UART_transmitter_ready;
    
    //Packet parser
    wire packet_parser_bit, packet_parser_is_new;
    wire[COMMAND_WIDTH-1:0] command;
    
    //RAM
    wire image_RAM_WE, image_RAM_CE;
    wire[IMAGE_RAM_ADDRESS_WIDTH-1:0] image_RAM_address;
    wire[PIXEL_WIDTH-1:0] image_RAM_data;
    
    wire histogram_RAM_WE, histogram_RAM_CE;
    wire[HISTOGRAM_RAM_ADDRESS_WIDTH-1:0] histogram_RAM_address;
    wire[HISTOGRAM_RAM_DATA_WIDTH-1:0] histogram_RAM_data;

    wire old_value_RAM_WE;
    wire[OLD_VALUE_RAM_ADDRESS_WIDTH-1:0] old_value_RAM_address;
    wire[PIXEL_WIDTH-1:0] old_value_RAM_data;
    
    wire is_image_RAM_available, is_histogram_RAM_available;
    
    //Decoder RAM signals
    wire decoder_image_RAM_WE, decoder_image_RAM_CE;
    wire[IMAGE_RAM_ADDRESS_WIDTH-1:0] decoder_image_RAM_address;
    wire[PIXEL_WIDTH-1:0] decoder_image_RAM_data;
    
    wire decoder_histogram_RAM_WE, decoder_histogram_RAM_CE;
    wire[HISTOGRAM_RAM_ADDRESS_WIDTH-1:0] decoder_histogram_RAM_address;
    wire[HISTOGRAM_RAM_DATA_WIDTH-1:0] decoder_histogram_RAM_data;
    
    //Filter RAM signals
    wire filter_image_RAM_WE, filter_image_RAM_CE;
    wire[IMAGE_RAM_ADDRESS_WIDTH-1:0] filter_image_RAM_address;
    wire[PIXEL_WIDTH-1:0] filter_image_RAM_data;
    
    wire filter_histogram_RAM_CE;
    wire[HISTOGRAM_RAM_ADDRESS_WIDTH-1:0] filter_histogram_RAM_address;
    wire[HISTOGRAM_RAM_DATA_WIDTH-1:0] filter_histogram_RAM_data;
    
    //Decoder
    wire[BLOCK_WIDTH_INDEX_SIZE-1:0] decoded_width_block_index;
    wire[BLOCK_HEIGHT_INDEX_SIZE-1:0] decoded_height_block_index;
    wire histogram_generated;
    wire CDF_generated;
    wire[HISTOGRAM_RAM_DATA_WIDTH-1:0] CDF_min;
    
    
    //Modules
    UART_Receiver #(
        .CLK_FREQ(CLK_FREQ),
        .BAUD_RATE(BAUD_RATE)
    ) uart_receiver(
        .clk(clk), 
        .rst(rst),
        .rx(rx),
        .bit(UART_receiver_bit),
        .is_new(UART_receiver_is_new)
    );

    UART_Transmitter #(
        .CLK_FREQ(CLK_FREQ),
        .BAUD_RATE(BAUD_RATE)        
    )uart_transmitter(
        .clk(clk),
        .rst(rst),
        .data(UART_transmitter_data),
        .is_new(UART_transmitter_is_new),
        .tx(tx),
        .ready(UART_transmitter_ready)
    );
    
    Packet_Parser #(
        .COMMAND_WIDTH(COMMAND_WIDTH)
    ) packet_parser(
        .clk(clk), 
        .rst(rst),
        .input_bit(UART_receiver_bit), 
        .is_new_input_bit(UART_receiver_is_new),
        .output_bit(packet_parser_bit), 
        .is_new_output_bit(packet_parser_is_new),
        .command(command)
    );
    
    Decoder #(
        .IMAGE_WIDTH(IMAGE_WIDTH),
        .IMAGE_HEIGHT(IMAGE_HEIGHT),
        .PIXEL_WIDTH(PIXEL_WIDTH),
        .TABLE_SIZE(TABLE_SIZE),
        .TABLE_EDGE_SIZE(TABLE_EDGE_SIZE),
        .BLOCK_WIDTH_SIZE(BLOCK_WIDTH_SIZE),
        .BLOCK_WIDTH_INDEX_SIZE(BLOCK_WIDTH_INDEX_SIZE),
        .BLOCK_HEIGHT_SIZE(BLOCK_HEIGHT_SIZE),
        .BLOCK_HEIGHT_INDEX_SIZE(BLOCK_HEIGHT_INDEX_SIZE),
        .IMAGE_RAM_ADDRESS_WIDTH(IMAGE_RAM_ADDRESS_WIDTH),
        .HISTOGRAM_RAM_ADDRESS_WIDTH(HISTOGRAM_RAM_ADDRESS_WIDTH),
        .HISTOGRAM_RAM_DATA_WIDTH(HISTOGRAM_RAM_DATA_WIDTH)
    )
    decoder(
        .clk(clk), 
        .rst(rst),
        .bit(packet_parser_bit),
        .is_new(packet_parser_is_new),
        .command(command),
        .histogram_RAM_data(decoder_histogram_RAM_data),
        .histogram_RAM_address(decoder_histogram_RAM_address),
        .histogram_RAM_CE(decoder_histogram_RAM_CE),
        .histogram_RAM_WE(decoder_histogram_RAM_WE),
        .image_RAM_address(decoder_image_RAM_address),
        .image_RAM_data(decoder_image_RAM_data),
        .image_RAM_CE(decoder_image_RAM_CE),
        .image_RAM_WE(decoder_image_RAM_WE),
        .decoded_width_block_index(decoded_width_block_index),
        .decoded_height_block_index(decoded_height_block_index),
        .histogram_generated(histogram_generated),
        .CDF_generated(CDF_generated),
        .CDF_min(CDF_min)
    );

    Filter
    #(
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
    filter (
        .clk(clk), 
        .rst(rst),
        .UART_ready(UART_transmitter_ready),
        .stop(1'b0),
        .command(command),
        .is_image_RAM_available(is_image_RAM_available),
        .is_histogram_RAM_available(is_histogram_RAM_available),
        .decoded_width_block_index(decoded_width_block_index),
        .decoded_height_block_index(decoded_height_block_index),
        .histogram_generated(histogram_generated),
        .CDF_generated(CDF_generated),
        .histogram_RAM_data(filter_histogram_RAM_data),
        .old_value_RAM_data(old_value_RAM_data),
        .image_RAM_data(filter_image_RAM_data),
        .histogram_RAM_CE(filter_histogram_RAM_CE),
        .histogram_RAM_address(filter_histogram_RAM_address),
        .old_value_RAM_WE(old_value_RAM_WE),
        .old_value_RAM_address(old_value_RAM_address),
        .image_RAM_CE(filter_image_RAM_CE),
        .image_RAM_WE(filter_image_RAM_WE),
        .image_RAM_address(filter_image_RAM_address),
        .UART_data(UART_transmitter_data),
        .UART_is_new(UART_transmitter_is_new)
    );
    
    RAM
    #(
        .DATA_WIDTH(PIXEL_WIDTH),
        .ADDRESS_WIDTH(IMAGE_RAM_ADDRESS_WIDTH)
    )
    image_ram (
        .clk(clk), 
        .rst(rst),
        .WE(image_RAM_WE),
        .CE(image_RAM_CE),
        .address(image_RAM_address),
        .data(image_RAM_data)
    );
    
    RAM
    #(
        .DATA_WIDTH(HISTOGRAM_RAM_DATA_WIDTH),
        .ADDRESS_WIDTH(HISTOGRAM_RAM_ADDRESS_WIDTH)
    )
    histogram_ram (
        .clk(clk), 
        .rst(rst),
        .WE(histogram_RAM_WE),
        .CE(histogram_RAM_CE),
        .address(histogram_RAM_address),
        .data(histogram_RAM_data)
    );

    RAM
    #(
        .DATA_WIDTH(PIXEL_WIDTH),
        .ADDRESS_WIDTH(OLD_VALUE_RAM_ADDRESS_WIDTH)
    )
    old_value_ram (
        .clk(clk), 
        .rst(rst),
        .WE(old_value_RAM_WE),
        .CE(1'b1),
        .address(old_value_RAM_address),
        .data(old_value_RAM_data)
    );
    
    Prio_RAM_Encoder
    #(
        .DATA_WIDTH(PIXEL_WIDTH),
        .ADDRESS_WIDTH(IMAGE_RAM_ADDRESS_WIDTH)
    )
    image_prio_ram_encoder (
        .WE1_input(decoder_image_RAM_WE), 
        .WE2_input(filter_image_RAM_WE),
        .CE1_input(decoder_image_RAM_CE), 
        .CE2_input(filter_image_RAM_CE),
        .address1_input(decoder_image_RAM_address), 
        .address2_input(filter_image_RAM_address),
        .data1_input(decoder_image_RAM_data), 
        .data2_input(filter_image_RAM_data),
        .data_output(image_RAM_data),
        .WE_output(image_RAM_WE),
        .CE_output(image_RAM_CE),
        .address_output(image_RAM_address),
        .is_RAM_available(is_image_RAM_available)
    );
    
    Prio_RAM_Encoder
    #(
        .DATA_WIDTH(HISTOGRAM_RAM_DATA_WIDTH),
        .ADDRESS_WIDTH(HISTOGRAM_RAM_ADDRESS_WIDTH)
    )
    histogram_prio_ram_encoder (
        .WE1_input(decoder_histogram_RAM_WE), 
        .WE2_input(1'b0),
        .CE1_input(decoder_histogram_RAM_CE), 
        .CE2_input(filter_histogram_RAM_CE),
        .address1_input(decoder_histogram_RAM_address), 
        .address2_input(filter_histogram_RAM_address),
        .data1_input(decoder_histogram_RAM_data), 
        .data2_input(filter_histogram_RAM_data),
        .data_output(histogram_RAM_data),
        .WE_output(histogram_RAM_WE),
        .CE_output(histogram_RAM_CE),
        .address_output(histogram_RAM_address),
        .is_RAM_available(is_histogram_RAM_available)
    );

endmodule




























