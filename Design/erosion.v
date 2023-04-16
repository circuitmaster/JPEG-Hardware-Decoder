`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Module Name: erosion
// Description: Performs Erosion Filtering
//////////////////////////////////////////////////////////////////////////////////

module Erosion(
    input [71:0] image_in, //Input
    output [7:0] pixel_out //Output
);

    //For parallel calculations
    wire temp, temp2, temp3, temp4, temp5;
    
    //Calculating for two pixel whiteness
    assign temp = (image_in[7:0] > 127) & (image_in[15:8] > 127);
    assign temp2 = (image_in[23:16] > 127) & (image_in[31:24] > 127);
    assign temp3 = (image_in[39:32] > 127) & (image_in[47:40] > 127);
    assign temp4 = (image_in[55:48] > 127) & (image_in[63:56] > 127);
    
    //Calculating for four pixel whiteness
    assign temp5 = temp & temp2;
    assign temp6 = temp3 & temp4;
    
    //Calculating for eight pixel whiteness
    assign temp7 = temp5 & temp6;
    
    assign pixel_out = 8'd255 & {8{(temp7 & (image_in[71:64] > 127))}};
    
    
endmodule
