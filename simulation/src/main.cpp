// --- MAIN function for the simpleGame simulation --- //

// C++ STD includes //
//#include <iostream>

// MY includes //
#include"simpleGame.hpp"
#include"readcmd.h"



int main (int argc, char* argv[]){

	// --- Read Command Line Inputs --- //

	// Simulation lenght --> number of iteration/time steps TM
	int seed = 433; 
	if(cmdOptionExists(argv, argv+argc, "-seed"))
	    {
		char * tmp = getCmdOption(argv, argv + argc, "-seed");
		seed = atoi(tmp); 
	    }
	
	// Simulation lenght --> number of iteration/time steps TM
	int TM = 1000; 
	if(cmdOptionExists(argv, argv+argc, "-t"))
	    {
		char * tmp = getCmdOption(argv, argv + argc, "-t");
		TM = atoi(tmp); 
	    }

	// How often to print out the results
	int TP = 10; 
	if(cmdOptionExists(argv, argv+argc, "-TP"))
	    {
		char * tmp = getCmdOption(argv, argv + argc, "-TP");
		TP = atoi(tmp); 
	    }
	
	// Number of players
	int NP = 16; 
	if(cmdOptionExists(argv, argv+argc, "-NP"))
	    {
		char * tmp = getCmdOption(argv, argv + argc, "-NP");
		NP = atoi(tmp); 
	    }

	// Number of groups
	int NG = 4; 
	if(cmdOptionExists(argv, argv+argc, "-NG"))
	    {
		char * tmp = getCmdOption(argv, argv + argc, "-NG");
		NG = atoi(tmp); 
	    }

	// Number of strategies: ALLOW ONLY 41 OR 9
	int NS = 41; 
	if(cmdOptionExists(argv, argv+argc, "-NS9"))
	    {
		NS = 9; 
	    }

	// Difference between two strategies --> the 'strategy step': ALLOW ONLY 1 OR 5 (dependent on the NS)
	int dS = 1; 
	if(cmdOptionExists(argv, argv+argc, "-NS9"))
	    {
		dS = 5; 
	    }

	// The forgetfulness
	double F = 0.01; 
	if(cmdOptionExists(argv, argv+argc, "-F"))
	    {
		char * tmp = getCmdOption(argv, argv + argc, "-F");
		F = atof(tmp); 
	    }

	// The initial propensities
	double P0 = 100; 
	if(cmdOptionExists(argv, argv+argc, "-P0"))
	    {
		char * tmp = getCmdOption(argv, argv + argc, "-P0");
		P0 = atof(tmp); 
	    }

	// The productivity of the game
	double R = 0.4; 
	if(cmdOptionExists(argv, argv+argc, "-R"))
	    {
		char * tmp = getCmdOption(argv, argv + argc, "-R");
		R = atof(tmp); 
	    }

	// Boolian to check if we use the init_propensities
	bool initPROP = true; 
	if(cmdOptionExists(argv, argv+argc, "-U"))
	    {
		initPROP = false; 
	    }

	// The a_BIG for the init_propensities
	double aB = 1.5; 
	if(cmdOptionExists(argv, argv+argc, "-aB"))
	    {
		char * tmp = getCmdOption(argv, argv + argc, "-aB");
		aB = atof(tmp); 
	    }
	// The a_SMALL for the init_propensities
	double aS = 1.2; 
	if(cmdOptionExists(argv, argv+argc, "-aS"))
	    {
		char * tmp = getCmdOption(argv, argv + argc, "-aS");
		aS = atof(tmp); 
	    }

	// Boolian to control if the propensities are printed or not
	bool printProp = false; 
	if(cmdOptionExists(argv, argv+argc, "-PP"))
	    {
		printProp = true; 
	    }

	
	// --- Intialize the Game and the outputs --- //

	// Initialize the game
	simpleGame myGame(NP, NG, NS, dS, F, P0, R, seed);

	// Initialize the outputing
	myGame.init_output(printProp);

	// IF initPROP == true, we use the init_propensities
	if (initPROP){
		
		myGame.init_propensities(aB, aS);

	}



	// --- Play the game --- //

	// Start the time
	int t = 0;

	// Loop over the time
	while (t < TM){

		// Increas time 
		t++;

		// All player decide on a strategy
		myGame.decide_strategies(); 

		// Randomly assign players to groups
		myGame.assign_groups();

		// Sum the inputs for each group
		myGame.sum_inputs();

		// Calculate the payoffs
		myGame.assign_payoffs();

		if (t%TP==0 || t == 1){
			// Output the game state
			myGame.print_output(printProp, t);
		}


		// Reinforced learning --> played strategies 
		// have their propensities updated
		myGame.learning();

		// Forgeting --> all strategies have their
		// propensities lowered a bit
		myGame.forget();

	}


	return 0;
}
