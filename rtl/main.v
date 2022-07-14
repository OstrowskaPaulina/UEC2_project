
// The `timescale dibugtive specifies what the
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
  wire mouse_left;

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

  wire [11:0] vcount, hcount;
  wire vsync, hsync;
  wire vblnk, hblnk;

  wire [11:0] vcount_out_bg, hcount_out_bg, vcount_out_bug, hcount_out_bug, vcount_out_disp, hcount_out_disp, vcount_out_start, hcount_out_start, vcount_out_switch, hcount_out_switch;
  wire vsync_out_bg, hsync_out_bg, vsync_out_bug, hsync_out_bug, vsync_out_disp, hsync_out_disp, vsync_out_start, hsync_out_start, vsync_out_switch, hsync_out_switch;
  wire vblnk_out_bg, hblnk_out_bg, vblnk_out_bug, hblnk_out_bug, vblnk_out_disp, hblnk_out_disp, vblnk_out_start, hblnk_out_start, vblnk_out_switch, hblnk_out_switch;
  wire [11:0] rgb_out_bg, rgb_out_bug, rgb_out_disp, rgb_out_start, rgb_out_switch;
  wire [11:0] xpos, xpos_disp, ypos, ypos_disp;
  wire [11:0] x_bugpos, y_bugpos;

  MouseCtl my_mousectl (
    .xpos(xpos),
    .ypos(ypos),
    .ps2_clk(ps2_clk),
    .ps2_data(ps2_data),
    .clk(pclk_mouse),
    .rst(rst_lck),
    .left(mouse_left),

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
  
    wire [11:0] rgb_pixel_bug, rgb_pixel_start;
    wire [11:0] addr_bug, addr_start;

 bug_rom bug_rom(
     .clk(pclk),
     .address(addr_bug),
     .rgb(rgb_pixel_bug)
     );
  
  start_rom start_rom(
    .clk(pclk),
    .address(addr_start),
    .rgb(rgb_pixel_start)
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

  draw_start my_start(
    .hcount_in(hcount_out_bg),
    .hsync_in(hsync_out_bg),
    .hblnk_in(hblnk_out_bg),
    .vcount_in(vcount_out_bg),
    .vsync_in(vsync_out_bg),
    .vblnk_in(vblnk_out_bg),
    .rgb_in(rgb_out_bg),
    .pclk(pclk),
    .reset(rst_lck),

    .hcount_out(hcount_out_start),
    .hsync_out(hsync_out_start),
    .hblnk_out(hblnk_out_start),
    .vcount_out(vcount_out_start),
    .vsync_out(vsync_out_start),
    .vblnk_out(vblnk_out_start),
    .rgb_out(rgb_out_start),
    
    .x_bugpos(x_bugpos),
    .y_bugpos(y_bugpos),
        
    .rgb_pixel(rgb_pixel_start),
    .pixel_addr(addr_start)
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

    .hcount_out(hcount_out_bug),
    .hsync_out(hsync_out_bug),
    .hblnk_out(hblnk_out_bug),
    .vcount_out(vcount_out_bug),
    .vsync_out(vsync_out_bug),
    .vblnk_out(vblnk_out_bug),
    .rgb_out(rgb_out_bug),
    
    .x_bugpos(x_bugpos),
    .y_bugpos(y_bugpos),
        
    .rgb_pixel(rgb_pixel_bug),
    .pixel_addr(addr_bug)
  );

  screen_switch my_screen_switch(
    .hcount_out_bug(hcount_out_bug),
    .hsync_out_bug(hsync_out_bug),
    .hblnk_out_bug(hblnk_out_bug),
    .vcount_out_bug(vcount_out_bug),
    .vsync_out_bug(vsync_out_bug),
    .vblnk_out_bug(vblnk_out_bug),
    .rgb_out_bug(rgb_out_bug),

    .hcount_out_start(hcount_out_start),
    .hsync_out_start(hsync_out_start),
    .hblnk_out_start(hblnk_out_start),
    .vcount_out_start(vcount_out_start),
    .vsync_out_start(vsync_out_start),
    .vblnk_out_start(vblnk_out_start),
    .rgb_out_start(rgb_out_start),

    .hcount_out_switch(hcount_out_switch),
    .hsync_out_switch(hsync_out_switch),
    .hblnk_out_switch(hblnk_out_switch),
    .vcount_out_switch(vcount_out_switch),
    .vsync_out_switch(vsync_out_switch),
    .vblnk_out_switch(vblnk_out_switch),
    .rgb_out_switch(rgb_out_switch),

    .pclk(pclk),
    .rst(rst_lck),
    .mouse_left(mouse_left),
    .xpos(xpos),
    .ypos(ypos)
);

  mouse mousedispl (
    .pclk(pclk),
    .rst_lck(rst_lck),
    .vcount_in(vcount_out_switch),
    .vsync_in(vsync_out_switch),
    .vblnk_in(vblnk_out_switch),
    .hcount_in(hcount_out_switch),
    .hsync_in(hsync_out_switch),
    .hblnk_in(hblnk_out_switch),
    .rgb_in(rgb_out_switch),
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