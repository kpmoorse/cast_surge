dtmc

const int ext = 100; // Arena size
const double a = 0.2; // Levy flight transition probability

formula signx = x>=0 ? 1:-1;
formula absx = x*signx;

module walker_state

	// local state
	s : [0..2] init 0;
	
	// Initialize direction
	[ini] (s=0) -> 0.5 : (s'=1) + 0.5 : (s'=2);

	// Update local state
	[step] (s!=0 & x<=-ext) -> 1.0 : (s'=2);
	[step] (s!=0 & x>=ext) -> 1.0 : (s'=1);
	[step] (s!=0 & x>=-ext+1 & x<=ext-1) -> a : (s'=3-s) + 1-a : (s'=s);
	
endmodule


module walker_location

	// Bounded location
	x : [-ext..ext] init -10;
	xx : [-ext..ext] init 10;

	// Unbiased random walk
	[step] (s=1 & x>=-ext+1) -> 1.0 : (x'=x-1) & (xx'=absx);
	[step] (s=2 & x<=ext-1) -> 1.0 : (x'=x+1) & (xx'=absx);

endmodule


rewards "steps"
	s!=0 : 1;
endrewards