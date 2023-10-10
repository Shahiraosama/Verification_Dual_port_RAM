import pkg ::*;
module RAM_TB;

parameter MEM_DEPTH = 256;
parameter ADDR_SIZE = 8;

bit						rst_n_tb; 
bit						clk_tb;
bit		[9:0]			din_tb;
bit						rx_valid_tb;
bit						tx_valid_tb;
bit		[ADDR_SIZE-1:0]	dout_tb;

bit		[7:0]	DOUT_EXP;
bit				TX_VALID_EXP;		

int err_count ;
int	corr_count ;

RAM_CLASS obj ;


reg		[ADDR_SIZE-1:0]		RAM		[MEM_DEPTH-1:0];

ram	DUT (.clk(clk_tb),
.rst_n (rst_n_tb),
.din(din_tb),
.rx_valid(rx_valid_tb),
.tx_valid(tx_valid_tb),
.dout (dout_tb)
);

always
begin
#5 clk_tb = ~clk_tb;
end

golden_ref GR (
.clk(clk_tb),
.rst_n (rst_n_tb),
.din(din_tb),
.rx_valid (rx_valid_tb),
.tx_valid (TX_VALID_EXP),
.dout(DOUT_EXP)

);

initial
begin
$readmemh("RAM_h.txt",RAM);

obj = new ;


rst_chk;

for(int i = 0; i < 10000 ; i++)
begin

assert(obj.randomize())

din_tb = obj.din ;
rx_valid_tb = obj.rx_valid ;
rst_n_tb = obj.rst_n;
obj.tx_valid = tx_valid_tb;
obj.dout = dout_tb ;

CHECK();


end

rst_chk;
$display("at the end the number of error counts = %0d and the number of correct counts = %0d ",err_count,corr_count);
$stop;
end

///////////////////////////////////////// CHECK TASK //////////////////////////////////////////////////////////////////

task CHECK;

@(negedge clk_tb)
begin
	if(tx_valid_tb !== TX_VALID_EXP || dout_tb !== DOUT_EXP)
		begin
		$display("The check is failed , TX_VALID_EXP = %0d and DOUT_EXP = %0d but we got tx_valid_tb =%0d & dout_tb =%0d && rst_n_tb = %0d",TX_VALID_EXP,DOUT_EXP,tx_valid_tb,dout_tb,rst_n_tb);
			err_count = err_count + 1;
			end
				else begin
					corr_count = corr_count +1 ;
	
	end
end
endtask

///////////////////////////////////////// RESET CHECK TASK ///////////////////////////////////////////////////////

task rst_chk;

rst_n_tb = 'd0 ;

@(negedge clk_tb)
begin

if(tx_valid_tb !== 0 || dout_tb !== 0)
	begin
		$display ("the rst chk is failed tx_valid_tb =%0d and dout_tb = %0d but expected TX_VALID_EXP=%0d and DOUT_EXP = %0d",tx_valid_tb,dout_tb, TX_VALID_EXP , DOUT_EXP);
		err_count = err_count + 1;
		end
		
		else
		begin
		corr_count = corr_count + 1;
		end
end

rst_n_tb ='d1;

endtask


///////////////////////////// sampling the coverpoints //////////////////////////////

always @(posedge clk_tb) begin
obj.COV_GRP.sample();
end

///////////////////////// binding Assertions //////////////////////////////////

bind ram RAM_SVA SVA (din,clk,rst_n,rx_valid,dout,tx_valid); 
endmodule
