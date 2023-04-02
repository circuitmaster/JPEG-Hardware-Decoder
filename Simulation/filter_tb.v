`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////


module filter_tb;
    reg [199:0] image_in;
    
    wire [7:0] pixel_out;
    
    edge_X uut (image_in , pixel_out);
    
    initial begin
    // Initialize test inputs
    
    image_in [7:0] = 8'd16;
    image_in [15:8] = 8'd16;
    image_in [23:16] = 8'd16;
    image_in [31:24] = 8'd16;
    image_in [39:32] = 8'd16;
    image_in [47:40] = 8'd16;
    image_in [55:48] = 8'd16;
    image_in [63:56] = 8'd16;
    image_in [71:64] = 8'd16;
    image_in [79:72] = 8'd16;
        
    image_in [87:80] = 8'd16;
    image_in [95:88] = 8'd16;
    image_in [103:96] = 8'd16;
    image_in [111:104] = 8'd16;
    image_in [119:112] = 8'd16;
    image_in [127:120] = 8'd16;
    image_in [135:128] = 8'd16;
    image_in [143:136] = 8'd16;
    image_in [151:144] = 8'd16;
    image_in [159:152] = 8'd16;
        
    image_in [167:160] = 8'd16;
    image_in [175:168] = 8'd16;
    image_in [183:176] = 8'd16;
    image_in [191:184] = 8'd16;
    image_in [199:192] = 8'd16;

    
    
    end
endmodule
