`timescale 1ns / 1ps

module idct8_Test;
    //Period of the clock
    localparam PERIOD = 10;


    
    //Registers given as input to the module
    reg clk = 1'b0, rst = 1'b0;
    reg s_valid = 1'b0;
    reg [255:0] data_in; 
    reg [4:0] shift_amount = 5'd11;
    
    //Outputs of the module
    wire m_valid;
    wire [255:0] data_out;
    
    //Change clock with given period
    always #(PERIOD/2) clk = ~clk;
   
    idct8 
idct(
        .clk(clk), 
        .rst(rst),
        .s_valid(s_valid),
        .data_in(data_in),
        .shift_amount(shift_amount),
        .data_out(data_out),
        .m_valid(m_valid)
    );

    initial begin
        //Reset Module
        @(posedge clk)
        rst <= 1'b1;
        @(posedge clk)
        rst <= 1'b0;
        
        data_in <= {32'd100, 32'd100, 32'd100, 32'd100, 32'd100, 32'd100, 32'd100 ,32'd100};
        s_valid <= 1'b1;
        @(posedge clk);
        s_valid <= 1'b0;
    end
    
endmodule
















