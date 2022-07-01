`timescale 1 ns / 1 ps

module draw_bug(
  input wire pclk,
  input wire reset,
  input wire [10:0] vcount_in,
  input wire vsync_in,
  input wire vblnk_in,
  input wire [10:0] hcount_in,
  input wire hsync_in,
  input wire hblnk_in,
  input wire [11:0] rgb_in,
  input wire [11:0] x_bugpos,
  input wire [11:0] y_bugpos,
  output reg [10:0] vcount_out,
  output reg vsync_out,
  output reg vblnk_out,
  output reg [10:0] hcount_out,
  output reg hsync_out,
  output reg hblnk_out,
  output reg [11:0] rgb_out
);

localparam HEIGHT = 200;
localparam WIDTH = 200;
localparam NEW_COLOR = 12'h8_4_8;

reg [11:0] rgb_out_nxt;

always @*
begin
    if((~vblnk_in) && (~hblnk_in))
    begin
        if(((vcount_in >= ypos) && (vcount_in < (HEIGHT + ypos))) && ((hcount_in >= xpos) && (hcount_in < (WIDTH + xpos))))
        begin
            rgb_out_nxt = NEW_COLOR;
        end
        else
        begin
            rgb_out_nxt = rgb_in;
        end
    end    
    else
    begin
        rgb_out_nxt = 12'h0_0_0;
    end
end

always @(posedge pclk)

    if(reset)
    begin
        vcount_out <= 0;
        vsync_out <= 0;
        vblnk_out <= 0;
        hcount_out <= 0;
        hsync_out <= 0;
        hblnk_out <= 0;
        rgb_out <= 0;
    end
    else
    begin
        vcount_out <= vcount_in;
        vsync_out <= vsync_in;
        vblnk_out <= vblnk_in;
        hcount_out <= hcount_in;
        hsync_out <= hsync_in;
        hblnk_out <= hblnk_in;
        rgb_out <= rgb_out_nxt;
    end

endmodule