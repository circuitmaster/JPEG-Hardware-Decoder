`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/26/2023 11:45:23 PM
// Design Name: 
// Module Name: register
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


module reg_bit(
input clk,
input rst,
input data_in,
output reg data_out
    );
    
 always@(posedge clk)begin
     if (rst) begin
        data_out <= 1'b0;
     end else begin
        data_out <= data_in;
     end
 end
endmodule
