#!/bin/bash

# Get the simulation number
SIM_NR=$1

# If need be make reports dir
mkdir -p reports

Rscript -e " setwd('${PWD}/analysis-scripts') ; library(knitr); using_sim <- ${SIM_NR} ; knit2pdf('black-box-learning-summary.Rnw', clean = TRUE)"

# Rename the summary
mv ${PWD}/analysis-scripts/black-box-learning-summary.pdf reports/black-box-learning-summary-sim-nr-${SIM_NR}.pdf

# Clean the .tex file 
rm ${PWD}/analysis-scripts/black-box-learning-summary.tex