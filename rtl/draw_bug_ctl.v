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
reg [10:0] st_nxt, st;
reg [1:0] rotation_nxt;
localparam HEIGHT = 54;
localparam WIDTH = 53;



localparam IDLE   = 11'b00000000001,
           TOP    = 11'b00000000010,
           RIGHT  = 11'b00000000100,
           DOWN   = 11'b00000001000,
           RIGHT_1= 11'b00000010000,
           DOWN_1 = 11'b00000100000,
           LEFT   = 11'b00001000000,
           UP     = 11'b00010000000,
           RIGHT_2= 11'b00100000000,
           GROUND = 11'b01000000000,
           RESET  = 11'b10000000000;   
    
always@(posedge pclk)
    begin
        if(rst)
            begin
            
            st <= IDLE;
            xpos <= 0;
            ypos <= 0;
            count_v <= 0;
            count_h <= 0;
            rotation <= 0;
            end
        else
            begin
            st <= st_nxt;
            xpos <= xpos_nxt;
            ypos <= ypos_nxt;
            count_v <= count_v_nxt;
            count_h <= count_h_nxt;
            rotation_nxt <= rotation;
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
                    rotation_nxt = rotation;
                    st_nxt = mouse_left ? TOP : IDLE;
                end
            TOP:
                begin
                    xpos_nxt = xpos;                    
                    ypos_nxt = ypos;
                    rotation_nxt = rotation;
                    count_v_nxt = count_v;
                    count_h_nxt = count_h;
                    st_nxt = RIGHT;
                end
            RIGHT:
                begin
                    rotation_nxt=3;
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
                    
                    st_nxt = (xpos < 800 - WIDTH - 500) ? RIGHT : DOWN;
                    
                end
            DOWN:
                begin
                    rotation_nxt=2;
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
                 st_nxt = (ypos < 600 - HEIGHT - 400) ? DOWN : RIGHT_1;
                end
             RIGHT_1:
                    begin
                        rotation_nxt=3;
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
                        
                        st_nxt = (xpos < 800 - WIDTH - 50) ? RIGHT_1 : DOWN_1;
                        
                    end
                DOWN_1:
                        begin
                            rotation_nxt=2;
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
                         st_nxt = (ypos < 600 - HEIGHT - 100) ? DOWN_1 : LEFT;
                        end
            LEFT:
                    begin
                        rotation_nxt=1;
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
                        
                        st_nxt = (xpos > 300) ? LEFT : UP;
                        
                    end
            UP:
                begin
                 rotation_nxt=0;
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
             st_nxt = (ypos > 300) ? UP : RIGHT_2;
            end
            
            RIGHT_2:
                    begin
                        rotation_nxt=3;
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
                        
                        st_nxt = (xpos < 730) ? RIGHT_2 : GROUND;
                        
                    end
            
            GROUND:
            begin
            xpos_nxt = 50;
            ypos_nxt = 50;
            count_v_nxt = 0;
            count_h_nxt = 0;
            rotation_nxt = rotation;
            st_nxt = TOP; 

            end
            default:
            begin
            xpos_nxt = xpos;
            ypos_nxt = ypos;
            count_v_nxt = count_v;
            count_h_nxt = count_h;
            rotation_nxt = rotation;
            st_nxt = st;
            
            end
        endcase
    end
    
endmodule

