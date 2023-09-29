///////////////////////////////Unfinished\\\\\\\\\\\\\\\\\\\\\\\\\\\

module seven_seg_decoder_extended (data_in, data_out);

input [4:0] data_in; // 5bit binary data input for basic 4-bit binary to hex conversion plus extended char set.
output [7:0]data_out; // common annode seven seg display output includes dp

reg [7:0] data_out;

// seg = {dp,g,f,e,d,c,b,a};
// common anode seg, hence '0' is on and '1' is off

always @ (data_in)begin 
	case (data_in)
   5'h00: data_out <= ~8'h3F; //0   dp, g,F,E_D,C,B,A  => 0011_1111, where UC = segmnet 'on'
   5'h01: data_out <= ~8'h06; //1    //     ---a----
   5'h02: data_out <= ~8'h5B; //2    //     |      |
   5'h03: data_out <= ~8'h4F; //3    //     f      b
   5'h04: data_out <= ~8'h66; //4    //     |      |
   5'h05: data_out <= ~8'h6D; //5    //     ---g----
   5'h06: data_out <= ~8'h7D; //6    //     |      |
   5'h07: data_out <= ~8'h07; //7    //     e      c
   5'h08: data_out <= ~8'h7F; //8    //     |      |
   5'h09: data_out <= ~8'h67; //9    //  dp ---d----
	5'h0A: data_out <= ~8'h77; //A
	5'h0B: data_out <= ~8'h7C; //B 
	5'h0C: data_out <= ~8'h58; //C 
	5'h0D: data_out <= ~8'h5e; //D 
	5'h0E: data_out <= ~8'h79; //E
	5'h0F: data_out <= ~8'h71; //F	dp,G,F,E_d,c,b,A  => 0111_0001, where UC = segmnet 'on'
	5'h10: data_out <= ~8'h00; // all blank,   dp,g,f,e_d,c,b,a  
   5'h11: data_out <= ~8'h80; // dp on,		 DP,g,f,e_d,c,b,a  
   5'h12: data_out <= ~8'h5C; //O 		       01011100               dp,G,f,E_D,C,b,a  
   5'h13: data_out <= ~8'h73; //P             01110011    
   5'h14: data_out <= ~8'h30; //I             00110000   
   5'h15: data_out <= ~8'h01; //T             00110001
   5'h16: data_out <= ~8'h3D; //G             00111101   
   5'h17: data_out <= ~8'h00; //H    
   5'h18: data_out <= ~8'h00; //J   
   5'h19: data_out <= ~8'h00; //K    
	5'h1A: data_out <= ~8'h00; //L
	5'h1B: data_out <= ~8'h00; //M
	5'h1C: data_out <= ~8'h00; //N
	5'h1D: data_out <= ~8'h00; //R
	5'h1E: data_out <= ~8'h00; //S
	5'h1F: data_out <= ~8'h00; //V
	default :
		data_out <= ~8'h00;
	endcase
end
endmodule
