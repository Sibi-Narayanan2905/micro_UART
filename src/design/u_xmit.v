`include "inc.h"
module transmitter(clk_out,rst,xmit_datah,uart_xmit,xmitH,xmit_doneH,xmit_active);
input clk_out;
input rst;
input [`word_len-1:0] xmit_datah;
input xmitH;
output reg xmit_doneH;
output reg uart_xmit;
output reg xmit_active;
wire clk_out;
reg [`word_len:0] holder;
reg [$clog2(`word_len):0] count;
reg [4:0] count1;
always @(posedge clk_out or negedge rst) begin
    if(!rst)begin
        uart_xmit<=1'b1;
        holder<=0;
        xmit_doneH<=1;
        count<=0;
        count1<=0;
        xmit_active<=0;
    end
    else begin
        if(xmitH && xmit_doneH) begin
            holder <= {1'b1,xmit_datah};
            uart_xmit<=1'b0;
            count<=0;
            count1<=0;
            xmit_doneH<=0;
            xmit_active<=1;
        end
        else if(!xmit_doneH) begin
             if (count1 == 5'd15)begin
                count1<=0;
                if(count == `word_len+1)begin
                    count<=0;
                    xmit_doneH<=1;
                    uart_xmit<=1'b1;
                    xmit_active <= (xmitH==1'b1)? 1 : 0;
                    //0xxxxxxxx10xxxxxxxxx1
                end
                else begin
                    uart_xmit <=holder[0];
                    holder <= holder >>1;
                    count<=count+1;
                end
             end
             else begin
                count1 <= count1+1;
             end
        end
    end
end
endmodule
                
            