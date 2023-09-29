module spirit_level (data, LED_display, latch);

input latch; // data latched on positive edge of signal
input [15:0] data; 
output [9:0] LED_display;

reg [9:0] LED_display;

always @(posedge latch)
begin

 if ((data <= -13'sd175) && (data > -13'sd250))
	begin
	LED_display = 10'b 00_0000_0001;
	end
 else if ((data < -13'sd125) && (data >= -13'sd175))
	begin
	LED_display = 10'b 00_0000_0010;
	end
 else if ((data < -13'sd75) && (data >= -13'sd125))
	begin
	LED_display = 10'b 00_0000_0100;
	end
 else if ((data < -13'sd25) && (data >= -13'sd75))
	begin
	LED_display = 10'b 00_0000_1000;
	end	
 else if  ( (data < 13'sd25)  && (data >=  13'sd0))
	begin
	LED_display = 10'b 00_0011_0000;
	end		
 else if ((data < 13'sd0) && (data >=  -13'sd25))
	begin
	LED_display = 10'b 00_0011_0000;
	end	
 else if ((data <  13'sd75) && (data >=  13'sd25))
	begin
	LED_display = 10'b 00_0100_0000;
	end
 else if ((data <  13'sd125) && (data >=  13'sd75))
	begin
	LED_display = 10'b 00_1000_0000;
	end
 else if ((data <   13'sd175) && (data >=  13'sd125))
	begin
	LED_display = 10'b 01_0000_0000;
	end
  else if  ((data <  13'sd250) && (data >=  13'sd175))
	begin
	LED_display = 10'b 10_0000_0000;
	end	
end
endmodule