//-----------------instance name: U10-----------------\\
module freq_divider
//-----------------Parameters-----------------\\
#(
  parameter SysFreq = 50_000_000,
  parameter NewFreq = 480_000
)
//-----------------Ports-----------------\\
(
    input wire clk_freq1,  // input from PLL (U9) module, freq_1
    input wire rst_n_key1, // input from debouce (U13) module, key1_stable

    output reg freq_2     // output to wave_counter (U11)
);
//-----------------Inernal declarations-----------------\\
localparam DivRatio = SysFreq/NewFreq;
localparam WIDTH = $clog2(DivRatio);
reg  [(WIDTH-1):0] even_counter;
wire [(WIDTH-1):0] temp;

//-----------------Intialization-----------------\\
assign temp = DivRatio >> 1;

//-----------------logic for even N/2 with 50% duty cycle-----------------\\
always @(posedge clk_freq1, negedge rst_n_key1) begin
  if (!rst_n_key1) begin
    freq_2       <= 1'b0;
    even_counter <= {WIDTH{1'b0}};
  end
  else begin
    if (even_counter == (temp - 1'b1)) begin
      freq_2       <= ~freq_2;
      even_counter <= {WIDTH{1'b0}};
    end
    else begin
      even_counter <= even_counter + 1'b1;
    end
  end
end

endmodule