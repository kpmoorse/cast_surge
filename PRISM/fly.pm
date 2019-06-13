dtmc

const double a = 0.1; // MC walk transition probability
const double b = 0.9; // Correct Cast<->Surge transition probability
const double c = 0.1; // Erroneous Cast<->Surge transition probability
const double d = 0.1; // Arena return probability per step
const double f = 0.7; // Probability of flying in desired direction
const int ext = 100; // Arena extent
const int plume = 10; // Plume half-width
const int cref; // Cast refractory period length, in steps
const int sref; // Surge refractory period length, in steps
const int ang = 0;

// Define uninitialized variables
const int x0;
const int y0;

// Define boundary formulae
formula inb_x = x>=-ext+1 & x <=ext-1;
formula inb_y = y>=1 & y <=ext-1;
formula intgt = (pow(x,2)+pow(y,2)<pow(10,2));
formula edgeL = x=-ext;
formula edgeR = x=ext;

// Define absolute value
formula signx = x>0 ? 1:-1;
formula absx = x*signx;

// Define detection probability
const double pi = 3.14159; // Mathematical constant
const double e = 2.71828; // Mathematical constant
const double m = 1/10; // Slope of Gaussian diffusion
const double sig0 = 3; // Initial stdev
formula sig = m*y + sig0; // Scale parameter of odor dist. (sig = sig(y))
formula od = min(1, sig0/sig * pow(e, -pow(x,2)/(2*pow(sig,2)))); // Odor dist (od = od(x,y), on [0,1])

// Define end-state labels
label "fail" = s=5;
label "success" = s=6;

module flystate

	// Local state
	// 0 - Cast init
	// 1 - Cast left
	// 2 - Cast right
	// 3 - Cast out-of-bounds
	// 4 - Surge
	// 5 - Failure
	// 6 - Success
	s : [0..6] init 0;
	// Refractory period
	r : [0..max(cref, sref)] init 0;
	
	// Randomly initialize direction
	[ini] (inb_x & s=0) -> 0.5 : (s'=1) + 0.5 : (s'=2);

	// If out-of-bounds, begin return checks
	[return] (!inb_x & (s=1 | s=2 | s=4)) -> 1.0 : (s'=3);
	[return] (!inb_x & s=3) -> 1.0 : (s'=s);
	[return] (inb_x & s=3) -> 1.0 : (s'=(x>0?1:2));

	// If Cast, switch to Surge or MC walk over direction
	[step] (inb_x & !intgt & r=0 & (s=1 | s=2)) -> od : (s'=4) & (r'=sref) + (1-od)*(1-a) : (s'=s) + (1-od)*(a) : (s'=3-s);
	[step] (inb_x & !intgt & r>=1 & (s=1 | s=2)) -> od : (s'=s) & (r'=r-1) + (1-od) : (s'=s) & (r'=cref);
	// If Surge, continue surging or switch to Cast 
	[step] (inb_x & !intgt & r=0 & s=4 & y>=0) -> od : (s'=s) + 1-od : (s'=0) & (r'=cref);
	[step] (inb_x & !intgt & r>=1 & s=4 & y>=0) -> od : (s'=s) & (r'=sref) + 1-od : (s'=s) & (r'=r-1);

	// If near target, success
	[end] (inb_x & intgt & (s=1 | s=2 | s=4)) -> 1.0 : (s'=6);

	// If past target, fail
	[end] (inb_x & (s=1 | s=2 | s=4) & y=0) -> 1.0 : (s'=5);

endmodule

module flyloc

	// X & Y cartesian coordinates
	x : [-ext..ext] init x0;
	y : [0..ext] init y0;

	// Cast left & right
	[step] (inb_x & inb_y & s=1) -> f : (x'=x-1) + (1-f)/2 : (y'=y-1) + (1-f)/2 : (y'=y+1);
	[step] (inb_x & y=ext & s=1) -> f : (x'=x-1) + (1-f) : (y'=y-1);

	[step] (inb_x & inb_y & s=2) -> f : (x'=x+1) + (1-f)/2 : (y'=y-1) + (1-f)/2 : (y'=y+1);
	[step] (inb_x & y=ext & s=2) -> f : (x'=x+1) + (1-f) : (y'=y-1);

	// Surge
	[step] (inb_x & s=4 & y!=0) -> f : (y'=y-1) + (1-f)/2 : (x'=x-1) + (1-f)/2 : (x'=x+1);

	// Return from outside arena in exp. dist. time
	[return] (!inb_x) -> d : (x'=x+(x>0?-1:1)) + 1-d : (x'=x);
	[return] (inb_x) -> 1.0 : (x'=x+(x>0?-1:1));

endmodule

rewards "steps"
	[step] true : 1;
	[return] true : 1;
endrewards