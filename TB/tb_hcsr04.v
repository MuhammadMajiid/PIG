`timescale 1us/1ns
module tb_hcsr04;

// drivers and outputs
reg clk, n_rst, rx_echo, ping;
wire trigger;
wire [2:0] PS;
wire [11:0] distance;
wire [12:0] echo_count;
wire [31:0] dis;

wire [23:0] dis_in_um; 


assign dis_in_um = distance * 24'd1715;

// instantiation
HCSR04 dut (.clk(clk), .n_rst(n_rst), .PS(PS), .distance(distance), .echo_count(echo_count), .rx_echo(rx_echo), .trigger(trigger), .ping(ping), .dis(dis));

// system clock 100KHz
initial begin
    clk = 1'b1;
    forever #5 clk = !clk;
end

// resetting the system
initial begin
    n_rst = 1'b1;
    #10;
    n_rst = 1'b0;
    ping  = 1'b0;
    rx_echo = 1'b0;
    #10;
    n_rst = 1'b1;
end

// monitoring the output
initial begin
    $monitor($time, "   PS = %d    distance count = %d   Distance in cm = %h%h%h.%h%h%h%h    echo_count =  %d  trigger = %b", 
    PS, distance[11:0], dis[27:24], dis[23:20], dis[19:16], dis[15:12], dis[11:8], dis[7:4], dis[3:0], echo_count[12:0], trigger);
end
integer i=0;
parameter ticks = 'd73;
parameter ref_res = (ticks * 'd1715);
// test 
initial begin
    // Run for 800 us
    #20;
    ping = 1'b1;
    rx_echo = 1'b1;
    while (i < (ticks+2)) #10 i = i + 1;
    rx_echo = 1'b0;
    #20;
    if (dis_in_um == ref_res) $display("                --------------- (Distance in um = %d) Correct!------------------           ", dis_in_um);
    else $display("---------------Wrong---------------");
end

endmodule