module golden_ref #(

parameter MEM_DEPTH = 256 ,
parameter ADDR_SIZE = 8  )(

input	bit					rst_n , clk,
input	bit [9:0]			din,
input	bit					rx_valid,	
output	bit 				tx_valid,
output	bit	[ADDR_SIZE-1:0]	dout	
);

localparam				W_ADD 	= 0,
						W_DATA 	= 1,
						R_ADD 	= 2,
						R_DATA 	= 3 ;


bit 	[ADDR_SIZE-1:0] write_address;
bit 	[ADDR_SIZE-1:0] read_address; 

reg		[ADDR_SIZE-1:0]		RAM		[MEM_DEPTH-1:0];


					
always@(posedge clk or negedge rst_n)
begin

if(!rst_n)
begin

write_address <= 'd0;
tx_valid <= 'd0;
dout <= 'd0;
read_address <='d0;


end

else 
begin

case(din[9:8])

W_ADD : 
begin
if (rx_valid) 
begin
write_address <= din[7:0] ;  
end
tx_valid <= 'd0;

end

W_DATA :

begin
if (rx_valid) 
begin
RAM[write_address] <= din[7:0] ; 
end
tx_valid <= 'd0; 
end

R_ADD :
begin
if (rx_valid) 
begin
read_address <= din[7:0] ;
end
tx_valid <= 'd0;
  
end

R_DATA:
begin
tx_valid <= 'd1;
dout <= RAM[read_address] ;  
end

endcase


end


end




endmodule