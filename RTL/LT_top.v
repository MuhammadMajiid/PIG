//-----------------instance name: U9-12-----------------\\
module LT_top
#(
    parameter SysFreq = 50_000_000,
    parameter NewFreq = 480_000
)
(
    clk_50,
    clk_key1,    // input from debouce module, key1_stable
    rst_n_key0,  // input from key0, negative edge Asynchronous reset
    sw3, sw4,

    VGA_R,
    R8,
    arduino_io0,
   arduino_io3
);

// For top level module
input clk_50; 		// clk_50MHz 
input rst_n_key0; 			// key0.. press = logic-0
input clk_key1; 				// key1.. press = logic-0	
input sw4;
input sw3;
output [3:0] VGA_R; 
output arduino_io3;
output arduino_io0;
output R8;

wire freq_2; 
wire clk_480kHz; 
wire [11:0] r6;

/* PLL created using megawizard. 50MHz to 100khz and to 480KHz*/ 
PLL_1 U9 (.inclk0(clk_50), .c0(clk_480kHz),
.c1(R8)
); 

// when freq_1, in order to get freq_TX = 5KHz, we need freq_2 to be 16 times higher
// thus freq_2 = 5KHz * 16 = 80KHz
freq_divider #(.SysFreq(SysFreq), .NewFreq(NewFreq)) U10
(
    .clk_freq1(clk_480kHz),
    .rst_n_key1(clk_key1),

    .freq_2(freq_2)
);

// Wave Output
wire [3:0] sig_addr;
wave_counter U11 
(
    .clk_freq2(freq_2),
    .rst_n_key0(rst_n_key0),

    .sig_addr(sig_addr)
);
// Wave ROM
wave_rom U12 
(
    .addr(sig_addr),
    .sw3(sw3),
    .sw4(sw4),
    .d(VGA_R)
);

assign arduino_io0 = freq_2;
assign arduino_io3 = clk_480kHz;

endmodule