`timescale 1ns/1ps
module tb_freqdiv;

// drivers 
reg clk1;
reg rst_n;

// output
wire clk2;

// instance
freq_divider #(50_000_000, 480_000) U10dut (
    .clk_freq1(clk1),
    .rst_n_key1(rst_n),

    .freq_2(clk2)
);

// resetting the system
initial begin
    clk1  = 0;
    rst_n = 1;
    #10;
    rst_n = 0;
    #5;
    rst_n = 1;
end

// clocking the system
initial begin
    forever #20 clk1 = !clk1;
end

endmodule