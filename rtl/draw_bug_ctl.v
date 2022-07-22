`timescale 1ns / 1ps


module draw_bug_ctl(
    input wire pclk,
    input wire rst,
    input wire mouse_left,
    output reg [11:0] xpos,
    output reg [11:0] ypos,
    output reg [1:0] rotation
    );
    
reg [11:0] xpos_nxt, ypos_nxt;
reg [15:0] count_v, count_v_nxt, count_h, count_h_nxt;
reg [7:0] st_nxt, st;
localparam HEIGHT = 54;
localparam WIDTH = 53;



localparam IDLE   = 8'b00000001,
           TOP    = 8'b00000010,
           RIGHT  = 8'b00000100,
           DOWN   = 8'b00001000,
           LEFT   = 8'b00010000,
           UP     = 8'b00100000,
           GROUND = 8'b01000000,
           RESET  = 8'b10000000;   
    
always@(posedge pclk, posedge rst)
    begin
        if(rst)
            begin
            
            st <= IDLE;
            xpos <= 0;
            ypos <= 0;
            count_v <= 0;
            count_h <= 0;
            end
        else
            begin
            st <= st_nxt;
            xpos <= xpos_nxt;
            ypos <= ypos_nxt;
            count_v <= count_v_nxt;
            count_h <= count_h_nxt;
            end
    end
    always@(*) begin
        st_nxt = IDLE;
        case (st)
            IDLE:
                begin
                    xpos_nxt = xpos;                    
                    ypos_nxt = ypos;
                    count_v_nxt = 0;
                    count_h_nxt = 0;
                    st_nxt = mouse_left ? TOP : IDLE;
                end
            TOP:
                begin
                    xpos_nxt = xpos;                    
                    ypos_nxt = ypos;
                    count_v_nxt = count_v;
                    count_h_nxt = count_h;
                    st_nxt = RIGHT;
                end
            RIGHT:
                begin
                    rotation=3;
                    count_h_nxt = (count_h + 1);
                    count_v_nxt = count_v;
                    if(count_h == 40000) begin
                        ypos_nxt = ypos;
                        xpos_nxt = (xpos + 1);
                    end
                    else
                    begin
                        xpos_nxt = xpos;
                        ypos_nxt = ypos;
                    end          
                    
                    st_nxt = (xpos < 800 - WIDTH - 200) ? RIGHT : DOWN;
                    
                end
            DOWN:
                begin
                    rotation=2;
                     count_v_nxt = (count_v + 1);
                     count_h_nxt = count_h;
                     if(count_v == 40000) 
                     begin
                         xpos_nxt = xpos;
                         ypos_nxt = (ypos + 1);
                     end
                 else
                 begin
                     xpos_nxt = xpos;
                     ypos_nxt = ypos;

                 end          
                 st_nxt = (ypos < 600 - HEIGHT - 100) ? DOWN : LEFT;
                end
            LEFT:
                    begin
                        rotation=1;
                        count_h_nxt = (count_h + 1);
                        count_v_nxt = count_v;
                        if(count_h == 40000) begin
                            ypos_nxt = ypos;
                            xpos_nxt = (xpos - 1);
                        end
                        else
                        begin
                            xpos_nxt = xpos;
                            ypos_nxt = ypos;
                        end          
                        
                        st_nxt = (xpos > 200) ? LEFT : UP;
                        
                    end
            UP:
                begin
                 rotation=0;
                 count_v_nxt = (count_v + 1);
                 count_h_nxt = count_h;
                 if(count_v == 40000) 
                 begin
                     xpos_nxt = xpos;
                     ypos_nxt = (ypos - 1);
                 end
             else
             begin
                 xpos_nxt = xpos;
                 ypos_nxt = ypos;

             end          
             st_nxt = (ypos > 200) ? UP : GROUND;
            end
            
            GROUND:
            begin
            xpos_nxt = xpos;
            ypos_nxt = ypos;
            count_v_nxt = 0;
            count_h_nxt = 0;
            st_nxt = TOP; 

            end
        endcase
    end
    
endmodule


