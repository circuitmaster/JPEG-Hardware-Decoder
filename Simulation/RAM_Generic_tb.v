`timescale 1ns / 1ps


module RAM_Generic_tb;
  reg clk;
  reg [9:0] addr;
  reg [7:0] din;
 
  reg wr_en;
  reg rd_en;


  wire [7:0] dout;
   
  RAM #(1024) uut (clk, addr, din, wr_en, rd_en,dout);

  initial begin
    // Initialize test inputs
    clk = 0;
    wr_en = 0;
    rd_en = 0;
    addr = 0;
    din = 0;

    // Test loop
    forever begin
        // Toggle clock
        #50 clk = ~clk;
        // Randomize inputs
        if (clk) begin
            wr_en = $random;
            rd_en = $random;
            addr = $random % 1024;
            din = $random % 256;
        end
    end
  end
endmodule