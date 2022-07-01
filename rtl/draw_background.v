`timescale 1 ns / 1 ps

module draw_background (
  input wire pclk,
  input wire reset,
  input wire [10:0] vcount_in,
  input wire vsync_in,
  input wire vblnk_in,
  input wire [10:0] hcount_in,
  input wire hsync_in,
  input wire hblnk_in,
  output reg [10:0] vcount_out,
  output reg vsync_out,
  output reg vblnk_out,
  output reg [10:0] hcount_out,
  output reg hsync_out,
  output reg hblnk_out,
  output reg [11:0] rgb_out
);

reg [11:0] rgb_out_nxt;

  always @(*)
  begin
    // During blanking, make it it black.
    if (vblnk_in || hblnk_in) rgb_out_nxt = 12'h0_0_0; 
    else
    begin
      // Active display, top edge, make a yellow line.
      if (vcount_in == 0) rgb_out_nxt = 12'hf_f_0;
      // Active display, bottom edge, make a red line.
      else if (vcount_in == 599) rgb_out_nxt = 12'hf_0_0;
      // Active display, left edge, make a green line.
      else if (hcount_in == 0) rgb_out_nxt = 12'h0_f_0;
      // Active display, right edge, make a blue line.
      else if (hcount_in == 799) rgb_out_nxt = 12'h0_0_f;
      // Active display, interior, fill with gray.
      // You will replace this with your own test.

      else rgb_out_nxt = 12'hf_f_f;    
     end
  end

    always@(posedge pclk)
      if (reset)
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