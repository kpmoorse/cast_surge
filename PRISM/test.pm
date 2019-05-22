dtmc

const int ext = 100; // Arena size
const double a = 0.2; // Levy flight transition probability

module walker

	// Update flag (true=state, false=coords)
	z : bool init true;
	// local state
	s : [0..2] init 0;
	// Bounded location
	x : [-ext..ext] init 0;
	
	// Initialize direction
	[] (z=true & s=0) -> 0.5 : (s'=1) & (z'=false) + 0.5 : (s'=2) & (z'=false);

	// Update local state
	[] (z=true & s!=0 & x<=-ext) -> 1.0 : (s'=2) & (z'=false);
	[] (z=true & s!=0 & x>=ext) -> 1.0 : (s'=1) & (z'=false);
	[] (z=true & s!=0 & x>=-ext+1 & x<=ext-1) -> a : (s'=3-s) & (z'=false) + 1-a : (s'=s) & (z'=false);

	// Unbiased random walk
	[] (z=false & s=1) -> (x'=x-1) & (z'=true);
	[] (z=false & s=2) -> (x'=x+1) & (z'=true);
	
endmodule

rewards "steps"
	s!=0 & z=false : 1;
endrewards