//-----------------instance name: U3-----------------\\
module odo_counter 
//-----------------Ports-----------------\\
(
    input wire clk_key1,    // input from debouce module, key1_stable
    input wire rst_n_key0,  // input from key0, negative edge Asynchronous reset

    output reg [3:0] units, // output reperesents the units in BCD
    output reg [3:0] tens,  // output reperesents the tens in BCD
    output reg [3:0] huns   // output reperesents the hundreds in BCD
);

//-----------------BCD Counter Logic-----------------\\
always @(posedge clk_key1, negedge rst_n_key0) begin
    if(!rst_n_key0) begin
        units <= 4'd0;
        tens  <= 4'd0;
        huns  <= 4'd0;
    end
    else begin
        if (units == 4'd9) begin
            if (tens == 4'd9) begin
                if (huns == 4'd9) begin
                    units <= 4'd0;
                    tens  <= 4'd0;
                    huns  <= 4'd0;
                end
                else begin
                    units <= 4'd0;
                    tens  <= 4'd0;
                    huns <= huns + 4'd1;
                end 
            end
            else begin 
                units <= 4'd0;
                tens  <= tens + 4'd1;
            end
        end
        else units <= units + 4'd1;
    end
end

endmodule