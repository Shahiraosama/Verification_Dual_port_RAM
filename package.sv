package pkg;

class RAM_CLASS ;

rand	bit [9:0]	din;
rand 	bit	rx_valid;
rand 	bit	rst_n;



bit	[1:0] 	last_2_bits ;

bit			tx_valid;
bit	[7:0]	dout;

//////////////////////////// constraints on rx_valid to be 1 most of the times ///////////////////////////////////
constraint rx_valid_c {
rx_valid dist {0:= 30 , 1:= 70};
}

//////////////////////////// constraint on reset to be deasserted most of the times //////////////////////////////////
constraint reset_c {
rst_n dist {1:=90 , 0:=10};
}

//////////////////////////// constraints on din[9:8] ////////////////////////////////////////////////////////////

constraint last_2_bits_c {

if (last_2_bits == 2'b00) 
{
din[9:8] == 2'b01;
}

else if (last_2_bits == 2'b10)
{
din[9:8] == 2'b11;
}

else 
{
din[9:8] dist {2'b00 := 50 , 2'b10 := 50};
}


}

///////////////////////////// constraint on the write addresses to be fully exercised ////////////////////////////// 

constraint write_add_c {

if(last_2_bits == 2'b00)
{
din[7:0] dist {[0:128]:= 20 , [129:255] := 20 };
}
}

///////////////////////////// post_randomize fuction ///////////////////////////////////////////

function void post_randomize ;

last_2_bits = din[9:8];

endfunction


covergroup COV_GRP ;

///////////////////////////  coverage for din[9:8] ////////////////////////////////

din_2_MSB : coverpoint din[9:8] iff (rst_n) {

bins W_ADD = {2'b00};
bins W_DATA = {2'b01};
bins R_ADD = {2'b10};
bins R_DATA = {2'b11};
bins W_ADD_W_DATA = (2'b00 => 2'b01) ;
bins R_ADD_R_DATA = (2'b10 => 2'b11);
}
/////////////////////////// coverage rx_valid ///////////////////////////////////

RX_V : coverpoint rx_valid iff (rst_n) ;

////////////////////////// coverage for data and address //////////////////////////

din_8_LSB : coverpoint din[7:0] iff (rst_n){

 bins data_addresses_array[] = {[0:255]};

}

//////////////////////// coverage of tx_valid transitions //////////////////////////

tx_valid_cov: coverpoint tx_valid {

bins Transition_0_1 = (0=>1);
bins Transition_1_0 = (1=>0);

}

////////////////////////// coverage for dout /////////////////////////////////////

DOUT_COV : coverpoint dout ;
/*{
 bins dout_array[] = {[0:255]};
} */

////////////////////////// cross coverage ///////////////////////////////////////

CROSS_COV : cross din_8_LSB , din_2_MSB ;


endgroup

function new ();

COV_GRP = new;

endfunction


endclass


endpackage
