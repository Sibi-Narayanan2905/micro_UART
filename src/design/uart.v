`include "inc.h"
`include "u_xmit.v"
`include "baud.v"
`include "u_rec.v"
module uart (
    input sys_clk,
    input sys_rst_l,
    input xmitH,
    input  [`word_len-1:0] xmit_dataH,
    output uart_XMIT_dataH,
    output xmit_doneH,
    output xmit_active,
    input  uart_REC_dataH,
    output [`word_len-1:0] rec_dataH,
    output rec_readyH,
    output rec_busy
);
baud b1(.clk(sys_clk), .rst(sys_rst_l), .clk_out(clk));
receiver r1 (.clk_out(clk),.rst(sys_rst_l),.uart_rec_dataH(uart_REC_dataH),.rec_dataH(rec_dataH),.rec_readyH(rec_readyH), .busy(rec_busy));
transmitter t1 (.clk_out(clk),.rst(sys_rst_l),.xmit_datah(xmit_dataH),.uart_xmit(uart_XMIT_dataH),.xmitH(xmitH),.xmit_doneH(xmit_doneH),.xmit_active(xmit_active));

endmodule

 