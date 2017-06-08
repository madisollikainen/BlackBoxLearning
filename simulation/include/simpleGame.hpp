// --- Header file for the simpleGame class --- //


#ifndef SIMPLE_GAME_HPP
#define SIMPLE_GAME_HPP

#include <cassert>
#include <vector>
#include <random>
#include <chrono>
#include <algorithm>
#include <fstream>
#include <string>
#include <cassert>
#include <iostream>

#include "timeEngine.hpp"



class simpleGame{


	public:
	
	// --- Constructor && Destructor --- //

	simpleGame(unsigned int n_pl, unsigned int n_g,  unsigned int n_str, int s_step ,double frg, double init_prop, double R);
	~simpleGame();


	// --- Variables && Parameters --- //

	// Game parameters //
	
	// Number of players
	unsigned int n_players;

	// Number of groups
	unsigned int n_groups;

	// Number of players in a groups
	unsigned int M;
	
	// Number of strategies
	unsigned int n_strategies; 

	// Strategy 'step'
	int str_step;

	// The productive coef.
	double R;

	// The forgetfulness parameter
	double forgetfulness;


	// The variable vectors for the Game //

	// The group list
	std::vector<int> group_list;

	// A vector to hold the payoffs
	std::vector<double> payoffs;

	// A vector to hold the group_sums
	std::vector<double> group_sums;

	// The propensities
	std::vector<double> propensities;

	// The played strategies
	std::vector<int> played_strategies;	


	// --- RNG && fstreams --- //

	// The Mersen Twister RNG for the Game // 
	std::mt19937 mt_rng;	

	// The output streams
	std::fstream prop_out;
	std::fstream str_out;
	std::fstream payoff_out;

	// The timeEngine
	TimeEngine myTimeEngine;

	
	// --- Methods && Functions --- //

	// Init propensities -->> WORKS ONLY FOR:
	// 					41 strategies with step 1 (0,1,2,3, ... ,40)
	//				 	9 strategies with step 5 (0,5,10, ... ,40)
	void init_propensities(double a_Big, double a_Small);
	

	// Function to decied on the strategies
	void decide_strategies();

	// Assign random groups
	void assign_groups();

	// Sum over the groups
	void sum_inputs();

	// Function to calculate the payoffs
	double get_payoff(int str, int group);

	// Assign payoffs
	void assign_payoffs();

	// Learning --> update propensities of played strategies
	void learning();

	// Forget 
	void forget();
	
	// Inti outputing
	void init_output(bool print_prop);

	// Output the game-state
	void print_output(bool print_prop, int t);




	


};


#endif 
