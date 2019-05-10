dtmc

module walker

	// local state
	// 0 - Left Walk
	// 1 - Right Walk
	s : [0..1] init 0;
	// value of the die
	x : [0..100] init 50;
	
	[] s=0 & (x<=0) -> 0.9 : (s'=s) & (x'=x-1) + 0.1 : (s'=1-s) & (x'=x+1);
	[] s=0 & (x>=1) -> 1.0 : (s'=1-s) & (x'=x+1);
	[] s=1 & (x>=100) -> 0.9 : (s'=s) & (x'=x+1) + 0.1 : (s'=1-s) & (x'=x-1);
	[] s=1 & (x<=99) -> 1.0 : (s'=1-s) & (x'=x-1);

endmodule

rewards "steps"
	true : 1;
endrewards