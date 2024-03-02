module Router_fsm_tb;
reg [1:0]data_in;
reg clk=1;
reg rst,pkt_valid,fifo_full,fifo_empty_0,fifo_empty_1,fifo_empty_2,soft_rst_0,soft_rst_1,soft_rst_2,parity_done,
low_packet_valid;
wire  write_enb_reg,detect_add,ld_state,laf_state,lfd_state,full_state,rst_int_reg,busy;

Router_fsm dut(.data_in(data_in),.clk(clk),.rst(rst),.pkt_valid(pkt_valid),.fifo_full(fifo_full),.fifo_empty_0(fifo_empty_0),.fifo_empty_1(fifo_empty_1),.fifo_empty_2(fifo_empty_2),.soft_rst_0(soft_rst_0),.soft_rst_1(soft_rst_1),.soft_rst_2(soft_rst_2),.parity_done(parity_done),
.low_packet_valid(low_packet_valid),.write_enb_reg(write_enb_reg),.detect_add(detect_add),.ld_state(ld_state),.laf_state(laf_state),.lfd_state(lfd_state),.full_state(full_state),.rst_int_reg(rst_int_reg),.busy(busy));

initial
begin
forever #5 clk=~clk;
end

task reset;
	begin
	rst=1'b0;
	#10
	rst=1'b1;
	end
endtask

task task1;
	begin
	
	pkt_valid=1'b1;
	data_in=2'b01;
	fifo_full=1'b0;
	fifo_empty_0=1'b0;
	fifo_empty_1=1'b1;
	fifo_empty_2=1'b0;
	soft_rst_0=1'b1;
	soft_rst_1=1'b0;
	soft_rst_2=1'b1;
	//parity_done=1'b1;
	//low_packet_valid=1'b1;
	
	end
endtask

task task2;
	begin
	
	pkt_valid=1'b0;
	data_in=2'b01;
	fifo_full=1'b0;
	fifo_empty_0=1'b0;
	fifo_empty_1=1'b1;
	fifo_empty_2=1'b0;
	soft_rst_0=1'b1;
	soft_rst_1=1'b0;
	soft_rst_2=1'b1;
	//parity_done=1'b1;
	//low_packet_valid=1'b1;	
	end
endtask

task task3;
	begin
	
	pkt_valid=1'b1;
	data_in=2'b01;
	fifo_full=1'b0;
	fifo_empty_0=1'b0;
	fifo_empty_1=1'b1;
	fifo_empty_2=1'b0;
	soft_rst_0=1'b1;
	soft_rst_1=1'b0;
	soft_rst_2=1'b1;
	//parity_done=1'b1;
	//low_packet_valid=1'b1;	

	end
endtask

task task4;
	begin
	
	pkt_valid=1'b1;
	data_in=2'b01;
	fifo_full=1'b1;
	fifo_empty_0=1'b0;
	fifo_empty_1=1'b1;
	fifo_empty_2=1'b0;
	soft_rst_0=1'b1;
	soft_rst_1=1'b0;
	soft_rst_2=1'b1;
	//parity_done=1'b0;
	//low_packet_valid=1'b1;	

	end
endtask
task task5;
	begin
	
	pkt_valid=1'b1;
	data_in=2'b01;
	fifo_full=1'b0;
	fifo_empty_0=1'b0;
	fifo_empty_1=1'b1;
	fifo_empty_2=1'b0;
	soft_rst_0=1'b1;
	soft_rst_1=1'b0;
	soft_rst_2=1'b1;
	parity_done=1'b0;
	low_packet_valid=1'b1;	

	end
endtask 
initial
begin
	reset;
	#20
	task1;
	#100
	task2;
	#50
	task3;
	#50
	task4;
	#50
	task3;	
	#50
	task5;
	#100
	$stop;
end
endmodule




