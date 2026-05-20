
`include "inc.h"

module receiver (clk_out,rst,uart_rec_dataH,rec_dataH,rec_readyH,busy);
input clk_out,rst,uart_rec_dataH;
output reg [`word_len-1:0] rec_dataH;
output reg rec_readyH;
reg syncx1,syncx2,syncx2_prev;
always @(posedge clk_out or negedge rst) begin
    if(!rst) begin
        syncx1<=1'b1;
        syncx2<=1'b1;
    end
    else begin
        syncx1<= uart_rec_dataH;
        syncx2<=syncx1;
    end
end
parameter idle = 0,start = 1,data = 2,stop = 3;

reg [1:0] state;
reg [$clog2(`word_len):0] count;
reg [3:0] count1;
reg[`word_len-1:0] shift_reg;
wire negedge_det = (syncx2==0) && (syncx2_prev==1);
output reg busy;
always @(posedge clk_out or negedge rst) begin
    if(!rst) syncx2_prev<=1'b1;
    else syncx2_prev<=syncx2;
end    
 
always @ (posedge clk_out or negedge rst) begin
    if(!rst) begin
        state<=idle;
        count1<=0;
        count<=0;
        rec_dataH<=0;
        rec_readyH<=1;
        shift_reg<=0;
        busy<=0;
    end
    else begin 
        case(state)
            idle:begin
                if(negedge_det) begin
                    count1<=0;
                    state<=start;
                end
            end
            start: begin
                if(count1 == 4'd5) begin
                    if(syncx2 == 1'b0) begin
                        state<=data;
                        count1<=0;
                        count<=0;
                        busy<=1;
                        rec_readyH<=0;
                    end
                    else begin
                        state<=idle;
                        count1<=0;
                        count<=0;
                    end
                end

                else count1<=count1+1;
            end
            data: begin
                if(count1 == 15)begin
                    count1<=0;
                    shift_reg[count]<= syncx2;
                    if(count == `word_len-1) begin
                        state<=stop;
                        count<=0;
                        
                    end
                    else count<=count+1;
                end
                else count1<=count1+1;
            end
            stop: begin
                if(count1==15) begin
                    count1<=0;
                    if(syncx2==1'b1) begin
                        rec_readyH<=1;
                        rec_dataH<=shift_reg;
                        busy<=0;
                    end
                    else begin             
                        rec_readyH<=1;      
                        busy<=0;            
                    end
                    state<=idle;
                end
                else count1<=count1+1;
            end
        endcase

    end
end
endmodule
