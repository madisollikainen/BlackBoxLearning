#include"simpleGame.hpp"

	
// Constructor //
simpleGame::simpleGame(unsigned int n_pl, unsigned int n_g, unsigned int n_str, int s_step, double frg, double init_prop, double prodR){

		// Assign the number of players
		n_players = n_pl;

		// Assign the number of groups
		n_groups = n_g;

		// Assign the number of players in a group
		assert(n_players%n_groups == 0 && "Number of players must be a multiple of number of groups!");
		M = n_players/n_groups;

		// Assign the initial group_list
		for (int i=0; i < n_groups; i++){
			for(int j=0; j < M; j++){
				group_list.push_back(j); 
			}
		}		
		assert(group_list.size() == n_players && "Group list with wrong size!");

		// Assigne the productive coef.
		R = prodR;

		// Assign the payoff vector
		payoffs.assign(n_players, 0.0);

		// Assign the group sums
		group_sums.assign(n_groups, 0.0);	

		// Assign the number of strategies
		n_strategies = n_str;

		// Assign the strategy step
		str_step = s_step;

		// Assign the forgetfulness
		forgetfulness = frg;
		
		// Assign the initial propensities
		propensities.assign(n_players*n_strategies, init_prop);	

		// Assign the played_strategies vectors
		played_strategies.assign(n_players,0.0);

	
		// Initialize the Mersen Twister rng
		unsigned seed = std::chrono::system_clock::now().time_since_epoch().count();
		//std::cout << "seed: " << seed << std::endl;	
		mt_rng = std::mt19937(seed) ;

	}	

// Destructor //	
simpleGame::~simpleGame(){

	if ( str_out.is_open() ){ 
		str_out.close();
	}
	if ( payoff_out.is_open() ){ 
		payoff_out.close();
	}
	if ( prop_out.is_open() ){ 
		prop_out.close();
	}
		
}


// Methods && Functions //


// Init propensities -->> WORKS ONLY FOR:
// 					41 strategies with step 1 (0,1,2,3, ... ,40)
//				 	9 strategies with step 5 (0,5,10, ... ,40)
void simpleGame::init_propensities(double a_Big, double a_Small){


	// Assert that the number of strategies is 41 or 9
	assert(n_strategies == 41 || n_strategies == 9 && "init_propensities can't be used unless we have 41 or 9 strategies!'");


	// If 41 strategies: multiply the initial propensities for: 
	// 0,10,20,30,40 with a_BIG && 1,2,3,4,5,6,7,8,9 with a_SMALL
	if(n_strategies == 41){

		// Loop over players
		for (int i=0; i < n_players; i++){

			// Loop for the a_BIG
			for (int j=0; j < 5; j++ ){
				propensities[ i*n_strategies + j*10 ] = propensities[ i*n_strategies + j*10 ]*a_Big ;
			}

			// Loop for the a_SMALL
			for (int j=1; j < 10; j++ ){
				propensities[ i*n_strategies + j ] = propensities[ i*n_strategies + j ]*a_Small ;
			}
		}
		
	}
	// If 9 strategies: multiply the initial propensities for: 
	// 0,10,20,30,40 with a_BIG && 5 with a_SMALL
	else if(n_strategies == 9){

		// Loop over players
		for (int i=0; i < n_players; i++){

			// Loop for the a_BIG
			for (int j=0; j < 5; j++ ){
				propensities[ i*n_strategies + j*2 ] = propensities[ i*n_strategies + j*2 ]*a_Big ;
			}
			// And the single a_SMALL propensity for strategy 5
			propensities[ i*n_strategies + 1 ] = propensities[ i*n_strategies + 1 ]*a_Small ;

		}
		
	}


}

// Function to decied on the strategies
void simpleGame::decide_strategies(){

	// Loop over the players
	for (int i = 0; i < n_players; i++){

		// Generate a discrete probability distribution to draw from 
		std::discrete_distribution<int> prob_dist(propensities.begin() + (i*n_strategies), propensities.begin() + ( (i+1)*n_strategies ) );
		
		// Dicide on which strategy to take
		//int tmp =prob_dist(mt_rng);
		//std::cout << tmp << std::endl;
		played_strategies[i] = prob_dist(mt_rng);

	}

}


// Assign random groups
void simpleGame::assign_groups(){

	shuffle(group_list.begin(), group_list.end(), mt_rng);
	
}



// Sum over the groups
void simpleGame::sum_inputs(){

	// Reset the sums to zero
	for(int i=0; i < n_groups; i++){
		group_sums[i] = 0.0;
	}

	// Loop over the players
	for(int i=0; i < n_players; i++){
		group_sums[ group_list[i] ] += played_strategies[i];
	}	

}


// Function to get the payoffs
double simpleGame::get_payoff(int str, int group){

	return ( (n_strategies - 1) - str + R*group_sums[group] )*str_step;

}


// Assign payoffs
void simpleGame::assign_payoffs(){

	// Loop over the players
	for (int i = 0; i < n_players; i++){
		payoffs[i] = get_payoff(played_strategies[i], group_list[i]);
	}

}


// Learning --> update propensities of played strategies
void simpleGame::learning(){

	// Loop over players
	for (int i=0; i < n_players; i++){

		propensities[ i*n_strategies + played_strategies[i] ] += payoffs[i];

	}

}


// The forgetting function
void simpleGame::forget(){

	// Loop over the players && strategies
	for(int i=0; i<n_players*n_strategies; i++){
		propensities[i] = propensities[i]*(1.0 - forgetfulness);
	}

}
	

// Inti outputing
void simpleGame::init_output(bool print_prop){

	// The strategy outputing
	str_out.open("strategies.dat",ios::out|ios::trunc);
	if ( str_out.is_open() ){
		str_out << "# " << myTimeEngine.get_timestamp() << std::endl;
		str_out << "# Time\t\tStrategies of all players" << std::endl; 
	}

	// The payoff outputing
	payoff_out.open("payoffs.dat",ios::out|ios::trunc);
	if ( payoff_out.is_open() ){
		payoff_out << "# " << myTimeEngine.get_timestamp() << std::endl;
		payoff_out << "# Time\t\tPayoffs of all players" << std::endl; 
	}

	if(print_prop){
		// The propensity outputing
		prop_out.open("propensities.dat",ios::out|ios::trunc);
		if ( prop_out.is_open() ){
			prop_out << "# " << myTimeEngine.get_timestamp() << std::endl;
			prop_out << "# Rows: players && Columns: propensities of strategies" << std::endl; 
		}
	}
}


// Output the game-state
void simpleGame::print_output(bool print_prop, int t){

	// The strategy outputing
	if ( str_out.is_open() ){
		str_out << t << "\t"; 
		for (int S : played_strategies){
			str_out << S*str_step << "\t";
		}
		str_out << std::endl;
	}

	// The payoff outputing
	if ( payoff_out.is_open() ){
		payoff_out << t << "\t"; 
		for (int P : payoffs){
			payoff_out << P << "\t";
		}
		payoff_out << std::endl;
	}

	if(print_prop){
		// The propensity outputing
		if ( prop_out.is_open() ){
			prop_out << "#" << std::endl << "#\tt = " << t << std::endl << "#" << std::endl;
			for (int i=0; i < n_players; i++){
				for(int j=0; j < n_strategies; j++){
					prop_out << propensities[i*n_strategies + j] << "\t";
				}
				prop_out << std::endl;
			} 
		}
	}
}




























