`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Module Name: Rounder
// Description: Performs Rounding(Float to Integer)
//////////////////////////////////////////////////////////////////////////////////
module Rounder (
  input [31:0] x, //Input
  output reg [31:0] y //Output
);

  reg [30:0] frac; // Fractional part of the input
  reg carry; // Carry bit

//Main loop
  always @* begin
  // Check if the input's fractional part is greater than or equal to 0.5
    if (x[30:0] >= 2**30) begin
      frac = x[30:0] - 2**30;
      carry = 1;
    end else begin
      frac = x[30:0];
      carry = 0;
    end

    // If the fractional part is greater than or equal to 0.5, round up
    if (carry == 1) begin
      if (frac[0] == 1) begin
        y = {x[31], (frac >> 1) + 1}; //Remove fractional part and add 1 
      end else begin
        y = {x[31], frac >> 1};
      end
      //If smaller, just remove fractional part
    end else begin
      y = {x[31], frac >> 1};
    end
  end

endmodule