module top_module #(
    parameter clk_frequency = 100000000, // 100 MHz clock
    parameter baud_rate = 9600 
)(

    input clk,
    input rx,rst_raw,
    output wire [7:0] rx_data, // Received data
    output wire rx_done, //flag
     
    output wire [3:0] anode, //Seven Segment ANODES
    output wire [6:0] segments, //Seven Segment Cathodes
    output wire dp  
    );
    
    wire rst;
    wire baud_tick;
    
//Instantiate Debounce Modules - disable(comment_out) for simulation  
       debounce_rst rst_module (clk,rst_raw,rst);
      
    //Instantiate baud rate generator
       baud_rate_generator #(clk_frequency,baud_rate) generator (clk,rst,baud_tick);
        
    // Instantiate receiver
        uart_receiver rx_module(clk,rst,baud_tick,rx,rx_done,rx_data);
             
    // Instantiate Seven Segment Module
        sevenSegment_display displayMod (clk,rst,rx_data,anode,segments,dp);
        
endmodule