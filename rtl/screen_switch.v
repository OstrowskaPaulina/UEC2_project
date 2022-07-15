module screen_switch(
    input wire pclk,
    input wire rst,
    input wire mouse_left,
    input wire [11:0] xpos,
    input wire [11:0] ypos,

    input wire [11:0] hcount_out_start,
    input wire hsync_out_start,
    input wire hblnk_out_start,
    input wire [11:0] vcount_out_start,
    input wire vsync_out_start,
    input wire vblnk_out_start,
    input wire [11:0] rgb_out_start,
 
    input wire [11:0] hcount_out_bug,
    input wire hsync_out_bug,
    input wire hblnk_out_bug,
    input wire [11:0]  vcount_out_bug,
    input wire vsync_out_bug,
    input wire vblnk_out_bug,
    input wire [11:0] rgb_out_bug,

    output reg [11:0] vcount_out_switch,
    output reg vsync_out_switch,
    output reg vblnk_out_switch,
    output reg [11:0] hcount_out_switch,
    output reg hsync_out_switch,
    output reg hblnk_out_switch, 
    output reg [11:0] rgb_out_switch
);

reg [11:0] vcount_out_switch_nxt, vcount_delay;
reg vsync_out_switch_nxt, vsync_delay;
reg vblnk_out_switch_nxt, vblnk_delay;
reg [11:0] hcount_out_switch_nxt, hcount_delay;
reg hsync_out_switch_nxt, hsync_delay;
reg hblnk_out_switch_nxt, hblnk_delay;
reg [11:0] rgb_out_switch_nxt, rgb_delay;
reg if_rst, if_rst_nxt;

localparam PIC_HEIGHT = 53;
localparam PIC_WIDTH = 54;
localparam SCREEN_WIDTH = 800;
localparam SCREEN_HEIGHT = 600;
localparam V_COORD = ((SCREEN_HEIGHT/2) - (PIC_HEIGHT/2));
localparam H_COORD = ((SCREEN_WIDTH/2) - (PIC_WIDTH/2));


always @*
begin 
    if(if_rst && ~(mouse_left && (ypos >= V_COORD) && (ypos < V_COORD + PIC_HEIGHT) && (xpos >= H_COORD) && (xpos < H_COORD + PIC_WIDTH))) begin
        if_rst_nxt = if_rst;
        vcount_out_switch_nxt = vcount_out_start;
        vsync_out_switch_nxt = vsync_out_start;
        vblnk_out_switch_nxt = vblnk_out_start;
        hcount_out_switch_nxt = hcount_out_start;
        hsync_out_switch_nxt = hsync_out_start;
        hblnk_out_switch_nxt = hblnk_out_start;    
        rgb_out_switch_nxt = rgb_out_start;
    end 
    else begin 
        if_rst_nxt = 0;
        vcount_out_switch_nxt = vcount_out_bug;
        vsync_out_switch_nxt = vsync_out_bug;
        vblnk_out_switch_nxt = vblnk_out_bug;
        hcount_out_switch_nxt = hcount_out_bug;
        hsync_out_switch_nxt = hsync_out_bug;
        hblnk_out_switch_nxt = hblnk_out_bug;
        rgb_out_switch_nxt = rgb_out_bug;
    end
end

always @(posedge pclk) begin
    if(rst) begin
        vcount_out_switch <= 0;
        vsync_out_switch <= 0;
        vblnk_out_switch <= 0;
        hcount_out_switch <= 0;
        hsync_out_switch <= 0;
        hblnk_out_switch <= 0;
        rgb_out_switch <= 0;
        if_rst <= 1;

        vcount_delay <= 0;
        vsync_delay <= 0;
        vblnk_delay <= 0;
        hcount_delay <= 0;
        hsync_delay <= 0;
        hblnk_delay <= 0;
        rgb_delay <= 0;
    end
    else begin
        vcount_delay <= vcount_out_switch_nxt;
        vsync_delay <= vsync_out_switch_nxt;
        vblnk_delay <= vblnk_out_switch_nxt;
        hcount_delay <= hcount_out_switch_nxt;
        hsync_delay <= hsync_out_switch_nxt;
        hblnk_delay <= hblnk_out_switch_nxt;  
        rgb_delay <= rgb_out_switch_nxt;

        vcount_out_switch <= vcount_delay;
        vsync_out_switch <= vsync_delay;
        vblnk_out_switch <= vblnk_delay;
        hcount_out_switch <= hcount_delay;
        hsync_out_switch <= hsync_delay;
        hblnk_out_switch <= hblnk_delay;  
        rgb_out_switch <= rgb_delay;

        if_rst <= if_rst_nxt;        
    end
end


endmodule