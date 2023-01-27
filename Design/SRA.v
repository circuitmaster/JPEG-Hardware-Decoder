`timescale 1ns / 1ps

//This is the main Clock module
module SRA(In_A,In_B,data_out);

//Inputs(Data,Selection,Carry,Clock)
input [7:0]In_A;
input [7:0]In_B;

//Outputs
output reg [7:0]data_out;

always@(*)
begin

case(In_B)
        32'd0:
        begin
            data_out = In_A;
        end
        32'd1:
        begin
            data_out =  {In_A [7] ,  In_A [7:1]};
        end
        32'd2:
        begin
            data_out =  {{2{In_A [7]}} ,  In_A [7:2]};
        end
        32'd3:
        begin
            data_out =  {{3{In_A [7]}} ,  In_A [7:3]};
        end
        32'd4:
        begin
            data_out =  {{4{In_A [7]}} ,  In_A [7:4]};
        end
        32'd5:
        begin
            data_out =  {{5{In_A [7]}} ,  In_A [7:5]};
        end
        32'd6:
        begin
            data_out =  {{6{In_A [7]}} ,  In_A [7:6]};
        end
        32'd7:
        begin
            data_out =  {8{In_A [7]}};
        end
        32'd8:
        begin
            data_out =  8'b0;
        end

        default:
        begin
            data_out = {32{In_A[7]}};
        end
endcase
end
endmodule
