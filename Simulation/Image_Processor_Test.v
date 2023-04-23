`timescale 1ns / 1ps

module Image_Processor_Test;
    //Commands(Big-Endian)
    localparam HEADER = 16'hCDBA;
    localparam EDGE_DETECTION = 16'h10A0;    
    localparam EDGE_ENHANCEMENT = 16'h20A0;    
    localparam NOISE_FILTERING = 16'h30A0;    
    localparam HISTOGRAM_STATISTICS = 16'h40A0;    
    localparam HISTOGRAM_EQUALIZATION = 16'h50A0;    
    localparam BOUNDARY_EXTRACTION = 16'h60A0;  
    
    //Control Parameters
    localparam COMMAND = EDGE_DETECTION;
    localparam ENCODED_IMAGE_FILE_PATH = "EncodedImage.txt";
    localparam OUTPUT_FILE_PATH = "ImageProcessorOutput.txt";
    localparam IMAGE_RAM_FILE_PATH = "ImageRam.txt";
    localparam HISTOGRAM_RAM_FILE_PATH = "HistogramRam.txt";

    //Period of the clock and parameters
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
    
    //Test Module
    Image_Processor #(
        .CLK_FREQ(1_000_000_000/PERIOD),
        .BAUD_RATE(BAUD_RATE)
    ) image_processor(
        .clk(clk), 
        .rst(rst),
        .rx(rx),
        .tx(tx)
    );
    
    //Helper Variables
    integer encoded_image_file, output_file;
    integer image_ram_file, histogram_ram_file;
    integer char, char_count, i, j, k, m;
    reg[7:0] byte;
    
    initial begin
        //Reset Module
        @(posedge clk)
        rst = 1'b1;
        @(posedge clk)
        rst = 1'b0;
        
        //Open Files
        encoded_image_file = $fopen(ENCODED_IMAGE_FILE_PATH, "r");
        output_file = $fopen(OUTPUT_FILE_PATH, "w");
        image_ram_file = $fopen(IMAGE_RAM_FILE_PATH, "w");
        histogram_ram_file = $fopen(HISTOGRAM_RAM_FILE_PATH, "w");
        
        //Send Header and Command
        send_2byte_to_uart(HEADER);
        send_2byte_to_uart(COMMAND);
        
        //Send Encoded Image
        while (!$feof(encoded_image_file)) begin
            get_byte_from_file(encoded_image_file, byte);
            send_byte_to_uart(byte);
        end
        
        //Wait until image filtered or histogram generated
        while(!((COMMAND != HISTOGRAM_STATISTICS && image_processor.filter.filter_controller.image_filtered == 1) ||
              (COMMAND == HISTOGRAM_STATISTICS && image_processor.filter.filter_controller.state == 6))) begin
            #1;
        end
        
        //Write image RAM to file
        for(i=0; i<image_processor.IMAGE_HEIGHT; i=i+1) begin
            for(j=0; j<image_processor.IMAGE_WIDTH; j=j+1) begin
                $fwriteh(image_ram_file, image_processor.image_ram.ram[j+i*image_processor.IMAGE_WIDTH]);
                $fwrite(image_ram_file, " ");
             end
            $fdisplay(image_ram_file);
        end
        $fclose(image_ram_file);  
        
        //Write histogram RAM to file
        for(i=0; i<2**image_processor.HISTOGRAM_RAM_ADDRESS_WIDTH; i=i+1) begin
            $fwriteh(histogram_ram_file, image_processor.histogram_ram.ram[i]);
            $fdisplay(histogram_ram_file);
        end
        $fclose(histogram_ram_file);  

        //Receive Image Processor Output From UART
        if(COMMAND == HISTOGRAM_STATISTICS) begin
            for(i=0; i<2**image_processor.HISTOGRAM_RAM_ADDRESS_WIDTH; i=i+1) begin
                get_byte_from_uart(byte);
                $fwriteh(output_file, byte);
                $fdisplay(output_file);
            end
        end else begin
            for(i=0; i<image_processor.IMAGE_HEIGHT; i=i+1) begin
                for(j=0; j<image_processor.IMAGE_WIDTH; j=j+1) begin
                    get_byte_from_uart(byte);
                    $fwriteh(output_file, byte);
                    $fwrite(output_file, " ");
                end
                $fdisplay(output_file);
            end
        end
        
        $fclose(encoded_image_file);  
        $fclose(output_file);  
    end
    
    task get_byte_from_file(input integer file, output[7:0] byte);
    begin
        char_count = 0;
        char = 0;
        while(char_count < 8 && char != -1) begin
            char = $fgetc(file);
            if(char == "1") begin
                byte[char_count] = 1'b1;
                char_count = char_count+1;
            end
            if(char == "0") begin
                byte[char_count] = 1'b0;
                char_count = char_count+1;
            end
        end
    end
    endtask
    
    task send_2byte_to_uart(input[15:0] bytes);
    begin
        send_byte_to_uart(bytes[15:8]);
        send_byte_to_uart(bytes[7:0]);
    end
    endtask

    task send_byte_to_uart(input[7:0] byte);
    begin
        //Wait for stop signal
        for(i=0; i<TIMER_LIMIT; i=i+1) begin
            @(posedge clk);
        end

        //Start bit
        send_bit_to_uart(1'b0);
        
        //Data bit
        for(i=0; i<8; i=i+1) begin
            send_bit_to_uart(byte[i]);
        end
        
        //Pull back to 1
        rx = 1'b1;
    end
    endtask
    
    task send_bit_to_uart(input bit);
    begin
        for(j=0; j<TIMER_LIMIT; j=j+1) begin
            rx = bit;
            @(posedge clk);
        end
    end
    endtask
    
    task get_byte_from_uart(output[7:0] byte);
    begin
        while(tx != 1'b0)
            #1
    
        for(k=0; k<TIMER_LIMIT/2-1; k=k+1) begin
            @(posedge clk);
        end
    
        for(m=0; m<8; m=m+1) begin
            byte[m] = tx;
            for(k=0; k<TIMER_LIMIT; k=k+1) begin
                @(posedge clk);
            end
        end
        
        for(k=0; k<TIMER_LIMIT/2+10; k=k+1) begin
            @(posedge clk);
        end
    end
    endtask

endmodule























