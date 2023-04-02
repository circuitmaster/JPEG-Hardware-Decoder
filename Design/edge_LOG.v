`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/02/2023 02:27:54 PM
// Design Name: 
// Module Name: edge_LOG
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module edge_LOG(
    input [199:0] image_in, //Input Matrix
    
    output [7:0] pixel_out //Output Matrix
);
    // Gaussian blur kernel
    // reg [7:0] edge_x = {8'd1,8'd2,8'd1,8'd2,8'd4,8'd2,8'd1,8'd2,8'd1};
    
    wire [7:0] el1 = -1*image_in[7:0]; 
    wire [7:0] el2 = -3*image_in[15:8]; 
    wire [7:0] el3 = -4*image_in[23:16]; 
    wire [7:0] el4 = -3*image_in[31:24]; 
    wire [7:0] el5 = -1*image_in[39:32]; 

    wire [7:0] el6 = -3*image_in[47:40]; 
    wire [7:0] el7 = 0*image_in[55:48]; 
    wire [7:0] el8 = 6*image_in[63:56]; 
    wire [7:0] el9 = 0*image_in[71:64]; 
    wire [7:0] el10 = -3*image_in[79:72]; 

    wire [7:0] el11 = -4*image_in[87:80]; 
    wire [7:0] el12 = 6*image_in[95:88]; 
    wire [7:0] el13 = 21*image_in[103:96]; 
    wire [7:0] el14 = 6*image_in[111:104]; 
    wire [7:0] el15 = -4*image_in[119:112]; 

    wire [7:0] el16 = -3*image_in[127:120]; 
    wire [7:0] el17 = 0*image_in[135:128]; 
    wire [7:0] el18 = 6*image_in[143:136]; 
    wire [7:0] el19 = 0*image_in[151:144]; 
    wire [7:0] el20 = -3*image_in[159:152]; 

    wire [7:0] el21 = -1*image_in[167:160]; 
    wire [7:0] el22 = -3*image_in[175:168]; 
    wire [7:0] el23 = -4*image_in[183:176]; 
    wire [7:0] el24 = -3*image_in[191:184]; 
    wire [7:0] el25 = -1*image_in[199:192]; 

    assign pixel_out = el1 + el2 + el3 + el4 + el5 + el6 + el7 + el8 + el9 + el10 + el11 + el12 + el13 + el14 + el15 + el16 + el17 + el18 + el19 + el20 + el21 + el22 + el23 + el24 + el25;
    
endmodule
