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
    inout[DATA_WIDTH-1:0] data
);
  
    // RAM
    reg[DATA_WIDTH-1:0] ram[2**ADDRESS_WIDTH-1:0];
    reg[DATA_WIDTH-1:0] data_out;
    
    //RAM signals
    assign data = (CE && !WE) ? data_out : {DATA_WIDTH{1'bz}};
    
    always @(posedge clk) begin
        if(rst) begin
            data_out <= {DATA_WIDTH{1'b0}};
        end else begin
            if(CE) begin
                if(WE) begin
                    ram[address] <= data;
                end
                
                data_out <= ram[address];
            end
        end
    end
  
endmodule
