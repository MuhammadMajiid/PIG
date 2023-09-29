`timescale 1ns/1ps
module tb_adxl345;

// Module clock frequency
parameter SPI_CLK_FREQ  = 2000;  // SPI Clock (kHz)
// Desired update interval
parameter UPDATE_FREQ   = 10;   // Sampling frequency (kHz)
    
// drivers and wire
reg  n_rst;
reg  clk;
reg  spi_clk;
reg  spi_clk_out;
reg  freeze;
reg                   SPI_SDO;

wire                  data_update;
wire [15:0]           data_x;
wire [15:0]           data_y;
wire [15:0]           data_z;
wire                  SPI_SDI;
wire                  SPI_CSN;
wire                  SPI_CLK;

// instance
ADXL345 #(.SPI_CLK_FREQ(SPI_CLK_FREQ), .UPDATE_FREQ(UPDATE_FREQ)) dut
    (
        .n_rst(n_rst), 
        .clk(clk),                  // 25 MHz, phase   0 degrees
        .spi_clk(spi_clk),          //  2 MHz, phase   0 degrees
        .spi_clk_out(spi_clk_out),  //  2 MHz, phase 270 degrees
        .data_update(data_update),
        .data_x(data_x),
        .data_y(data_y),
		.data_z(data_z),
        .SPI_SDI(SPI_SDI),
        .SPI_SDO(SPI_SDO),
        .SPI_CSN(SPI_CSN),
        .SPI_CLK(SPI_CLK),
        .interrupt(interrupt),
		.freeze(freeze) 
    );

//--------------Clocking------------------\\
// system clocking clk >>> 25 MHz, phase   0 degrees
initial begin
    clk = 1'b0;
    forever #20 clk = !clk; 
end

// system clocking spi_clk >>> 2 MHz, phase   0 degrees
initial begin
    spi_clk = 1'b0;
    forever #250 spi_clk = !spi_clk; 
end

// system clocking spi_clk_out >>> 2 MHz, phase   270 degrees
initial begin
    spi_clk_out = 1'b0;
    forever #250 spi_clk_out = !spi_clk_out; 
end

//--------------resetting------------------\\
initial begin
    n_rst = 1'b1;
    #200;
    n_rst = 1'b0;
    #25;
    n_rst = 1'b1;
end

//--------------Test------------------\\
// There is no enough info for the test!

endmodule