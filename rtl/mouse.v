module mouse (
    inout [11:0] xpos,
    inout [11:0] ypos,
    input wire pclk,
    input wire rst_lck,
    input wire [10:0] vcount_in,
    input wire vsync_in,
    input wire vblnk_in,
    input wire [10:0] hcount_in,
    input wire hsync_in,
    input wire hblnk_in,
    input wire [11:0] rgb_in,
    output reg [10:0] vcount_out,
    output reg vsync_out,
    output reg vblnk_out,
    output reg [10:0] hcount_out,
    output reg hsync_out,
    output reg hblnk_out,
    output wire [11:0] rgb_out
);

    wire enable_mouse_display;
    wire [3:0] red_out, green_out, blue_out;

  MouseDisplay my_mousedispl (
    .xpos(xpos),
    .ypos(ypos),
    .pixel_clk(pclk),
    .hcount(hcount_in),
    .vcount(vcount_in),
    .blank(hblnk_in || vblnk_in),
    .red_in(rgb_in[11:8]),
    .green_in(rgb_in[7:4]),
    .blue_in(rgb_in[3:0]),
    .enable_mouse_display_out(enable_mouse_display),
    .red_out(red_out),
    .green_out(green_out),
    .blue_out(blue_out)
  );

assign rgb_out = {red_out, green_out, blue_out};

always @(posedge pclk)
begin
    if(rst_lck)
    begin
      vsync_out <= 0;
      vcount_out <= 0;
      vblnk_out <= 0;
      hsync_out <= 0;
      hcount_out <= 0;
      hblnk_out <= 0;
    end
    else
    begin
      vsync_out <= vsync_in;
      vcount_out <= vcount_in;
      vblnk_out <= vblnk_in;
      hsync_out <= hsync_in;
      hcount_out <= hcount_in;
      hblnk_out <= hblnk_in;
    end
end

endmodule