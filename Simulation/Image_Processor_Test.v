`timescale 1ns / 1ps

module Image_Processor_Test;
    //Period of the clock
    localparam PERIOD = 100;
    localparam BAUD_RATE = 115_200;
    localparam TIMER_LIMIT = 1_000_000_000/(BAUD_RATE*PERIOD);
        
    //Registers given as input to the module
    reg clk = 1'b0, rst = 1'b0;
    reg rx;
    
    //Outputs of the module
    wire tx;
    
    //Change clock with given period
    always #(PERIOD/2) clk = ~clk;
    
    Image_Processor image_processor(
        .clk(clk), 
        .rst(rst),
        .rx(rx),
        .tx(tx)
    );
    
    integer fd, i;
    reg[7:0] line;
    initial begin
        //Reset Module
        @(posedge clk)
        rst <= 1'b1;
        @(posedge clk)
        rst <= 1'b0;
        
        fd = $fopen("ImageProcessorTest.txt", "r");  
        
        while (!$feof(fd)) begin
            $fgets(line, fd);
            
            for(i=0; i<8; i=i+1) begin
                send_byte(line);
                @(posedge clk);
            end
        end
        
        $fclose(fd);  
    end
    
    task send_byte(input[7:0] byte);
    begin
        send_bit(1'b0);
        for(i=0; i<8; i=i+1) begin
            send_bit(byte[i]);
        end
        send_bit(1'b1);
        
        for(i=0; i<10; i=i+1) begin
            @(posedge clk);
        end
    end
    endtask
    
    task send_bit(input bit);
    begin
        for(i=0; i<TIMER_LIMIT; i=i+1) begin
            rx <= bit;
            @(posedge clk);
        end
    end
    endtask

endmodule























