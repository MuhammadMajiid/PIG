// Note to test this unit indivisually uncomment this section

// //-----------------------------------------------------------------------------\\
// //------------------------------Binary to BCD----------------------------------\\
// //-----------------------------------------------------------------------------\\

// module bin2bcd 
// (
//     input  wire [23:0] bin,
//     output reg  [31:0] bcd
// );

// integer i;
	
// always @(*) begin
//     bcd=0;		 	
//     for (i=0;i<24;i=i+1) begin
//         if (bcd[3:0]   >= 5) bcd[3:0]   = bcd[3:0]   + 3;
//         if (bcd[7:4]   >= 5) bcd[7:4]   = bcd[7:4]   + 3;
// 	    if (bcd[11:8]  >= 5) bcd[11:8]  = bcd[11:8]  + 3;
//         if (bcd[15:12] >= 5) bcd[15:12] = bcd[15:12] + 3;
// 		if (bcd[19:16] >= 5) bcd[19:16] = bcd[19:16] + 3;
// 		if (bcd[23:20] >= 5) bcd[23:20] = bcd[23:20] + 3;
// 		if (bcd[27:24] >= 5) bcd[27:24] = bcd[27:24] + 3;
// 		if (bcd[31:28] >= 5) bcd[31:28] = bcd[31:28] + 3;
//         bcd = {bcd[30:0],bin[23-i]};
//     end
// end

// endmodule

module HCSR04 (clk, n_rst, PS, distance, echo_count,rx_echo, trigger, ping /*, dis*/ );
	
input clk, n_rst, rx_echo, ping;
output trigger;
output [2:0] PS;
output [11:0] distance;
output [12:0] echo_count;	
	
  
// Declare state register
reg [2:0] PS;
reg [11:0] distance;	
reg latch_distance;
reg [12:0] echo_count;	
reg [3:0] trig_count;
reg trig_width;
reg trigger;

/* Note to test this unit indivisually uncomment this section
output [31:0] dis;
wire [23:0] mult;
assign mult = distance * 12'd1715;
bin2bcd gate (
    .bin(mult),

    .bcd(dis)
);
*/


// Declare st
parameter IDLE = 0, TRIG = 1, WAIT = 2, ECHO = 3, LATCH = 4, DELAY = 5;

// Determine the next state synchronously, based on the
// current state and the input
always @ (posedge clk or negedge n_rst) 
begin
	if (n_rst == 1'b0)
		PS <= IDLE;
	else
		case (PS)
			IDLE:
			begin
			if (ping == 1'b1)
				begin
					PS <= TRIG ;
				end
				else
				begin
					PS <= IDLE;
				end
			end
			TRIG: // clock is 100khz, = 10 usec period. Passing through this state will generate this pulse.
				begin
					PS <= WAIT;
				end
			WAIT: // wait for echo to be '1'
			begin
				if (rx_echo == 1'b1)
				begin
					PS <= ECHO;
				end
				else
				begin
					PS <= WAIT;
				end
			end
			ECHO: 
			begin
				if (rx_echo == 1'b1)
				begin
					PS <= ECHO;// echo pulse width counter is incremented 
				end
				else
				begin
					PS <= LATCH;
				end
			end
			LATCH:  // 
			begin
			PS <= DELAY;	
			end
			
			DELAY : // create delay  60msec (2^13 x 10usec) to allow echo / tx signal interference between each ping cycle
			begin
			if (echo_count >= 13'h1770)// @ 100HKz, 10usec x 6000 = 60msec, 6000 = 0x1770 
				begin
				PS <= IDLE; 
				end
			else
				begin
				PS <= DELAY;
				end
			end	
			
			default:  // take care of any unused states.. 
			begin 
			PS <= IDLE; 
			end									
		endcase
end

// Determine the output based only on the current state.
always @ (posedge clk) 
begin
		case (PS)
			IDLE:  begin trigger <= 1'b0; echo_count <= 12'b0000_0000_0000;  end
			TRIG:  begin trigger <= 1'b1; echo_count <= 12'b0000_0000_0000;  end
			WAIT:  begin trigger <= 1'b0; echo_count <= 12'b0000_0000_0000;  end
			ECHO:  begin trigger <= 1'b0; echo_count <= echo_count + 1; 		end
			LATCH: begin trigger <= 1'b0; distance <= echo_count[11:0]; 		end
			DELAY: begin trigger <= 1'b0; echo_count <= echo_count + 1; 		end		 
			default:  // take care of any unused states.. 
			begin trigger <= 1'b0; echo_count <= 12'b0000_0000_0000;  end
		endcase
end

endmodule