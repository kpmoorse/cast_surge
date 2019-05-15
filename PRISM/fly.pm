dtmc

const double a = 0.1; // MC walk transition probability
const double b = 0.9; // Correct Cast<->Surge transition probability
const double c = 0.1; // Erroneous Cast<->Surge transition probability
const int ext = 100; // Arena extent
const int plume = 10; // Plume half-width
const int ang = 0;

const int x0;
const int y0 = 100;

module flystate

	// local state
	// 0 - Cast init
	// 1 - Cast left
	// 2 - Cast right
	// 3 - Surge
	// 4 - Failure
	// 5 - Success
	s : [0..5] init 0;
	x : [-ext..ext] init x0;
	y : [0..ext] init ext;
	
	// Randomly initialize direction
	[] s=0 -> 0.5 : (s'=1) + 0.5 : (s'=2);

	// If Cast, MC walk over directions
	[] s=1 -> 1-a : (s'=1) + a : (s'=2);
	[] s=2 -> a : (s'=1) + 1-a : (s'=2);

	// Change state based on stochastic plume sensing
	[] (s=1 | s=2) & (x>-plume & x<plume) -> b : (s'=3) + 1-b : (s'=s);
	[] (s=1 | s=2) & !(x>-plume & x<plume) -> c : (s'=3) + 1-c : (s'=s);
	[] s=3 & !(x>-plume & x<plume) -> b: (s'=0) + 1-b : (s'=s);
	[] s=3 & (x>-plume & x<plume) -> c: (s'=0) + 1-c : (s'=s);

	// If near target, success
	[] (s=1 | s=2 | s=3) & (x>-10 & x<10 & y<10) -> 1.0 : (s'=5);

	// If edge, fail
	[] s=1 & (x=-ext) -> 1.0 : (s'=4);
	[] s=2 & (x=ext)  -> 1.0 : (s'=4);
	[] s=3 & (y=0) -> 1.0 : (s'=4);

	// Increment location
	[] s=1 & (x!=-ext) -> 1.0 : (x'=x-1);
	[] s=2 & (x!=ext)  -> 1.0 : (x'=x+1);
	[] s=3 & (y!=0) -> 1.0 : (y'=y-1);

endmodule

rewards "steps"
	s!=0 : 1;
endrewards