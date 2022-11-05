

//DESIGN:
module andgate( output OUT, input IN1, input IN2, input IN3);

assign OUT = IN1 & IN2 & IN3;

endmodule





//TESTBENCH:
`timescale 1ns / 1ps

module andgate_tb();

wire OUT;
reg IN1,IN2,IN3;

andgate A1(OUT, IN1, IN2, IN3);

initial
begin
	$monitor(" IN=%b %b %b  | OUT = %b",IN1,IN2,IN3,OUT);
	IN1 = 0; IN2 = 0; IN3 = 0;
	#10 IN1 = 0; IN2 = 0; IN3 = 1;
	#10 IN1 = 0; IN2 = 1; IN3 = 0;
	#10 IN1 = 0; IN2 = 1; IN3 = 1;
	#10 IN1 = 1; IN2 = 0; IN3 = 0;
	#10 IN1 = 1; IN2 = 0; IN3 = 1;
	#10 IN1 = 1; IN2 = 1; IN3 = 0;
	#10 IN1 = 1; IN2 = 1; IN3 = 1;
	#10 $finish;
end
endmodule