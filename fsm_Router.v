module Router_fsm(clk,rst,pkt_valid,data_in,fifo_full,fifo_empty_0,fifo_empty_1,fifo_empty_2,soft_rst_0,soft_rst_1,soft_rst_2,parity_done,
low_packet_valid,write_enb_reg,detect_add,laf_state,lfd_state,ld_state,full_state,rst_int_reg,busy);

input [1:0]data_in;
input clk,rst,pkt_valid,fifo_full,fifo_empty_0,fifo_empty_1,fifo_empty_2,soft_rst_0,soft_rst_1,soft_rst_2,parity_done,
low_packet_valid;
output write_enb_reg,detect_add,ld_state,laf_state,lfd_state,full_state,rst_int_reg,busy;

reg [2:0]present_state,next_state;
reg [1:0]addr;
parameter DECODE_ADDRESS=3'b000;
parameter LOAD_FIRST_DATA=3'b001;
parameter LOAD_DATA=3'b010;
parameter LOAD_PARITY=3'b011;
parameter FIFO_FULL_STATE=3'b100;
parameter LOAD_AFTER_FULL=3'b101;
parameter WAIT_TILL_EMPTY=3'b110;
parameter CHECK_PARITY_ERROR=3'b111;

always @(posedge clk)begin
if(rst==0)
addr<=2'b0;
else if (detect_add)
addr<=data_in;
end

always @(posedge clk)begin
if(rst==0)
present_state<=DECODE_ADDRESS;

else if(((soft_rst_0)&&(addr==2'b00))||((soft_rst_1)&&(addr==2'b01))||((soft_rst_2)&&(addr==2'b10)))
present_state<=DECODE_ADDRESS;

else
present_state<=next_state;

end


always @(*)begin
case(present_state)
////////////////////////////////////////////////////

DECODE_ADDRESS:begin	
	if((pkt_valid && (addr==2'b00) && fifo_empty_0)||(pkt_valid && (addr==2'b01) && fifo_empty_1)||(pkt_valid && (addr==2'b10)&& fifo_empty_2))
next_state<=LOAD_FIRST_DATA;

	else if ((pkt_valid && (addr==2'b0) && !fifo_empty_0)||(pkt_valid && (addr==2'b01) && !fifo_empty_1)||(pkt_valid && (addr==2'b10)&& !fifo_empty_1))
next_state<=WAIT_TILL_EMPTY;

	else
next_state<=DECODE_ADDRESS;
end

////////////////////////////////////////////////

LOAD_FIRST_DATA:begin
next_state<=LOAD_DATA;
end

///////////////////////////////////////////////

WAIT_TILL_EMPTY:begin
if((fifo_empty_0 && (addr==0))||(fifo_empty_1 && (addr==1))||(fifo_empty_2 && (addr==2)))
next_state<=LOAD_FIRST_DATA;

else
next_state<=WAIT_TILL_EMPTY;
end

//////////////////////////////////////////////

LOAD_DATA:begin
if(fifo_full)
next_state<=FIFO_FULL_STATE;
else if(!fifo_full && !pkt_valid)
next_state<=LOAD_PARITY;

else
next_state<=LOAD_DATA;
end

//////////////////////////////////////////////

FIFO_FULL_STATE:begin
if(fifo_full==0)
next_state<=LOAD_AFTER_FULL;
else
next_state<=FIFO_FULL_STATE;
end

//////////////////////////////////////////////

LOAD_AFTER_FULL:begin 
if(!parity_done && low_packet_valid)
next_state<=LOAD_PARITY;
else if(!parity_done && !low_packet_valid)
next_state<=LOAD_DATA;
else if(parity_done==1'b1)
next_state<=DECODE_ADDRESS;
else
next_state<=LOAD_AFTER_FULL;
end

////////////////////////////////////////////

LOAD_PARITY:begin
next_state<=CHECK_PARITY_ERROR;
end

//////////////////////////////////////////

CHECK_PARITY_ERROR:begin

if(!fifo_full)
next_state<=DECODE_ADDRESS;

else
next_state<=FIFO_FULL_STATE;
end
default: next_state<=DECODE_ADDRESS;
endcase
end


assign busy=(((present_state==LOAD_FIRST_DATA)||(present_state==CHECK_PARITY_ERROR)||(present_state==LOAD_PARITY)||
(present_state==LOAD_AFTER_FULL)||(present_state==FIFO_FULL_STATE)||(present_state==WAIT_TILL_EMPTY))?1:0);
assign detect_add=((present_state==DECODE_ADDRESS)?1:0);
assign lfd_state=((present_state==LOAD_FIRST_DATA)?1:0);
assign ld_state=((present_state==LOAD_DATA)?1:0);
assign write_enb_reg=(((present_state==LOAD_DATA)||(present_state==LOAD_AFTER_FULL)||(present_state==LOAD_PARITY))?1:0);
assign full_state=((present_state==FIFO_FULL_STATE)?1:0);
assign laf_state=((present_state==LOAD_AFTER_FULL)?1:0);
assign rst_int_reg=((present_state==CHECK_PARITY_ERROR)?1:0);

endmodule

