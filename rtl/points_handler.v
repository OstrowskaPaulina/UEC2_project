module points_handler (
    input wire pclk,
    input wire rst,
    input wire [3:0] points,

    output reg [6:0] seg,
    output reg [3:0] an
);

reg [6:0] seg_nxt;
reg [3:0] an_nxt;

always @(*) begin
    an_nxt = 4'b1110;
    case(points)
        4'b0000:
        begin
            seg_nxt = 7'b1000000;
        end
        4'b0001:
        begin
            seg_nxt = 7'b1111001;
        end
        4'b0010:
        begin
            seg_nxt = 7'b1111001;
        end
        4'b0011:
        begin
            seg_nxt = 7'b0100100;
        end
        4'b0100:
        begin
            seg_nxt = 7'b0100100;
        end
        4'b0101:
        begin
            seg_nxt = 7'b0110000;
        end
        4'b0110:
        begin
            seg_nxt = 7'b0110000;
        end
        4'b0111:
        begin
            seg_nxt = 7'b0011001;
        end
        4'b1000:
        begin
            seg_nxt = 7'b0011001;
        end
        4'b1001:
        begin
            seg_nxt = 7'b0010010;
        end
        4'b1010:
        begin
            seg_nxt = 7'b0010010;
        end
        4'b1011:
        begin
            seg_nxt = 7'b0000010;
        end
        4'b1100:
        begin
            seg_nxt = 7'b0000010;
        end
        default:
        begin
            seg_nxt = 7'b1000000;
        end
    endcase
end

always @(posedge pclk) begin
    if(rst) begin
        seg <= 7'b1111110;
        an <= 4'b1110;
    end
    else begin
        seg <= seg_nxt;
        an <= an_nxt;
    end
end

endmodule
