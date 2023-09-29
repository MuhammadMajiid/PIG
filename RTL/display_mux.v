module display_mux 
(    
	HEX0_0, HEX1_0, HEX2_0, HEX3_0, HEX4_0, HEX5_0,
	HEX0_1, HEX1_1, HEX2_1, HEX3_1, HEX4_1, HEX5_1, 
	HEX0_2, HEX1_2, HEX2_2, HEX3_2, HEX4_2, HEX5_2, 
	HEX0_3, HEX1_3, HEX2_3, HEX3_3, HEX4_3, HEX5_3, 
	seg_data,
	ena_ext_char_set_Mode0, ena_ext_char_set_Mode1, ena_ext_char_set_Mode2, ena_ext_char_set_Mode3, 
	sel
);


input [3:0] HEX0_0, HEX1_0, HEX2_0, HEX3_0, HEX4_0, HEX5_0; // 4-bit binary data to be display on HEX'n' during display mode 00
input [3:0] HEX0_1, HEX1_1, HEX2_1, HEX3_1, HEX4_1, HEX5_1; // 4-bit binary data to be display on HEX'n' during display mode 01
input [3:0] HEX0_2, HEX1_2, HEX2_2, HEX3_2, HEX4_2, HEX5_2; // 4-bit binary data to be display on HEX'n' during display mode 10
input [3:0] HEX0_3, HEX1_3, HEX2_3, HEX3_3, HEX4_3, HEX5_3; //4-bit binary data to be display on HEX'n' during display mode 11
input [5:0] ena_ext_char_set_Mode0,ena_ext_char_set_Mode1,ena_ext_char_set_Mode2,ena_ext_char_set_Mode3;
input [1:0] sel;  // controls which mode is selected as output 

output [29:0] seg_data; // output of mux; combined ito 30-bit bus (5 x 5-bit) to simplify construction)

reg [29:0] seg_data;
wire [29:0] disp_0, disp_1, disp_2, disp_3;

assign disp_0 = {ena_ext_char_set_Mode0[5], HEX5_0,ena_ext_char_set_Mode0[4], HEX4_0,ena_ext_char_set_Mode0[3], HEX3_0, ena_ext_char_set_Mode0[2], HEX2_0,ena_ext_char_set_Mode0[1], HEX1_0,ena_ext_char_set_Mode0[0], HEX0_0};
assign disp_1 = {ena_ext_char_set_Mode1[5], HEX5_1,ena_ext_char_set_Mode1[4], HEX4_1,ena_ext_char_set_Mode1[3], HEX3_1, ena_ext_char_set_Mode1[2], HEX2_1,ena_ext_char_set_Mode1[1], HEX1_1,ena_ext_char_set_Mode1[0], HEX0_1};
assign disp_2 = {ena_ext_char_set_Mode2[5], HEX5_2,ena_ext_char_set_Mode2[4], HEX4_2,ena_ext_char_set_Mode2[3], HEX3_2, ena_ext_char_set_Mode2[2], HEX2_2,ena_ext_char_set_Mode2[1], HEX1_2,ena_ext_char_set_Mode2[0], HEX0_2};
assign disp_3 = {ena_ext_char_set_Mode3[5], HEX5_3,ena_ext_char_set_Mode3[4], HEX4_3,ena_ext_char_set_Mode3[3], HEX3_3, ena_ext_char_set_Mode3[2], HEX2_3,ena_ext_char_set_Mode3[1], HEX1_3,ena_ext_char_set_Mode3[0], HEX0_3};

always @ (disp_0, disp_1, disp_2, disp_3, sel)
begin 
	case (sel)
    2'b00: seg_data <= disp_0;
	2'b01: seg_data <= disp_1;
	2'b10: seg_data <= disp_2;
	2'b11: seg_data <= disp_3;
	default : seg_data <= disp_0;
	endcase
end

endmodule