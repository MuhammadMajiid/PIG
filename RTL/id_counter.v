//-----------------instance name: U4-----------------\\
module id_counter 
//-----------------Ports-----------------\\
(
    input wire clk_key1,    // input from debouce (U13) module, key1_stable
    input wire rst_n_key0,  // input from key0, negative edge synchronous reset

    output reg [2:0] id_addr   // output to the id_rom (U5) that contains the id of the pig
);

//-----------------Counter Logic-----------------\\
always @(posedge clk_key1, negedge rst_n_key0) begin
    if(!rst_n_key0) id_addr <= 3'd0;
    else id_addr <= id_addr + 3'd1;
end

endmodule