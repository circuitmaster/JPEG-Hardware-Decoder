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
    
    Image_Processor #(
        .CLK_FREQ(1_000_000_000/PERIOD),
        .BAUD_RATE(BAUD_RATE)
    ) image_processor(
        .clk(clk), 
        .rst(rst),
        .rx(rx),
        .tx(tx)
    );
    
    
    integer file, char, char_count, i, j;
    reg[7:0] line;
    
    initial begin
        //Reset Module
        @(posedge clk)
        rst = 1'b1;
        @(posedge clk)
        rst = 1'b0;
        
        file = $fopen("ImageProcessorTest.txt", "r");  
        while (!$feof(file)) begin
            get_byte();
            
            for(i=0; i<8; i=i+1) begin
                send_byte(line);
                @(posedge clk);
            end
        end
        
        file = $fopen("ImageProcessorImageRam.txt", "w");
        for(i=0; i<2**image_processor.IMAGE_RAM_ADDRESS_WIDTH; i=i+1) begin
            $fwriteh(file, image_processor.image_ram.ram[i]);
        end
        
        $fclose(file);  
    end
    
    task get_byte();
    begin
        char_count = 0;
        while(char_count < 8) begin
            char = $fgetc(file);
            if(char == "1") begin
                line[char_count] = 1'b1;
                char_count = char_count+1;
            end
            if(char == "0") begin
                line[char_count] = 1'b0;
                char_count = char_count+1;
            end
        end
    end
    endtask
    
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
        for(j=0; j<TIMER_LIMIT; j=j+1) begin
            rx = bit;
            @(posedge clk);
        end
    end
    endtask

endmodule























