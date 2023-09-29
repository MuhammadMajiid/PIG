// This module is one parameterized test bench for the three counters modules
// Uncomment the desired module instance for testing

`timescale 1ns/1ps
module tb_counters;

// General drivers for the three counters
reg clk_count;
reg rst_n_count;

///////////////////////////////////////////////////////////////

//--------------------------ODO-------------------------------\\

// // ODO Outputs
// wire [3:0] units;
// wire [3:0] tens;
// wire [3:0] huns;
// // ODO instance
// odo_counter U3dut (
//     .clk_key1(clk_count),
//     .rst_n_key0(rst_n_count),

//     .units(units),
//     .tens(tens),
//     .huns(huns)
// );
// // ODO output monitoring 
// initial begin
//     $monitor($time, "   BCD = %d%d%d", huns[3:0], tens[3:0], units[3:0]);
// end

///////////////////////////////////////////////////////////////

//--------------------------ID-------------------------------\\

// ID Outputs
wire [2:0] id_addr_tb;
wire [3:0] myid;
// ID instance
id_counter U4dut (
    .clk_key1(clk_count),
    .rst_n_key0(rst_n_count),

    .id_addr(id_addr_tb)
);

// ID ROM
id_rom U5dut (
    .addr(id_addr_tb),
    .id(myid)
);

// ID output monitoring
initial begin
    $monitor($time, "   ID Address = %d     ID = %d", id_addr_tb[2:0], myid[3:0]);
end

///////////////////////////////////////////////////////////////

//--------------------------WAVE-------------------------------\\

// // Wave Output
// wire [3:0] sig_addr;
// wire [3:0] signt;
// reg sw3, sw4;
// // Wave instance
// wave_counter U11dut (
//     .clk_freq2(clk_count),
//     .rst_n_key0(rst_n_count),

//     .sig_addr(sig_addr)
// );
// // Wave ROM
// wave_rom U12dut (
//     .wav_addr(sig_addr),
//     .sw3(sw3),
//     .sw4(sw4),
//     .VGA(signt)
// );
// // Wave output monitoring
// initial begin
//     $monitor($time, "   SW[4:3] = %d%d    Signature Address = %d      Signature = %h ", sw4, sw3, sig_addr[3:0], signt[3:0]);
// end

///////////////////////////////////////////////////////////////


//---------------------------Test-----------------------------\\

// resetting the system
initial begin
    clk_count   = 0;
    rst_n_count = 1;
    #10;
    rst_n_count = 0;
    #5;
    rst_n_count = 1;
end

// clocking the counters
initial begin
    forever #20 clk_count = !clk_count;
end

endmodule