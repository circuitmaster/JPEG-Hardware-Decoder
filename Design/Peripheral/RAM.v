//////////////////////////////////////////////////////////////////////////////////
// Module Name: RAM
// Description: Generic RAM for multiple purposes
//////////////////////////////////////////////////////////////////////////////////

`timescale 1ns / 1ps

module RAM 
#(
    parameter DATA_WIDTH = 8,
    parameter ADDRESS_WIDTH = 16
)(
    input clk, rst,
    input WE,
    input CE,
    input[ADDRESS_WIDTH-1:0] address,
    input[DATA_WIDTH-1:0] data_input,
    output reg[DATA_WIDTH-1:0] data_output
);
  
    // RAM
    reg[DATA_WIDTH-1:0] ram[2**ADDRESS_WIDTH-1:0];

    integer i;
    initial begin
        for(i=0; i<2**ADDRESS_WIDTH; i=i+1) begin
            ram[i] <= {DATA_WIDTH{1'b0}};
        end
    end
    
    always @(posedge clk) begin
        if(rst) begin
            data_output <= {DATA_WIDTH{1'b0}};
        end else begin
            if(CE) begin
                if(WE) begin
                    ram[address] <= data_input;
                end
                
                data_output <= ram[address];
            end
        end
    end
  
endmodule
