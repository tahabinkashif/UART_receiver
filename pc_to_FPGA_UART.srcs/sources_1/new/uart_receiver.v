module uart_receiver(
    input wire clk,           // Clock input
    input wire reset,         //Debounced reset
    input wire baud_tick,     //Tick at 16x baud_rate
    input wire rx,            // Serial input
    output reg rx_done,       // Reception complete flag
    output reg [7:0] rx_data  // Received data
);

 // State definitions
    localparam IDLE = 2'b00;   //rx is 1, moves to START at rx falling edge
    localparam START = 2'b01;  // waits for 8 ticks and moves to DATA
    localparam DATA = 2'b10;   // samples rx to data_reg after 16 baud_ticks, 8 bits
    localparam STOP = 2'b11;   // waits for 16 baud_ticks at rx = 1 and moves to IDLE
 
 //Internal Signals   
    reg [1:0] state;
    reg [3:0] ticks_counter;
    reg [2:0] bit_count;
    reg [7:0] data_reg;
    reg rx_synced, rx_temp;   // For synchronization
    
 // Synchronize rx to avoid metastability
    always @(posedge clk) begin
        rx_temp <= rx;
        rx_synced <= rx_temp;
    end
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            ticks_counter <= 0;
            bit_count <= 0;
            data_reg <= 0;
            rx_done <= 0;
            rx_data <= 8'hFF;  //received data resets to 11111111
        end else begin
            case (state)
                IDLE: begin
                    rx_done <= 0;
                    ticks_counter <= 0;
                    bit_count <= 0;
                    
                    // Detect start bit
                    if (rx_synced == 0) begin
                        state <= START;
                    end
                end
                
                START: begin
                    // Start Sample in the middle of start bit
                    if (baud_tick) begin
                        if (ticks_counter == 7) begin
                            // Confirm it's still low in the middle of start bit
                            if (rx_synced == 0) begin
                                ticks_counter <= 0;
                                state <= DATA;
                            end else begin
                                // False start bit - stays in IDLE state
                                state <= IDLE;
                            end
                        end else begin
                            ticks_counter <= ticks_counter + 1;
                        end
                    end
                end
                
                DATA: begin
                    if (baud_tick) begin
                        if (ticks_counter == 15) begin
                            // Sample in the middle of data bit
                            ticks_counter <= 0;
                            data_reg <= {rx_synced, data_reg[7:1]};  // Shift right and add new bit
                            
                            if (bit_count == 7) begin
                                bit_count <= 0;
                                state <= STOP;
                            end else begin
                                bit_count <= bit_count + 1;
                            end
                        end else begin
                            ticks_counter <= ticks_counter + 1;
                        end
                    end
                end
                
                STOP: begin
                    if (baud_tick) begin
                        if (ticks_counter == 15) begin
                            // Check for valid stop bit
                            if (rx_synced == 1) begin
                                rx_data <= data_reg;
                                rx_done <= 1;
                            end
                            state <= IDLE;
                        end else begin
                            ticks_counter <= ticks_counter + 1;
                        end
                    end
                end
                
                default: state <= IDLE;
            endcase
        end
    end

endmodule