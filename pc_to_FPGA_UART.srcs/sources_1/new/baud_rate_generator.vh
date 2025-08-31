module baud_rate_generator #(
    parameter clk_frequency = 100000000, // 100 MHz clock
    parameter baud_rate = 9600        // 9600 bps baud rate
)(
    input wire clk,           // Input clock
    input wire reset,      
    output reg baud_tick      // Tick at baud rate
);

    // Calculate the counter limit based on clock frequency and baud rate
    localparam integer divisor = 651;       //  clk_frequency / (baud_rate * 16)
    localparam integer width = 10;//10 bits     //  $clog2(divisor)
    
    // Counter to generate baud rate
    reg [width-1:0] counter;
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            counter <= 0;
            baud_tick <= 0;
        end else begin
            if (counter == divisor - 1) begin
                counter <= 0;
                baud_tick <= 1;
            end else begin
                counter <= counter + 1;
                baud_tick <= 0;
            end
        end
    end

endmodule
