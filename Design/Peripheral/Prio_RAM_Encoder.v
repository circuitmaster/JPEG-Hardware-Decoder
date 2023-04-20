//////////////////////////////////////////////////////////////////////////////////
// Module Name: Prio_RAM_Encoder
// Description: Generic RAM for multiple purposes
//////////////////////////////////////////////////////////////////////////////////

`timescale 1ns / 1ps

module Prio_RAM_Encoder 
#(
    parameter DATA_WIDTH = 8,
    parameter ADDRESS_WIDTH = 16
)(
    input WE1_input, WE2_input,
    input CE1_input, CE2_input,
    input[ADDRESS_WIDTH-1:0] address1_input, address2_input,
    inout[DATA_WIDTH-1:0] data1_input, data2_input,
    inout[DATA_WIDTH-1:0] data_output,
    output WE_output,
    output CE_output,
    output[ADDRESS_WIDTH-1:0] address_output,
    output is_RAM_available
);

    assign WE_output = CE1_input ? WE1_input : WE2_input;
    assign CE_output = CE1_input ? CE1_input : CE2_input;
    assign address_output = CE1_input ? address1_input : address2_input;
    assign is_RAM_available = !CE1_input;

    assign data1_input = CE1_input && !WE1_input ? data_output : {DATA_WIDTH{1'bZ}};
    assign data2_input = CE2_input && !WE2_input ? data_output : {DATA_WIDTH{1'bZ}};
    assign data_output = CE1_input && WE1_input ? data1_input : 
                         !CE1_input && CE2_input && WE2_input ? data2_input :
                         {DATA_WIDTH{1'bZ}};
endmodule
























