//-----------------instance name: U11-----------------\\
module wave_counter 
//-----------------Ports-----------------\\
(
    input wire clk_freq2,   // input from freq_divider (U10) module, freq_2
    input wire rst_n_key0,  // input from key0, negative edge synchronous reset

    output reg [3:0] sig_addr   // output to the wave_rom (U12) that contains the unique signal signature of the pig
);

//-----------------Counter Logic-----------------\\
always @(posedge clk_freq2, negedge rst_n_key0) begin
    if(!rst_n_key0) sig_addr <= 3'd0;
    else sig_addr <= sig_addr + 3'd1;
end

endmodule