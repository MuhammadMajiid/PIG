module display_drv ( data_in, HEX0_Seg, HEX1_Seg, HEX2_Seg, HEX3_Seg, HEX4_Seg, HEX5_Seg);
				 
input  [29:0] data_in;   // each 6 x 5-bit data. [29:25]  is HEX5 data, [4:0] is HEX0 data
output [7:0] HEX0_Seg;
output [7:0] HEX1_Seg;
output [7:0] HEX2_Seg;
output [7:0] HEX3_Seg;
output [7:0] HEX4_Seg;
output [7:0] HEX5_Seg;

seven_seg_decoder_extended u1 (.data_in(data_in[4:0]),    .data_out(HEX0_Seg));
seven_seg_decoder_extended u2 (.data_in(data_in[9:5]),    .data_out(HEX1_Seg));
seven_seg_decoder_extended u3 (.data_in(data_in[14:10]),  .data_out(HEX2_Seg));
seven_seg_decoder_extended u4 (.data_in(data_in[19:15]),  .data_out(HEX3_Seg));
seven_seg_decoder_extended u5 (.data_in(data_in[24:20]),  .data_out(HEX4_Seg));
seven_seg_decoder_extended u6 (.data_in(data_in[29:25]),  .data_out(HEX5_Seg));

endmodule