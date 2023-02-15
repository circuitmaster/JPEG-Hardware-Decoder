`timescale 1ns / 100ps

module Image_Generator_Test;
    //Period of the clock
    localparam PERIOD = 100;
    
    //Parameters of the module
    localparam IMAGE_WIDTH = 320;
    localparam IMAGE_HEIGHT = 240;
    localparam PIXEL_WIDTH = 8;
    localparam TABLE_SIZE = 64;
    localparam IMAGE_RAM_ADDRESS_WIDTH = $rtoi($ceil($clog2(IMAGE_WIDTH*IMAGE_HEIGHT)));

    //Registers given as input to the module
    reg clk = 1'b0, rst = 1'b0;
    reg[TABLE_SIZE*PIXEL_WIDTH-1:0] image_table;
    reg start;

    //Outputs of the module
    wire[IMAGE_RAM_ADDRESS_WIDTH-1:0] image_RAM_address;
    wire[PIXEL_WIDTH-1:0] image_RAM_data;
    wire image_RAM_WE;
    
    //Change clock with given period
    always #(PERIOD/2) clk = ~clk;

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
        .image_table(image_table),
        .start(start),
        .image_RAM_address(image_RAM_address),
        .image_RAM_data(image_RAM_data),
        .image_RAM_WE(image_RAM_WE)
    );

    initial begin
        //Reset Module
        @(posedge clk)
        rst <= 1'b1;
        @(posedge clk)
        rst <= 1'b0;
        
        start <= 1'b1;
        image_table <= {
            {8'd63}, {8'd62}, {8'd61}, {8'd60}, {8'd59}, {8'd58}, {8'd57}, {8'd56},
            {8'd55}, {8'd54}, {8'd53}, {8'd52}, {8'd51}, {8'd50}, {8'd49}, {8'd48},
            {8'd47}, {8'd46}, {8'd45}, {8'd44}, {8'd43}, {8'd42}, {8'd41}, {8'd40},
            {8'd39}, {8'd38}, {8'd37}, {8'd36}, {8'd35}, {8'd34}, {8'd33}, {8'd32},
            {8'd31}, {8'd30}, {8'd29}, {8'd28}, {8'd27}, {8'd26}, {8'd25}, {8'd24},
            {8'd23}, {8'd22}, {8'd21}, {8'd20}, {8'd19}, {8'd18}, {8'd17}, {8'd16},
            {8'd15}, {8'd14}, {8'd13}, {8'd12}, {8'd11}, {8'd10}, {8'd9},  {8'd8},
            {8'd7},  {8'd6},  {8'd5},  {8'd4},  {8'd3},  {8'd2},  {8'd1},  {8'd0}
        };
        
        @(posedge clk)
        start <= 1'b0;
    end
    
endmodule
