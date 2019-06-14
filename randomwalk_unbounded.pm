dtmc

const int ext;
const int x0 = 1;

module walker

	// Unbounded location
	x : [0..ext] init x0;
	
	// Unbiased random walk
	[] x<=0 -> 1.0 : (x'=x+1);
	[] x>=1 & x<=ext-1 -> 0.5 : (x'=x-1) + 0.5 : (x'=x+1);
	[] x>=ext -> 1.0 : (x'=x-1);
	

endmodule

rewards "steps"
	true : 1;
endrewards