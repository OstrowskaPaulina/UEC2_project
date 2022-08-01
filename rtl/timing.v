
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

  localparam H_MAX            = 1024;
  localparam V_MAX            = 768;
  
  localparam H_TOTAL_TIME       = 1344;
  localparam V_TOTAL_TIME       = 806;
  
  localparam H_FRONT_PORCH    = 24;
  localparam V_FRONT_PORCH    = 3;
  
  localparam H_SYNC_TIME      = 136;
  localparam V_SYNC_TIME      = 6;
  
  localparam H_BACK_PORCH     = 160;
  localparam V_BACK_PORCH     = 29;
    
   reg [10:0] vcount_nxt, hcount_nxt;
   reg vsync_nxt, vblnk_nxt, hsync_nxt, hblnk_nxt;
  
   always@(posedge pclk) begin
        if(reset)
        begin
            hcount <= 0;
            hblnk <= 0;
            hsync <= 0;
            vcount <= 0;
            vblnk <= 0;
            vsync <= 0;
        end

	else 
	begin
            hcount <= hcount_nxt;
            hblnk <= hblnk_nxt;
            hsync <= hsync_nxt;
            vcount <= vcount_nxt;
            vblnk <= vblnk_nxt;
            vsync <= vsync_nxt;
	end
  end

     always @* 
     begin   
        if(hcount == (H_TOTAL_TIME - 1)) 
        begin
             hcount_nxt = 0;
             
             if(vcount == (V_TOTAL_TIME - 1))
                  vcount_nxt = 0;
              else
                  vcount_nxt = vcount + 1;
                  
              if( (vcount >= V_MAX - 1) && (vcount < V_TOTAL_TIME - 1) )
                  vblnk_nxt = 1;
              else
                  vblnk_nxt = 0;
                          
              if( (vcount >= (V_MAX + V_FRONT_PORCH - 1)) && (vcount < (V_MAX + V_FRONT_PORCH + V_SYNC_TIME - 1) ) )
                  vsync_nxt = 1;                      
              else
                  vsync_nxt = 0; 
         end 
         
         else 
         begin
             hcount_nxt = hcount + 1;
             vcount_nxt = vcount; 
             vblnk_nxt = vblnk;
             vsync_nxt = vsync;
         end
             
         if( (hcount >= H_MAX - 1) && (hcount < H_TOTAL_TIME - 1))
             hblnk_nxt = 1;
         else
             hblnk_nxt = 0;  
            
         if( (hcount >= (H_MAX + H_FRONT_PORCH - 1)) && (hcount < (H_MAX + H_FRONT_PORCH + H_SYNC_TIME - 1)))
             hsync_nxt = 1;
         else
             hsync_nxt = 0;  
     end
endmodule
