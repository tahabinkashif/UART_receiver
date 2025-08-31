module sevenSegment_display (
    input wire clk, rst,             // 100MHz clock
    input wire [7:0] num,        // 8-bit input number (0-255)
    output reg [3:0] anode,    // Anode signals (active low)
    output reg [6:0] cathode,   // Cathode segments (active low) 
    output reg dp //decimal point
);

//  Internal Signals
    reg [19:0] clkCount;
    reg [1:0] digitSelect;  //next digit after 4ms (16ms - refresh rate)
    reg [6:0] cathodeArray[3:0];
    wire [3:0] hundreds,tens,ones;


localparam first = 2'b00,
           second = 2'b01,
           third  = 2'b10,
           fourth = 2'b11;

//Binary to BCD module instantiation
  binary_to_bcd getBCD(num, hundreds,tens,ones);

// stores cathode (segments) for each digit temporarily
always@* begin
  cathodeArray[0] = segment_pattern(ones);
  cathodeArray[1] = segment_pattern(tens);
  cathodeArray[2] = segment_pattern(hundreds);
  cathodeArray[3] = 7'b1111111;
end

//reset + digitSelect (Selects Next Digit after 4ms)
always@(posedge clk, posedge rst) begin
    if(rst) begin
        digitSelect <= 2'b0;
        clkCount <= 20'b0;
        end
    else if(clkCount == 400000) begin
              digitSelect <= digitSelect +1;
              clkCount <= 20'b0;
         end
      else begin
         clkCount <= clkCount +1;
         end
    end

//outputs cathode(segments) and anode values for each digit
always@* begin
    dp = 1'b1;
    case(digitSelect)
        first: 
            begin
                cathode = cathodeArray[0];
                anode = 4'b1110;
            end 
         second: 
            begin
                 cathode = cathodeArray[1];
                 anode = 4'b1101;
            end
         third: 
            begin
                  cathode = cathodeArray[2];
                  anode = 4'b1011;
            end 
         fourth: 
            begin
                  cathode = cathodeArray[3];
                  anode = 4'b0111;
            end            
        endcase
end

//Function to Assign Cathode(segment) Values
function [6:0] segment_pattern;
        input [3:0] bcd;
        begin
            case (bcd)
                4'd0: segment_pattern = 7'b0000001; // 0
                4'd1: segment_pattern = 7'b1001111; // 1
                4'd2: segment_pattern = 7'b0010010; // 2
                4'd3: segment_pattern = 7'b0000110; // 3
                4'd4: segment_pattern = 7'b1001100; // 4
                4'd5: segment_pattern = 7'b0100100; // 5
                4'd6: segment_pattern = 7'b0100000; // 6
                4'd7: segment_pattern = 7'b0001111; // 7
                4'd8: segment_pattern = 7'b0000000; // 8
                4'd9: segment_pattern = 7'b0000100; // 9
                default: segment_pattern = 7'b1111111; // Blank
            endcase
        end
    endfunction
endmodule


module binary_to_bcd (
    input [7:0] binary,
    output reg [3:0] hundreds,
    output reg [3:0] tens,
    output reg [3:0] ones
);

    integer i;
    reg [19:0] shift_reg; // 8 bits binary + 12 bits BCD

    always @(*) begin
        // Initialize shift register
        shift_reg = 20'b0;
        shift_reg[7:0] = binary;

        // Perform 8 iterations
        for (i = 0; i < 8; i = i + 1) begin
            // Check each BCD digit and add 3 if >= 5
            if (shift_reg[11:8] >= 5)
                shift_reg[11:8] = shift_reg[11:8] + 3;
            if (shift_reg[15:12] >= 5)
                shift_reg[15:12] = shift_reg[15:12] + 3;
            if (shift_reg[19:16] >= 5)
                shift_reg[19:16] = shift_reg[19:16] + 3;

            // Shift left
            shift_reg = shift_reg << 1;
        end

        // Assign final BCD digits
        ones    = shift_reg[11:8];
        tens    = shift_reg[15:12];
        hundreds= shift_reg[19:16];
    end

endmodule
