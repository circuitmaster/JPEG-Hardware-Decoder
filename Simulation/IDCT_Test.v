`timescale 1ns / 1ps

module IDCT_Test;
    //Period of the clock
    localparam PERIOD = 100;
        
    //Registers given as input to the module
    reg clk = 1'b0, rst = 1'b0;
    reg s_valid;
    reg[511:0] data_in;

    //Outputs of the module
    wire[511:0] data_out;
    wire m_valid;
    
    //Change clock with given period
    always #(PERIOD/2) clk = ~clk;
    
    IDCT2 idct(
        .clk(clk),
        .rst(rst),
        .s_valid(s_valid),
        .data_in(data_in),
        .data_out(data_out),
        .m_valid(m_valid)
    );
    
    parameter [64*8-1:0] idct_params = {
        8'd0,  8'd0,  8'd0,  8'd0,  8'd0,  8'd0,  8'd0,  8'd0,
        8'd0,  8'd0,  8'd0,  8'd0,  8'd0,  8'd0,  8'd0,  8'd0,
        8'd0,  8'd0,  8'd0,  8'd0,  8'd0,  8'd0,  8'd0,  8'd0,
        8'd0,  8'd0,  8'd0,  8'd0,  8'd0,  8'd0,  8'd0,  8'd0,
        8'd0,  8'd0,  8'd0,  8'd0,  8'd0,  8'd0,  8'd0,  8'd0,
        8'd0,  8'd0,  8'd0,  8'd0,  8'd0,  8'd0,  -8'd13,  -8'd14,
        8'd0,  8'd0,  8'd0,  8'd0,  8'd0,  8'd14,  -8'd12,  8'd24,
        8'd0,  8'd0,  8'd0,  8'd0,  8'd0,  -8'd10,  8'd0,  -8'd80
    };
    
    integer i;
    initial begin
        //Reset Module
        @(posedge clk)
        rst = 1'b1;
        @(posedge clk)
        rst = 1'b0;
        
        s_valid <= 1'b1;
        for(i=0; i<512; i=i+1) begin
            data_in[i*8 +: 8] <= idct_params[i*8 +: 8];
        end
        @(posedge clk)
        s_valid <= 1'b1;
    end
    
endmodule
























