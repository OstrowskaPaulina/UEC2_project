`timescale 1 ns / 1 ps

module clock_rst (
  input wire pclk,
  input wire locked,
  output reg rst_out
);

reg [3:0] counter, counter_nxt;
reg rst_tmp;

always @(*)
    begin
    if(locked)
        counter_nxt = (counter << 1);
    else
        counter_nxt = 0;
    end

always @(posedge pclk or negedge locked)
    begin
    if(!locked)
     begin
        counter <= 4'b1111;
    end
    else
    begin
        counter <= counter_nxt;
    end
    rst_tmp <= counter[3];
    rst_out <= rst_tmp;
    end
    
endmodule