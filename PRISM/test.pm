dtmc

module walker

	// Bounded location
	x : [-100..100] init 0;
	
	// Unbiased random walk
	[] x>=-99 & x<=99 -> 0.5 : (x'=x-1) + 0.5 : (x'=x+1);
	[] x=100 -> 1.0 : (x'=x-1);
	[] x=-100 -> 1.0 : (x'=x+1);

endmodule

rewards "steps"
	true : 1;
endrewards