
// The `timescale directive specifies what the
// simulation time units are (1 ns here) and what
// the simulator time step should be (1 ps here).

`timescale 1 ns / 1 ps

// Declare the module and its ports. This is
// using Verilog-2001 syntax.

module main (
  input wire clk,
  input wire rst,
  output wire vs,
  output wire hs,
  output wire [3:0] r,
  output wire [3:0] g,
  output wire [3:0] b,
  output wire pclk_mirror,
  inout ps2_clk,
  inout ps2_data
  );

  wire pclk;
  wire pclk_mouse;
  wire locked;
  wire rst_lck;

  clk_wiz_0 my_clock (
    .clk(clk),
    .clk100MHz(pclk_mouse),
    .clk40MHz(pclk),
    .reset(rst),
    .locked(locked)
  );

    clock_rst my_clock_rst (
     .pclk(pclk),
     .rst_out(rst_lck),  
     .locked(locked)    
    );

  ODDR pclk_oddr (
    .Q(pclk_mirror),
    .C(pclk),
    .CE(1'b1),
    .D1(1'b1),
    .D2(1'b0),
    .R(1'b0),
    .S(1'b0)
  );

  wire [10:0] vcount, hcount;
  wire vsync, hsync;
  wire vblnk, hblnk;

  wire [10:0] vcount_out_bg, hcount_out_bg, vcount_out_rec, hcount_out_rec, vcount_out_disp, hcount_out_disp;
  wire vsync_out_bg, hsync_out_bg, vsync_out_rec, hsync_out_rec, vsync_out_disp, hsync_out_disp;
  wire vblnk_out_bg, hblnk_out_bg, vblnk_out_rec, hblnk_out_rec,vblnk_out_disp, hblnk_out_disp;
  wire [11:0] rgb_out_bg, rgb_out_rec, rgb_out_disp;
  wire [11:0] xpos, xpos_disp, ypos, ypos_disp;
  wire [11:0] x_bugpos, y_bugpos;

  MouseCtl my_mousectl (
    .xpos(xpos),
    .ypos(ypos),
    .ps2_clk(ps2_clk),
    .ps2_data(ps2_data),
    .clk(pclk_mouse),
    .rst(rst_lck),

    .value(12'b0),
    .setx(1'b0),
    .sety(1'b0),
    .setmax_x(1'b0),
    .setmax_y(1'b0)
  );

  timing my_timing (
    .vcount(vcount),
    .vsync(vsync),
    .vblnk(vblnk),
    .hcount(hcount),
    .hsync(hsync),
    .hblnk(hblnk),
    .pclk(pclk),
    .reset(rst_lck)
  );
  
    wire [11:0] rgb_pixel;
    wire [11:0] addr;

 image_rom my_image_rom(
     .clk(pclk),
     .address(addr),
     .rgb(rgb_pixel)
     );
     

  draw_background my_background (
    .vcount_in(vcount),
    .vsync_in(vsync),
    .vblnk_in(vblnk),
    .hcount_in(hcount),
    .hsync_in(hsync),
    .hblnk_in(hblnk),

    .vcount_out(vcount_out_bg),
    .vsync_out(vsync_out_bg),
    .vblnk_out(vblnk_out_bg),
    .hcount_out(hcount_out_bg),
    .hsync_out(hsync_out_bg),
    .hblnk_out(hblnk_out_bg),
    .rgb_out(rgb_out_bg),
    .pclk(pclk),
    .reset(rst_lck)
  );

  draw_bug my_bug (
    .hcount_in(hcount_out_bg),
    .hsync_in(hsync_out_bg),
    .hblnk_in(hblnk_out_bg),
    .vcount_in(vcount_out_bg),
    .vsync_in(vsync_out_bg),
    .vblnk_in(vblnk_out_bg),
    .rgb_in(rgb_out_bg),
    .pclk(pclk),
    .reset(rst_lck),

    .hcount_out(hcount_out_rec),
    .hsync_out(hsync_out_rec),
    .hblnk_out(hblnk_out_rec),
    .vcount_out(vcount_out_rec),
    .vsync_out(vsync_out_rec),
    .vblnk_out(vblnk_out_rec),
    .rgb_out(rgb_out_rec),
    
    .x_bugpos(x_bugpos),
    .y_bugpos(y_bugpos),
        
    .rgb_pixel(rgb_pixel),
    .pixel_addr(addr)
  );

  mouse mousedispl (
    .pclk(pclk),
    .rst_lck(rst_lck),
    .vcount_in(vcount_out_rec),
    .vsync_in(vsync_out_rec),
    .vblnk_in(vblnk_out_rec),
    .hcount_in(hcount_out_rec),
    .hsync_in(hsync_out_rec),
    .hblnk_in(hblnk_out_rec),
    .rgb_in(rgb_out_rec),
    .xpos(xpos),
    .ypos(ypos),
    .vcount_out(vcount_out_disp),
    .vsync_out(vsync_out_disp),
    .vblnk_out(vblnk_out_disp),
    .hcount_out(hcount_out_disp),
    .hsync_out(hsync_out_disp),
    .hblnk_out(hblnk_out_disp),
    .rgb_out(rgb_out_disp)
  );
 
  assign vs = vsync_out_disp;
  assign hs = hsync_out_disp;
  assign {r,g,b} = rgb_out_disp;

endmodule