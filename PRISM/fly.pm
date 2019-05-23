dtmc

const double a = 0.5; // MC walk transition probability
const double b = 0.9; // Correct Cast<->Surge transition probability
const double c = 0.1; // Erroneous Cast<->Surge transition probability
const double d = 0.1; // Arena return probability per step
const int ext = 100; // Arena extent
const int plume = 10; // Plume half-width
const int ang = 0;

// Define uninitialized variables
const int x0;
const int y0;

// Define boundary formulae
formula inbounds = x>=-ext+1 & x <=ext-1;
formula edgeL = x=-ext;
formula edgeR = x=ext;

formula signx = x>0 ? 1:-1;
formula absx = x*signx;

// Define deadlock labels
label "fail" = s=5;
label "success" = s=6;

module flystate

	// local state
	// 0 - Cast init
	// 1 - Cast left
	// 2 - Cast right
	// 3 - Cast out-of-bounds
	// 4 - Surge
	// 5 - Failure
	// 6 - Success
	s : [0..6] init 0;
	
	// Randomly initialize direction
	[ini] (inbounds & s=0) -> 0.5 : (s'=1) + 0.5 : (s'=2);

	// If Cast, MC walk over directions
	[step] (inbounds & (s=1 | s=2)) -> 1-a : (s'=s) + a : (s'=3-s);

	// If out-of-bounds, begin return checks
	[return] (!inbounds & (s=1 | s=2 | s=4)) -> 1.0 : (s'=3);
	[return] (!inbounds & s=3) -> 1.0 : (s'=s);
	[return] (inbounds & s=3) -> 1.0 : (s'=(x>0?1:2));

	// Change state based on stochastic plume sensing
	[step] (inbounds & (s=1 | s=2) & (x>-plume & x<plume)) -> b : (s'=4) + 1-b : (s'=s);
	[step] (inbounds & (s=1 | s=2) & !(x>-plume & x<plume)) -> c : (s'=4) + 1-c : (s'=s);
	[step] (inbounds & s=4 & !(x>-plume & x<plume)) -> b: (s'=0) + 1-b : (s'=s);
	[step] (inbounds & s=4 & (x>-plume & x<plume)) -> c: (s'=0) + 1-c : (s'=s);

	// If near target, success
	[end] (inbounds & (s=1 | s=2 | s=4) & (pow(x,2)+pow(y,2)<pow(10,2))) -> 1.0 : (s'=6);

	// If past target, fail
	[end] (inbounds & s=4 & y=0) -> 1.0 : (s'=5);

endmodule

module flyloc

	// X & Y cartesian coordinates
	x : [-ext..ext] init x0;
	y : [0..ext] init ext;

	// Cast & surge
	[step] (inbounds & s=1) -> 1.0 : (x'=x-1);
	[step] (inbounds & s=2) -> 1.0 : (x'=x+1);
	[step] (s=4 & y!=0) -> 1.0 : (y'=y-1);

	// Return from outside arena in exp. dist. time
	[return] (!inbounds) -> d : (x'=x+(x>0?-1:1)) + 1-d : (x'=x);
	[return] (inbounds) -> 1.0 : (x'=x+(x>0?-1:1));

endmodule

rewards "steps"
	[step] true : 1;
	[return] true : 1;
endrewards