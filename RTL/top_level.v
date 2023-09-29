module top_level
(	CLK1_50,
	KEY1, KEY0,
	SW, 
	HEX0_DP,HEX1_DP,HEX2_DP,HEX3_DP,HEX4_DP,HEX5_DP,
	GSENSOR_CS_N,GSENSOR_INT, GSENSOR_SCLK, GSENSOR_SDI, GSENSOR_SDO,
	VGA_R,
	arduino_io0, arduino_io1, arduino_io2, arduino_io3,
	LEDR
); 											

//////////// Inputs //////////
(* chip_pin = "P11"*) input CLK1_50; 			// DE10 Lite 50MHz Clk
(* chip_pin = "B8"*)  input KEY0; 				// key0.. press = logic-0
(* chip_pin = "A7"*)  input KEY1; 				// key1.. press = logic-0	
//////////// DE10-LITE Seven SEG Displays //////////
(* chip_pin = "D15, C17, D17, E16 ,C16, C15, E15, C14"*) output [7:0]   HEX0_DP;  	
(* chip_pin = "A16, B17, A18, A17, B16, E18, D18, C18"*) output [7:0]	HEX1_DP;
(* chip_pin = "A19, B22, C22, B21, A21, B19, A20, B20"*) output [7:0]	HEX2_DP;
(* chip_pin = "D22, E17, D19, C20, C19, E21, E22, F21"*) output [7:0]	HEX3_DP;
(* chip_pin = "F17, F20, F19, H19, J18, E19, E20, F18"*) output [7:0]	HEX4_DP;
(* chip_pin = "L19, N20, N19, M20, N18, L18, K20, J20"*) output [7:0]	HEX5_DP;
//////////// VGA //////////
(* chip_pin = "Y1,Y2,V1,AA1"*) output [3:0] VGA_R;  
//////////// SW //////////
(* chip_pin = "A14,A13,B12,A12,C12,D12,C11,C10"*) input [7:0] SW;

//////////// Arduino //////////
(* chip_pin = "AB5" *) output arduino_io0;
(* chip_pin = "AB6" *) output arduino_io1;
(* chip_pin = "AB7" *) output arduino_io2;
(* chip_pin = "AB8" *) output arduino_io3;

//////////// Accelerometer ports //////////
(* chip_pin = "AB16"*)   		output	GSENSOR_CS_N;
(* chip_pin = "AB15"*)    		output	GSENSOR_SCLK;
(* chip_pin = "Y13, Y14 "*)     input 	[2:1]	GSENSOR_INT;
(* chip_pin = "V11"*)    		inout 	GSENSOR_SDI;
(* chip_pin = "V12"*)   		inout 	GSENSOR_SDO;

//////////// LEDs //////////
(* chip_pin = "B11, A11, D14, E14, C13, D13, B10, A10, A9, A8"*) output [9:0] LEDR;
		
//////////// Declare wires //////////
wire key1_stable;   // do not remove this line 
wire[29:0] mux_bus; // do not remove this line
wire [2:0] id_addr;
wire [3:0] r1,r2,r3, r5, r12;
wire [11:0] r6;
reg [15:0] r7;
wire [15:0] r7_tempx, r7_tempy, r7_tempz;
wire spi_FSM_clk, spi_clk, spi_clk_out, data_valid, r8;
reg [23:0] mult;
reg [31:0] bcd_res;
wire [3:0] X0_2, X1_2, X2_2, X3_2, X4_2, X5_2;
wire [5:0] en2;

////////////  declare parameters   ////////////
// for frequency divider
parameter SysFreq = 50_000_000;
parameter NewFreq = 480_000;
// for ADXL345
// Module clock frequency
parameter SPI_CLK_FREQ  = 2000;  // SPI Clock (kHz)
// Desired update interval
parameter UPDATE_FREQ   = 10;   // Sampling frequency (kHz)

///////  Debounce Circuit for KEY1 /////////////
debounce U13 (.key_in(KEY1),.key_out(key1_stable), .clk(CLK1_50), .n_rst(KEY0) );	// do not remove this line

///////  Include your design modules here /////////////  

///////  ODO counter /////////////
// ODO instance
odo_counter U3
(
    .clk_key1(key1_stable),
    .rst_n_key0(KEY0),

    .units(r1),
    .tens(r2),
    .huns(r3)
);

///////  ID  /////////////
// ID instance
id_counter U4 
(
    .clk_key1(key1_stable),
    .rst_n_key0(KEY0),

    .id_addr(id_addr)
);
// ID ROM
id_rom U5 
(
    .addr(id_addr),
    .id(r5)
);

///////  G Force  /////////////
/* PLL created using megawizard */ 
PLL_2 U7 
(  .inclk0 (CLK1_50),	   // 50 MHz, phase   0 degrees
	.c0 ( spi_FSM_clk),    // 25 MHz, phase   0 degrees
	.c1 ( spi_clk),        //  2 MHz, phase   0 degrees
	.c2 ( spi_clk_out)     //  2 MHz, phase 270 degrees
);

/* SPI Control Module */
ADXL345 #(.SPI_CLK_FREQ(SPI_CLK_FREQ), .UPDATE_FREQ(UPDATE_FREQ)) U8 
( 	.n_rst   	(KEY0),
	.clk        (spi_FSM_clk),
	.spi_clk    (spi_clk),
	.spi_clk_out(spi_clk_out),
	.data_update(data_valid),  // data valid on positive edge
	.data_x     (r7_tempx),   // x axis data
	.data_y     (r7_tempy),  // y axis data
	.data_z     (r7_tempz),  // z axis data
	.SPI_SDI    (GSENSOR_SDI),
	.SPI_SDO    (GSENSOR_SDO),
	.SPI_CSN    (GSENSOR_CS_N),
	.SPI_CLK    (GSENSOR_SCLK),
	.interrupt  (GSENSOR_INT),
	.freeze		(key1_stable)
);

// Enabling y,z to be displayed on the 7-seg
always @(*) begin
	case (SW[6:5])
		2'b00, 2'b11 : r7 = r7_tempx;
		2'b01 : r7 = r7_tempy;
		2'b10 : r7 = r7_tempz;
	endcase
end

spirit_level U8_pr (.data(r7), .LED_display(LEDR), .latch(data_valid));

///////  seven segment dispaly interface  /////////////		
display_mux U2 
(		// Mode 00 
	.HEX0_0(r1), // set to basic char set  '0'..'f'
	.HEX1_0(r2), // set to basic char set  '0'..'f'
	.HEX2_0(r3), // set to basic char set  '0'..'f'
	.HEX3_0(4'h2), // set to ext char set 'blank', line-39 seven_seg_decoder_extended.v, ext>> 1 for O
	.HEX4_0(4'hD), // set to ext char set 'blank', line-39 seven_seg_decoder_extended.v for D
	.HEX5_0(4'h2), // set to basic char set  '0'..'f' ext >> 1 for O
	.ena_ext_char_set_Mode0(6'b101_000), // edit 6'bxx_xxxx to change HEX display char mode
		// Mode 01
	.HEX0_1(r5), // set to basic char set  '0'..'f'
	.HEX1_1(4'h0), // set to basic char set  '0'..'f'
	.HEX2_1(4'h0), // set to basic char set  '0'..'f'
	.HEX3_1(4'h0), // set to ext char set 'blank', line-39 seven_seg_decoder_extended.v BLANK
	.HEX4_1(4'hD), // set to ext char set 'blank', line-39 seven_seg_decoder_extended.v for D
	.HEX5_1(4'h4), // set to basic char set  '0'..'f' ext >> 1 for I
	.ena_ext_char_set_Mode1(6'b100_000),  // edit 6'bxx_xxxx to change HEX display char mode
		// Mode 10
	.HEX0_2(X0_2), // set to basic char set  '0'..'f'
	.HEX1_2(X1_2), // set to basic char set  '0'..'f'
	.HEX2_2(X2_2), // set to basic char set  '0'..'f'
	.HEX3_2(X3_2), // set to ext char set 'blank', line-39 seven_seg_decoder_extended.v BALNK
	.HEX4_2(X4_2), // set to ext char set 'blank', line-39 seven_seg_decoder_extended.v ext >> 1 for T
	.HEX5_2(X5_2), // set to basic char set  '0'..'f' ext >> 1 for P
	.ena_ext_char_set_Mode2(en2), // edit 6'bxx_xxxx to change HEX display char mode
		// Mode 11
	.HEX0_3(r7[3:0]), // set to basic char set  '0'..'f'
	.HEX1_3(r7[7:4]), // set to basic char set  '0'..'f'
	.HEX2_3(r7[11:8]), // set to basic char set  '0'..'f'
	.HEX3_3(r7[15:12]), // set to ext char set 'blank', line-39 seven_seg_decoder_extended.v
	.HEX4_3(4'hF), // set to ext char set 'blank', line-39 seven_seg_decoder_extended.v
	.HEX5_3(4'h6), // set to basic char set  '0'..'f' ext >> 1 for G
	.ena_ext_char_set_Mode3(6'b100_000), // edit 6'bxx_xxxx to change HEX display char mode
	.seg_data(mux_bus),
	.sel(SW[1:0])
);
								
display_drv U1 
( 	.data_in(mux_bus),
	.HEX0_Seg(HEX0_DP),  
	.HEX1_Seg(HEX1_DP),   
	.HEX2_Seg(HEX2_DP),   
	.HEX3_Seg(HEX3_DP),   
	.HEX4_Seg(HEX4_DP),   
	.HEX5_Seg(HEX5_DP)
);
		
	
///////  Location Transmission  /////////////
LT_top #(.SysFreq(SysFreq), .NewFreq(NewFreq)) U9_12 
(
	.clk_50(CLK1_50),
	.clk_key1(key1_stable),
	.rst_n_key0(KEY0),
	.sw3(SW[3]),
	.sw4(SW[4]),
	
	.VGA_R(VGA_R),
	.R8(r8),
	.arduino_io0(arduino_io0),
	.arduino_io3(arduino_io3)
);

HCSR04 U6
(	.clk(r8),
	.n_rst(KEY0), 
	.ping(SW[2]),  // enable repeated measurement
	.distance (r6),   // distance measured 
	.trigger(arduino_io2),  // sig sent to HCSRO4
	.rx_echo(arduino_io1),  // sig recived from  HCSRO4
	.PS(), // no connection required, for debug  only
	.trig_count( ),// no connection required, for debug timing only
	.echo_count() // no connection required, for debug timing only
);


always @(*) begin
	mult = r6 * 12'd1715;
end

bin2bcd gate (
    .bin(mult),

    .bcd(bcd_res)
);

// represented in cm for high resolution
assign X0_2 = SW[7] ?  bcd_res[11:8]  : r6[3:0];
assign X1_2 = SW[7] ?  bcd_res[15:12] : r6[7:4];
assign X2_2 = SW[7] ?  4'h1           : r6[11:8];
assign X3_2 = SW[7] ?  bcd_res[19:16] : 4'h0;
assign X4_2 = SW[7] ?  bcd_res[23:20] : 4'h3;
assign X5_2 = SW[7] ?  bcd_res[27:24] : 4'h5;
assign en2  = SW[7] ?   6'b000_100    : 6'b110_000;

// output in cm would be measured by (r6 * 10us * 100 * 343m/s)/2 = xxx cm, then assign it instead of r6

endmodule