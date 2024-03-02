module fifo_router_tb;
reg [7:0]data_in;
reg clk=0;
reg rst,soft_rst,we,re,lfd_state;
wire full,empty;
wire [7:0]data_out;
integer i;

router_fifo dut(.datain(data_in),.clk(clk),.rst(rst),.soft_reset(soft_rst),.write_enb(we),.read_enb(re),.lfd_state(lfd_state),.full
(full),.empty(empty),.dataout(data_out));

initial begin
forever #5 clk=~clk;
end

initial begin
rst=0;end
initial
begin
for(i=0;i<16;i=i+1)begin
#10 rst<=1;soft_rst<=0;we<=1;re<=0;lfd_state<=1;data_in<=$random;
end
#1 rst<=1;soft_rst<=0;we<=0;re<=1;lfd_state<=1;
//#50 $stop;
end
endmodule

