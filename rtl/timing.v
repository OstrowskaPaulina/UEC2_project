
// The `timescale directive specifies what the
// simulation time units are (1 ns here) and what
// the simulator time step should be (1 ps here).

`timescale 1 ns / 1 ps

// Declare the module and its ports. This is
// using Verilog-2001 syntax.

module timing (
  output reg [11:0] vcount,
  output reg vsync,
  output reg vblnk,
  output reg [11:0] hcount,
  output reg hsync,
  output reg hblnk,
  input wire pclk,
  input wire reset
  );

  // Describe the actual circuit for the assignment.
  // Video timing controller set for 800x600@60fps
  // using a 40 MHz pixel clock per VESA spec.
  
  localparam HOR_TOTAL_TIME = 1056;
  localparam HOR_BLANK_START = 800;
  localparam HOR_SYNC_START = 840;
  localparam HOR_SYNC_TIME = 128;
  localparam VER_TOTAL_TIME = 628;
  localparam VER_BLANK_START = 600;
  localparam VER_SYNC_START = 601;
  localparam VER_SYNC_TIME = 4;
 
  reg [11:0] hcount_nxt;
  reg [11:0] vcount_nxt;
  reg vblnk_nxt;
  reg vsync_nxt;
  reg hblnk_nxt;
  reg hsync_nxt;


  always @*
    begin
      if(hcount == (HOR_TOTAL_TIME - 1))
      begin
        hcount_nxt = 0;
        if(vcount == VER_TOTAL_TIME - 1)
          vcount_nxt = 0;
        else
          vcount_nxt = (vcount + 1);
      end
      else
      begin
        vcount_nxt = vcount;
        hcount_nxt = (hcount + 1);
      end 

    hblnk_nxt = (hcount >= (HOR_BLANK_START - 1) && (hcount <= (HOR_TOTAL_TIME - 2)));
    hsync_nxt = (hcount >= (HOR_SYNC_START - 1) && (hcount <=(HOR_SYNC_START + HOR_SYNC_TIME - 2)));
    
    if((vcount >= VER_BLANK_START - 1) && (vcount < (VER_TOTAL_TIME - 1)) && (hcount == (HOR_TOTAL_TIME - 1)))
      vblnk_nxt = 1;
    else if((vcount == (VER_TOTAL_TIME - 1)) && (hcount == (HOR_TOTAL_TIME - 1)))
      vblnk_nxt = 0;
    else
      vblnk_nxt = vblnk;
    
    if((vcount >= (VER_SYNC_START - 1)) && (vcount < (VER_SYNC_START + VER_SYNC_TIME - 1)) && (hcount == (HOR_TOTAL_TIME - 1)))
      vsync_nxt = 1;
    else if((vcount == (VER_SYNC_START + VER_SYNC_TIME - 1)) && (hcount == (HOR_TOTAL_TIME - 1)))
      vsync_nxt = 0;
    else
      vsync_nxt = vsync;
    end
   
   always @(posedge pclk)
    if(reset)
    begin
      hcount <= 0;
      vcount <= 0;
      vblnk <= 0;
      vsync <= 0;
      hblnk <= 0;
      hsync <= 0;
    end
    else
    begin
      hcount <= hcount_nxt;
      vcount <= vcount_nxt;
      vblnk <= vblnk_nxt;
      vsync <= vsync_nxt;
      hblnk <= hblnk_nxt;
      hsync <= hsync_nxt;
    end
   

endmodule
