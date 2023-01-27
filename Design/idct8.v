`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/26/2023 11:49:42 PM
// Design Name: 
// Module Name: idct8
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


module idct8(
input clk,
input s_valid,
input[255:0] data_in,
output[255:0] data_out,
output  m_valid
    );
    
    reg [7:0] in0_c4, in1_c7, in1_c1, in2_c6, in2_c2, in3_c3, in3_c5, in4_c4, in5_c3, in5_c5, in6_c6, in6_c2, in7_c7, in7_c1;
    
    idct_mul mul0(data_in[63:0], in0_c4, in1_c7, in1_c1, in2_c6, in2_c2, in3_c3, in3_c5, in4_c4, in5_c3, in5_c5, in6_c6, in6_c2, in7_c7, in7_c1);
    
    
    
    
endmodule
