# BlackBoxLearning

This repo holds the simulation and analysis code for the Black Box learning project I wrote when working for Dr. Heinrich Nax in ETHZ Computational Social Science group. The simulations here were done to support Heinrichs experimental work on studing the behaviour of agents in a repeated game, where the agents had no information of the underlying sturcture of the game. Several hypothesis were tested on the experimental data. The aim of the simulation code presented here, was to test if simple agents who updated their strategy by learning with the reinforced learning paradigma, would produce similar results as the people who participated in the experiment.  

For more information regarding the studies see the paper by H. Nax *et al* (https://doi.org/10.1016/j.jebo.2016.04.006).


## Compilation info

The simulation code has been tested on Ubuntu 16.04 using GNU C++ compiler (version 5.4.0). If you have `make` installed, then compiling the simulation code is simple

```
cd ./simulation
make
cd ../
```

As the code is very light-weight, the compilation can also be easilly done without make. For example, using GNU compiler

```
cd ./simulation
g++ -std=c++11 -Wall -o build/run-black-box-learning src/*.cpp -Iinclude
cd ../
```

## Running 

If you have followed the above guides for compilation, you should have an executable `simulation/build/run-black-box-learning`. The simulation takes quite a few commandline inputs, all of which have default values. Currently a nice and detailed documentation for the commandline inputs has not been written. All of the inputs and their corresponding flags can be found in the file `/simulation/src/main.cpp`. Many of the variables are rather stright forward, however for some it would be best to consult the code and/or the paper by H. Nax *et al* (https://doi.org/10.1016/j.jebo.2016.04.006).  

There are a few scripts included which will help run the simulation for different random number generator seed, as well as automatically generate a short summary of the hypothesis anallysis on the simulations. The script `run-sim.sh` takes as an input the number of simulations you wish to run (with different RNG seeds), it runs the simulations and takes care to collect, rename and store the output files to the directory `data`, which is created if it doesn't exict already. For example, if you wish to run 10 different simulation type 

```
./run-sim.sh 10
```    


## Code history

This code was written a few years before I uploaded it to github; unfortunately the only commite/push history available is related to the cosmetic changes I've made to make this code more presentable. 