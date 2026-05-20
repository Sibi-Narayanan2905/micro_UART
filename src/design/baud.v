`include "inc.h"
module baud(clk,rst,clk_out);
input clk,rst;
output reg clk_out;
reg [`cwr-1:0]count;
always @(posedge clk or negedge rst ) begin
    if(!rst) begin
        count<=0;
        clk_out<=0;
    end
    else begin
        if(count == (`cw-1)) begin
            count<=0;
            clk_out<=~clk_out;
        end
        else begin
            count<=count+1;
            clk_out<=clk_out;
        end
    end
end
endmodule