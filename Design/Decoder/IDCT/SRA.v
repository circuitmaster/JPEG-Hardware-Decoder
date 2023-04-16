`timescale 1ns / 1ps

//This is the main Clock module
module SRA(In_A,In_B,data_out);

//Inputs
input [31:0]In_A;
input [4:0]In_B;

//Outputs
output reg [31:0]data_out;

always@(*)
begin

case(In_B)
        5'd0:
        begin
            data_out = In_A;
        end
        5'd1:
        begin
            data_out =  {In_A [31] ,  In_A [31:1]};
        end
        5'd2:
        begin
            data_out =  {{2{In_A [31]}} ,  In_A [31:2]};
        end
        5'd3:
        begin
            data_out =  {{3{In_A [31]}} ,  In_A [31:3]};
        end
        5'd4:
        begin
            data_out =  {{4{In_A [31]}} ,  In_A [31:4]};
        end
        5'd5:
        begin
            data_out =  {{5{In_A [31]}} ,  In_A [31:5]};
        end
        5'd6:
        begin
            data_out =  {{6{In_A [31]}} ,  In_A [31:6]};
        end
        5'd7:
        begin
            data_out =  {{7{In_A [31]}} ,  In_A [31:7]};
        end
        5'd8:
        begin
            data_out =  {{8{In_A [31]}} ,  In_A [31:8]};
        end
        5'd9:
        begin
            data_out =  {{9{In_A [31]}} ,  In_A [31:9]};
        end
        5'd10:
        begin
            data_out =  {{10{In_A [31]}} ,  In_A [31:10]};
        end
        5'd11:
        begin
            data_out =  {{11{In_A [31]}} ,  In_A [31:11]};
        end
        5'd12:
        begin
            data_out =  {{12{In_A [31]}} ,  In_A [31:12]};
        end
        5'd13:
        begin
            data_out =  {{13{In_A [31]}} ,  In_A [31:13]};
        end
        5'd14:
        begin
            data_out =  {{14{In_A [31]}} ,  In_A [31:14]};
        end
        5'd15:
        begin
            data_out =  {{15{In_A [31]}} ,  In_A [31:15]};
        end
        5'd16:
        begin
            data_out =  {{16{In_A [31]}} ,  In_A [31:16]};
        end
        5'd17:
        begin
            data_out =  {{17{In_A [31]}} ,  In_A [31:17]};
        end
        5'd18:
        begin
            data_out =  {{18{In_A [31]}} ,  In_A [31:18]};
        end
        5'd19:
        begin
            data_out =  {{19{In_A [31]}} ,  In_A [31:19]};
        end
        5'd20:
        begin
            data_out =  {{20{In_A [31]}} ,  In_A [31:20]};
        end
        5'd21:
        begin
            data_out =  {{21{In_A [31]}} ,  In_A [31:21]};
        end
        5'd22:
        begin
            data_out =  {{22{In_A [31]}} ,  In_A [31:22]};
        end
        5'd23:
        begin
            data_out =  {{23{In_A [31]}} ,  In_A [31:23]};
        end
        5'd24:
        begin
            data_out =  {{24{In_A [31]}} ,  In_A [31:24]};
        end
        5'd25:
        begin
            data_out =  {{25{In_A [31]}} ,  In_A [31:25]};
        end
        5'd26:
        begin
            data_out =  {{26{In_A [31]}} ,  In_A [31:26]};
        end
        5'd27:
        begin
            data_out =  {{27{In_A [31]}} ,  In_A [31:27]};
        end
        5'd28:
        begin
            data_out =  {{28{In_A [31]}} ,  In_A [31:28]};
        end
        5'd29:
        begin
            data_out =  {{29{In_A [31]}} ,  In_A [31:29]};
        end
        5'd30:
        begin
            data_out =  {{30{In_A [31]}} ,  In_A [31:30]};
        end
        5'd31:
        begin
            data_out =  {{31{In_A [31]}} ,  In_A [31:31]};
        end
        default:
        begin
            data_out = {32{In_A[31]}};
        end
endcase
end
endmodule
