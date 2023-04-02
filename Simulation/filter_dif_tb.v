`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////


module filter_dif_tb;
    reg [199:0] image_in;
    
    wire [7:0] pixel_out;
    
    Filter_Median uut (image_in , pixel_out);
    
    initial begin
    // Initialize test inputs
    
    image_in [7:0] = 8'd1;
    image_in [15:8] = 8'd3;
    image_in [23:16] = 8'd5;
    image_in [31:24] = 8'd7;
    image_in [39:32] = 8'd9;
    image_in [47:40] = 8'd11;
    image_in [55:48] = 8'd13;
    image_in [63:56] = 8'd15;
    image_in [71:64] = 8'd17;
    image_in [79:72] = 8'd19;
        
    image_in [87:80] = 8'd21;
    image_in [95:88] = 8'd23;
    image_in [103:96] = 8'd0;
    image_in [111:104] = 8'd2;
    image_in [119:112] = 8'd4;
    image_in [127:120] = 8'd6;
    image_in [135:128] = 8'd8;
    image_in [143:136] = 8'd10;
    image_in [151:144] = 8'd12;
    image_in [159:152] = 8'd14;
        
    image_in [167:160] = 8'd16;
    image_in [175:168] = 8'd18;
    image_in [183:176] = 8'd20;
    image_in [191:184] = 8'd22;
    image_in [199:192] = 8'd24;

    
    
    end
endmodule
