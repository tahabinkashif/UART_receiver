module debounce_rst(
    input  wire clk,        // system clock
    input  wire rst_raw,    // raw button input from FPGA pin
    output reg  rst_debounced         // LED output
);

    // Step 1: Synchronize button to avoid metastability
    reg btn_sync_0, btn_sync_1;
    always @(posedge clk) begin
        btn_sync_0 <= rst_raw;
        btn_sync_1 <= btn_sync_0;
    end

    // Step 2: Debounce the button
    reg [19:0] counter;  // adjust width for debounce time
    reg btn_stable;
    
    
     initial
       begin
       btn_sync_0 = 1'b0;
       btn_sync_1 = 1'b0;
       counter = 20'b0;
       btn_stable = 1'b0;
       end  

    always @(posedge clk) begin
        if (btn_sync_1 != btn_stable) begin
            counter <= counter + 1;
            if (counter == 20'hFFFFF) begin
                btn_stable <= btn_sync_1;
                counter <= 0;
            end
        end else begin
            counter <= 0;
        end
    end

    // Step 3: LED follows the debounced button
    always @(posedge clk) begin
        rst_debounced <= btn_stable;
    end

endmodule
