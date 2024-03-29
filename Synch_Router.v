module Router_sync( input clk,rst,detect_add,write_enb_reg,read_enb_0,read_enb_1,read_enb_2,empty_0,empty_1,empty_2,full_0,full_1,full_2, 
					input [1:0]datain,
					output wire vld_out_0,vld_out_1,vld_out_2,
					output reg [2:0]write_enb, 
					output reg fifo_full, soft_reset_0,soft_reset_1,soft_reset_2);
					
reg [1:0]temp;
reg [4:0]count0,count1,count2;


always@(posedge clk)
	begin
		if(rst==0)
			temp <= 2'b0;
		else if(detect_add)
			temp<=datain;
	end
	

//fifo full
always@(*)
	begin
		case(temp)
			2'b00: fifo_full=full_0;                
			2'b01: fifo_full=full_1;                
			2'b10: fifo_full=full_2;				
			default fifo_full=0;
		endcase
	end

//write enable
always@(*)
	begin 
				if(write_enb_reg)
				begin
					case(temp)
						2'b00: write_enb=3'b001;				
						2'b01: write_enb=3'b010;
						2'b10: write_enb=3'b100;
						default: write_enb=3'b000;
					endcase
				end
				else
					write_enb = 3'b000;		
	end

//valid out

assign vld_out_0 = !empty_0;
assign vld_out_1 = !empty_1;
assign vld_out_2 = !empty_2;

//soft_rst

always @(vld_out_0||vld_out_1||vld_out_2)begin
	if(vld_out_0==1)
	count0<=count0+1;
	
	else if(vld_out_1==1)
	count1<=count1+1;

	else if(vld_out_2==1)
	count2<=count2+1;
end

always @(*)begin
	if(~read_enb_0 && count0>=30)
	soft_reset_0<=1;
	else
	soft_reset_0<=0;
end

always @(*)begin
	if(~read_enb_1 && count1>=30)
	soft_reset_1<=1;
	else
	soft_reset_1<=0;
end

always @(*)begin
	if(~read_enb_2 && count1>=30)
	soft_reset_2<=1;
	else
	soft_reset_2<=0;
end

endmodule