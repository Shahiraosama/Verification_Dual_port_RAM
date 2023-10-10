module ram (din,clk,rst_n,rx_valid,dout,tx_valid);
	parameter MEM_DEPTH = 256;
	parameter ADDR_SIZE = 8;

	input [9:0] din;
	input clk, rst_n , rx_valid;
	output reg [7:0] dout;
	output reg tx_valid;

	reg [ADDR_SIZE-1:0] write_addr, read_addr;
	
	reg [ADDR_SIZE-1:0] mem [MEM_DEPTH-1:0];


	//integer i ;
	always @(posedge clk,negedge rst_n) 
	begin
		if(~rst_n) begin
		//	for (i=0; i < MEM_DEPTH; i=i+1) begin
				// mem[i] = 0; // bug1 he resets the memory regs and that wasn't required in the specs so there is no need for FOR LOOP  
				tx_valid <= 'd0; // bug2 he didn't reset tx_valid 
				dout <= 'd0 ;  //bug3 he didn't reset dout 
				write_addr <='d0; // bug5 the write_addr isn't reset
				read_addr <= 'd0; // bug6 the read_addr isn't reset
			//end
		end
		/*
		there was a bug where the write and the read operations were dependent on rx_valid signal and only when rx_valid is asserted 
		it means that the data to be written or address to be written or the address to be read are sent correctly  		
		*/
		else 
		begin
			case (din[9:8])
				2'b00: 
				begin
				if(rx_valid)
					begin
					write_addr <= din[7:0];
						end
					tx_valid <=0;
				end
				2'b01: 
				begin
				
						if(rx_valid)
						begin
				mem [write_addr] <= din[7:0];
					end
					tx_valid <=0;
				end	
				2'b10: begin
				if(rx_valid)
				begin
					read_addr <= din[7:0];
					end
				tx_valid <=0;
				end
				2'b11: begin
					dout <= mem[read_addr];
					tx_valid <=1;
				end
			endcase
		end
		/* commented it as it's a bug 
		else 
			tx_valid <=0; // bug4 it's not necessary condition 
		*/
	end


	
endmodule
