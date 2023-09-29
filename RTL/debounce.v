/* 
File:-debounce.v
Author:	CWM (MMU)
Project:- DE10-Lite
Date:- 19/12/22
Description:- switch debounce circuit for DE10-Lite. 
File Dependencies:- n/a
I/O:-  pos egde clk, async negative reset (n_rst  = '0', )
*/

module debounce (key_in, key_out, clk, n_rst);
  
input key_in, clk, n_rst;
output key_out;
  
  
reg key_out;
reg [1:0]buffer;
reg [23:0] count;


localparam DEBOUNCE_TIME   =   24'd1_000_0000;     // DEBOUNCE_TIME = 20msec   / (1/clk) , 20msec / (1/20MHz) = 1_000_0000

always @(posedge clk or negedge n_rst)
begin
	if (n_rst == 1'b0)
	begin
		buffer[0] <= 1'b0;
		buffer[1] <= 1'b1;
		key_out <= 1'b0;
		count <= 24'h000000; 
	end
	else
		begin
	// read input and buffer previous value
		buffer[0] <= key_in;
		buffer[1] <= buffer[0];

		if ( ({buffer[1], buffer[0]} == 2'b01)  || ({buffer[1], buffer[0]} == 2'b10) ) // unstable, trans from neg to pos edge or vice versa
	// 01 pos to neg, 10 neg to pos (unstable!)
		begin
			count <= 24'h000000; // reset stable count
		end
		else if (count >= 24'hF4240 ) // has debounce period elapased? DEBOUNCE_TIME = 20msec   / (1/clk) , 20msec / (1/20MHz) = 1_000_000 => 24'hF4240 
		begin // yes
			key_out <= buffer[0];
			count <= 24'h000000; 
		end
		else // mustbe  00 or 11, but not yet stable. inc count
		begin
			count = count + 24'd1;
		end
	end
end

endmodule
