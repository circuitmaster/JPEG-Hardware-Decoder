//////////////////////////////////////////////////////////////////////////////////
// Module Name: RAM
// Description: Generic RAM for multiple purposes
//////////////////////////////////////////////////////////////////////////////////
`timescale 1ns / 1ps

module RAM #(parameter SIZE=640) (
  input wire clk, 
  input wire [9:0] addr, //Indicates the adress to be written
  input wire [7:0] din, //Indicates the input data

  input wire wr_en, //RAM mode - write
  input wire rd_en, //RAM mode -read
  
  output reg [7:0] dout //Output of the RAM
);
  
  // Generic Memory Array
  reg [7:0] mem [SIZE-1:0];
  
  //For each clock tick
  always @(posedge clk) begin
    if (wr_en) begin
      mem[addr] <= din;
    end
  end
  
  //Whenever the input is changed
  always @* begin
    if (rd_en)
        dout <= mem[addr];
    else 
        dout <= 8'bz;
end
  
endmodule
