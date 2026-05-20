`define word_len 8
`define xtal_clk 50000000
`define baud 9600
`define cw (`xtal_clk / ((`baud * 2) * 16))
`define cwr $clog2(`cw)
