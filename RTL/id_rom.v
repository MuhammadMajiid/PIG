//-----------------instance name: U5-----------------\\
module id_rom 
//-----------------Ports-----------------\\
(
    input wire [2:0] addr,  // input from the id_counter (U4)

    output reg [3:0] id    // output to diplay_mux (U2)
);

//-----------------Memory Declaration-----------------\\
reg [3:0] rom [0:7];

//-----------------Memory Initialization-----------------\\
initial begin
    $readmemh("id_init_19001621.txt", rom);
end

//-----------------Reading combinationally-----------------\\
always @(*) begin
    id  = rom[addr];
end

endmodule