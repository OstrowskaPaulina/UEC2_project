`timescale 1 ns / 1 ps

module draw_start(
  input wire pclk,
  input wire reset,

  input wire [11:0] rgb_in,
  input wire [11:0] rgb_pixel,
  input wire [11:0] x_bugpos,
  input wire [11:0] y_bugpos,

  input wire [11:0] vcount_in,
  input wire vsync_in,
  input wire vblnk_in,
  input wire [11:0] hcount_in,
  input wire hsync_in,
  input wire hblnk_in,


  output reg [11:0] vcount_out,
  output reg vsync_out,
  output reg vblnk_out,
  output reg [11:0] hcount_out,
  output reg hsync_out,
  output reg hblnk_out,

  output reg [11:0] rgb_out,
  output wire [11:0] pixel_addr
);

localparam PIC_HEIGHT = 53;
localparam PIC_WIDTH = 54;
localparam SCREEN_WIDTH = 800;
localparam SCREEN_HEIGHT = 600;
localparam LOW_V_COORD = ((SCREEN_HEIGHT/2) - (PIC_HEIGHT));
localparam UP_V_COORD = ((SCREEN_HEIGHT/2) + (PIC_HEIGHT));
localparam LOW_H_COORD = ((SCREEN_WIDTH/2) - (PIC_WIDTH));
localparam UP_H_COORD  = ((SCREEN_WIDTH/2) + (PIC_WIDTH));

reg [11:0] rgb_out_nxt;
wire [5:0] addrx, addry;
reg vsync_delay, hsync_delay, hblnk_delay, vblnk_delay;
reg [11:0] vcount_delay, hcount_delay;
reg [11:0] rgb_delay;

always @*
begin
    if((~vblnk_in) && (~hblnk_in))
    begin
        if((vcount_in >= LOW_V_COORD) && (vcount_in < UP_V_COORD) && ((hcount_in >= LOW_H_COORD) && (hcount_in < UP_H_COORD)))
        begin
            rgb_out_nxt = rgb_pixel;
        end
        else
        begin
            rgb_out_nxt = rgb_delay;
        end
    end    
    else
    begin
        rgb_out_nxt = 12'h0_0_0;
    end
end

always @(posedge pclk)
    begin
    if(reset)
    begin
        rgb_out <= 0;
        vcount_out <= 0;
        vsync_out <= 0;
        vblnk_out <= 0;
        hcount_out <= 0;
        hsync_out <= 0;
        hblnk_out <= 0;
        
        rgb_delay <= 0;
        vcount_delay <= 0;
        vsync_delay <= 0;
        vblnk_delay <= 0;
        hcount_delay <= 0;
        hsync_delay <= 0;
        hblnk_delay <= 0;
        
    end
    else
    begin
        rgb_out <= rgb_out_nxt;
        hsync_out <= hsync_delay;
        vsync_out <= vsync_delay;
        hblnk_out <= hblnk_delay;
        vblnk_out <= vblnk_delay;
        hcount_out <= hcount_delay;
        vcount_out <= vcount_delay;
        
        rgb_delay <= rgb_in;
        hsync_delay <= hsync_in;
        vsync_delay <= vsync_in;
        hblnk_delay <= hblnk_in;
        vblnk_delay <= vblnk_in;
        hcount_delay <= hcount_in;
        vcount_delay <= vcount_in;
    end
    end
   
assign addry = vcount_in - y_bugpos;
assign addrx = hcount_in - x_bugpos;
assign pixel_addr = addry * PIC_WIDTH + addrx;

endmodule