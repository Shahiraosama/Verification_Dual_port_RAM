module RAM_SVA (din,clk,rst_n,rx_valid,dout,tx_valid);

input				clk;
input				rst_n;
input				rx_valid;
input				tx_valid;
input		[9:0]	din;
input		[7:0]	dout; 


property p1;

@(posedge clk) disable iff (!rst_n) (din[9:8] == 2'b00 ) |=> ( din[9:8] == 2'b01 ) ;
 
endproperty

property p2;

@(posedge clk) disable iff (!rst_n) (din[9:8] == 2'b10 ) |=> ( din[9:8] == 2'b11 ) ;
 
endproperty

property p3;

@(posedge clk) disable iff (!rst_n) (din[9:8] == 2'b11 ) |=> $rose(tx_valid) ;
 
endproperty

property p4;

@(posedge clk) disable iff (!rst_n) (tx_valid && din[9:8] !== 2'b11) |=> ($fell(tx_valid) ) ;
 
endproperty

always_comb
begin

if(!rst_n)

assert final (dout == 7'b0 && tx_valid == 1'b0);

end

assert property (p1);
assert property (p2);
assert property (p3);
assert property (p4);

cover property (p1);
cover property (p2);
cover property (p3);
cover property (p4);



endmodule
