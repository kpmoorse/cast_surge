dtmc

module walker

	// Bounded location
	x : int init 0;
	
	// Unbiased random walk
	[] true -> 0.5 : (x'=x-1) + 0.5 : (x'=x+1);

endmodule

rewards "steps"
	true : 1;
endrewards