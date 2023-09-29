`define sin
//-----------------instance name: U12-----------------\\
module wave_rom 
//-----------------Ports-----------------\\
(
    input wire [3:0] addr,  // input from the wave_counter (U11)
    input wire sw3, sw4,

    output reg [3:0] d       // output to VGA_R
);

//-----------------Memory Declaration-----------------\\
reg [3:0] sinusoidal [0:15];
reg [3:0] ramp [0:15];
reg [3:0] square [0:15];
reg [3:0] impluse [0:15];
reg [3:0] triangle [0:15];

//-----------------Memory Initialization-----------------\\
`ifdef sin

initial begin
    $readmemh("init_sine.txt", sinusoidal);
end
always @(*) begin
    d  = sinusoidal[addr];
end

`else 

initial begin
    $readmemh("init_tri.txt", triangle);
    $readmemh("init_ramp.txt", ramp);
    $readmemh("init_square.txt", square);
    $readmemh("init_imp.txt", impluse);
end
always @(*) begin
    case ({sw4, sw3})
        2'b00 : d  = triangle[addr];
        2'b01 : d  = ramp[addr];
        2'b10 : d  = square[addr];
        2'b11 : d  = impluse[addr];
    endcase
end

`endif

endmodule