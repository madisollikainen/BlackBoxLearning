# Set the Directory
#setwd("")      

# The data directory name
DATA_DIR <- "../data"

# Inlcude libraries etc.
require(lawstat)

# Define some parameters #
NSims <- 1
NTime <- 1000
NPlayers <- 16


# ----------------------------------------------- #

# Now let's work on the hypothesis testing on a single simulation #

# Number / ID of the simulation to use
# using_sim = 1

# Now define the limits for the 
start_seq <- c(1, 100)
end_seq <- c(800, 899)

# Open raw simulation data 
# The file names
FN_pof_04 <- paste(DATA_DIR,"/payoffs_R0.4_G",using_sim ,".dat",sep="") 
FN_pof_16 <- paste(DATA_DIR,"/payoffs_R1.6_G",using_sim ,".dat",sep="")
FN_str_04 <- paste(DATA_DIR,"/strategies_R0.4_G",using_sim ,".dat",sep="") 
FN_str_16 <- paste(DATA_DIR,"/strategies_R1.6_G",using_sim ,".dat",sep="")

# Open the data files 
POF_04 <- read.table(FN_pof_04, header=F)
POF_16 <- read.table(FN_pof_16, header=F)
STR_04 <- read.table(FN_str_04, header=F)
STR_16 <- read.table(FN_str_16, header=F)



# Now I'll make data frames for the hypothesis 

Inertia_04_b <- matrix(nrow = 100*NPlayers, ncol = 1)
Inertia_16_b <- matrix(nrow = 100*NPlayers, ncol = 1)
Inertia_04_e <- matrix(nrow = 100*NPlayers, ncol = 1)
Inertia_16_e <- matrix(nrow = 100*NPlayers, ncol = 1)

Success_04_b <- matrix(nrow = 100*NPlayers, ncol = 1)
Success_16_b <- matrix(nrow = 100*NPlayers, ncol = 1)
Success_04_e <- matrix(nrow = 100*NPlayers, ncol = 1)
Success_16_e <- matrix(nrow = 100*NPlayers, ncol = 1)

Inversion_04_b <- matrix(nrow = 100*NPlayers, ncol = 1)
Inversion_16_b <- matrix(nrow = 100*NPlayers, ncol = 1)
Inversion_04_e <- matrix(nrow = 100*NPlayers, ncol = 1)
Inversion_16_e <- matrix(nrow = 100*NPlayers, ncol = 1)

Adjustment_04_b <- matrix(nrow = 100*NPlayers, ncol = 1)
Adjustment_16_b <- matrix(nrow = 100*NPlayers, ncol = 1)
Adjustment_04_e <- matrix(nrow = 100*NPlayers, ncol = 1)
Adjustment_16_e <- matrix(nrow = 100*NPlayers, ncol = 1)

Adj_After_Pos_Adj_04_b <- matrix(nrow = 100*NPlayers, ncol = 1)
Adj_After_Pos_Adj_16_b <- matrix(nrow = 100*NPlayers, ncol = 1)
Adj_After_Pos_Adj_04_e <- matrix(nrow = 100*NPlayers, ncol = 1)
Adj_After_Pos_Adj_16_e <- matrix(nrow = 100*NPlayers, ncol = 1)

Adj_After_Neg_Adj_04_b <- matrix(nrow = 100*NPlayers, ncol = 1)
Adj_After_Neg_Adj_16_b <- matrix(nrow = 100*NPlayers, ncol = 1)
Adj_After_Neg_Adj_04_e <- matrix(nrow = 100*NPlayers, ncol = 1)
Adj_After_Neg_Adj_16_e <- matrix(nrow = 100*NPlayers, ncol = 1)



# --- LOOP OVER THE DATA --- #

# Loop over the players #
for(k in 2:length(POF_04)){
  
  # -- BEGINNING Seq -- #
  for (j in start_seq[1]:start_seq[2]){
    
    # Calulcate the vector position = player*time
    tmp <- (k-2)*( length(start_seq[1]:start_seq[2]) ) + (j - start_seq[1] + 1)
    
    # R = 0.4 #
    
    # Check IF succesful
    if(POF_04[j+1,k] >= POF_04[j,k]){
      Success_04_b[tmp] <- 1 # IF success -> 1
      #print("Success")
    } else {
      Success_04_b[tmp] <- 0 # IF NOT success -> 0
    }
    # Check for Inertia  
    if(STR_04[j+2,k] == STR_04[j+1,k]){ 
      Inertia_04_b[tmp] <- 1 # IF inertia -> 1
      #print(tmp)
    } else {
      Inertia_04_b[tmp] <- 0 # IF NOT inertia -> 0
      
      # Also IF NOT inertia -->> Check for inversion and store Adjustment
      Adjustment_04_b[tmp] <- (STR_04[j+2,k] - STR_04[j+1,k])

      if(STR_04[j+3,k] == STR_04[j+1,k]){ 
        Inversion_04_b[tmp] <- 1 # IF inversion -> 1
      } else {
        Inversion_04_b[tmp] <- 0 # IF NOT inversion -> 0
      }
      
      # Check IF the previous step had an POSITIVE or NEGATIVE Adjustment or NOT          
      # Check if there was a POSITIVE ADJUSTMENT
      if ( (STR_04[j+1,k] - STR_04[j,k]) > 0){
        Adj_After_Pos_Adj_04_b[tmp] <- (STR_04[j+2,k] - STR_04[j+1,k])
        
      # Check if there was a NEGATIVE ADJUSTMENT  
      } else if ( (STR_04[j+1,k] - STR_04[j,k]) < 0){
        Adj_After_Neg_Adj_04_b[tmp] <- (STR_04[j+2,k] - STR_04[j+1,k])
        
      }
      
    }   
    
    # R = 1.6 #
    
    # Check IF succesful
    if(POF_16[j+1,k] >= POF_16[j,k]){
      Success_16_b[tmp] <- 1 # IF success -> 1
    } else {
      Success_16_b[tmp] <- 0 # IF NOT success -> 0
    }
    # Check for Inertia  
    if(STR_16[j+2,k] == STR_16[j+1,k]){ 
      Inertia_16_b[tmp] <- 1 # IF inertia -> 1
    } else {
      Inertia_16_b[tmp] <- 0 # IF NOT inertia -> 0
      
      # Also IF NOT inertia -->> Check for inversion and store Adjustment
      Adjustment_16_b[tmp] <- (STR_16[j+2,k] - STR_16[j+1,k])
      
      if(STR_16[j+3,k] == STR_16[j+1,k]){ 
        Inversion_16_b[tmp] <- 1 # IF inversion -> 1
      } else {
        Inversion_16_b[tmp] <- 0 # IF NOT inversion -> 0
      }
      
      # Check IF the previous step had an POSITIVE or NEGATIVE Adjustment or NOT          
      # Check if there was a POSITIVE ADJUSTMENT
      if ( (STR_16[j+1,k] - STR_16[j,k]) > 0){
        Adj_After_Pos_Adj_16_b[tmp] <- (STR_16[j+2,k] - STR_16[j+1,k])
        
      # Check if there was a NEGATIVE ADJUSTMENT  
      } else if ( (STR_16[j+1,k] - STR_16[j,k]) < 0){
        Adj_After_Neg_Adj_16_b[tmp] <- (STR_16[j+2,k] - STR_16[j+1,k])
        
      }
      
    }  
    
  } # Loop over BEGINNING periods closed
  
  
  
  # -- END Seq -- #
  for (j in end_seq[1]:end_seq[2]){
    
    # Calulcate the vector position = player*time
    tmp <- (k-2)*( length(end_seq[1]:end_seq[2])  ) + (j - end_seq[1] + 1)
    
    # R = 0.4 #
    
    # Check IF succesful
    if(POF_04[j+1,k] >= POF_04[j,k]){
      Success_04_e[tmp] <- 1 # IF success -> 1
    } else {
      Success_04_e[tmp] <- 0 # IF NOT success -> 0
    }
    # Check for Inertia  
    if(STR_04[j+2,k] == STR_04[j+1,k]){ 
      Inertia_04_e[tmp] <- 1 # IF inertia -> 1
    } else {
      Inertia_04_e[tmp] <- 0 # IF NOT inertia -> 0
      
      # Also IF NOT inertia -->> Check for inversion and store Adjustment
      Adjustment_04_e[tmp] <- (STR_04[j+2,k] - STR_04[j+1,k])
      
      if(STR_04[j+3,k] == STR_04[j+1,k]){ 
        Inversion_04_e[tmp] <- 1 # IF inversion -> 1
      } else {
        Inversion_04_e[tmp] <- 0 # IF NOT inversion -> 0
      }
      
      # Check IF the previous step had an POSITIVE or NEGATIVE Adjustment or NOT          
      # Check if there was a POSITIVE ADJUSTMENT
      if ( (STR_04[j+1,k] - STR_04[j,k]) > 0){
        Adj_After_Pos_Adj_04_e[tmp] <- (STR_04[j+2,k] - STR_04[j+1,k])
        
      # Check if there was a NEGATIVE ADJUSTMENT  
      } else if ( (STR_04[j+1,k] - STR_04[j,k]) < 0){
        Adj_After_Neg_Adj_04_e[tmp] <- (STR_04[j+2,k] - STR_04[j+1,k])
        
      }
      
    }   
    
    # R = 1.6 #
    
    # Check IF succesful
    if(POF_16[j+1,k] >= POF_16[j,k]){
      Success_16_e[tmp] <- 1 # IF success -> 1
    } else {
      Success_16_e[tmp] <- 0 # IF NOT success -> 0
    }
    # Check for Inertia  
    if(STR_16[j+2,k] == STR_16[j+1,k]){ 
      Inertia_16_e[tmp] <- 1 # IF inertia -> 1
    } else {
      Inertia_16_e[tmp] <- 0 # IF NOT inertia -> 0
      
      # Also IF NOT inertia -->> Check for inversion and store Adjustment
      Adjustment_16_e[tmp] <- (STR_16[j+2,k] - STR_16[j+1,k])
      
      if(STR_16[j+3,k] == STR_16[j+1,k]){ 
        Inversion_16_e[tmp] <- 1 # IF inversion -> 1
      } else {
        Inversion_16_e[tmp] <- 0 # IF NOT inversion -> 0
      }
      
      # Check IF the previous step had an POSITIVE or NEGATIVE Adjustment or NOT          
      # Check if there was a POSITIVE ADJUSTMENT
      if ( (STR_16[j+1,k] - STR_16[j,k]) > 0){
        Adj_After_Pos_Adj_16_e[tmp] <- (STR_16[j+2,k] - STR_16[j+1,k])
        
        # Check if there was a NEGATIVE ADJUSTMENT  
      } else if ( (STR_16[j+1,k] - STR_16[j,k]) < 0){
        Adj_After_Neg_Adj_16_e[tmp] <- (STR_16[j+2,k] - STR_16[j+1,k])
        
      }
      
    }  
    
  } # Loop over END periods closed 
  
} # Loop over players closed



# --- CHECK IF RESULTS MATCH && STORE OCCURENCES --- # 

NotInertia_04_b <- which( Inertia_04_b==0 )
NotInertia_16_b <- which( Inertia_16_b==0 )
NotInertia_04_e <- which( Inertia_04_e==0 )
NotInertia_16_e <- which( Inertia_16_e==0 )

IsAdjustment_04_b <- which( !is.na(Adjustment_04_b) )
IsAdjustment_16_b <- which( !is.na(Adjustment_16_b) )
IsAdjustment_04_e <- which( !is.na(Adjustment_04_e) )
IsAdjustment_16_e <- which( !is.na(Adjustment_16_e) )

IsInversion_04_b <- which( !is.na(Inversion_04_b) )
IsInversion_16_b <- which( !is.na(Inversion_16_b) )
IsInversion_04_e <- which( !is.na(Inversion_04_e) )
IsInversion_16_e <- which( !is.na(Inversion_16_e) )

# print ( all(NotInertia_04_b == IsAdjustment_04_b))
# print ( all(NotInertia_16_b == IsAdjustment_16_b))
# print ( all(NotInertia_04_e == IsAdjustment_04_e))
# print ( all(NotInertia_16_e == IsAdjustment_16_e))
# 
# print ( all(NotInertia_04_b == IsInversion_04_b))
# print ( all(NotInertia_16_b == IsInversion_16_b))
# print ( all(NotInertia_04_e == IsInversion_04_e))
# print ( all(NotInertia_16_e == IsInversion_16_e))


# Also store: a) Where did Adjustment after Positive Adjustment take place
#             b) Where did Adjustment after Negative Adjustment take place             

IsAdj_After_Pos_Adj_04_b <- which( !is.na(Adj_After_Pos_Adj_04_b) )
IsAdj_After_Pos_Adj_16_b <- which( !is.na(Adj_After_Pos_Adj_16_b) )
IsAdj_After_Pos_Adj_04_e <- which( !is.na(Adj_After_Pos_Adj_04_e) )
IsAdj_After_Pos_Adj_16_e <- which( !is.na(Adj_After_Pos_Adj_16_e) )

IsAdj_After_Neg_Adj_04_b <- which( !is.na(Adj_After_Neg_Adj_04_b) )
IsAdj_After_Neg_Adj_16_b <- which( !is.na(Adj_After_Neg_Adj_16_b) )
IsAdj_After_Neg_Adj_04_e <- which( !is.na(Adj_After_Neg_Adj_04_e) )
IsAdj_After_Neg_Adj_16_e <- which( !is.na(Adj_After_Neg_Adj_16_e) )



# --- CREATE DATA.FRAME-s FOR HYPOTHESIS TESTING --- #


# INERTIA data #

data_Inertia_04_b <- data.frame(Inertia = Inertia_04_b, Success = Success_04_b)
data_Inertia_16_b <- data.frame(Inertia = Inertia_16_b, Success = Success_16_b)
data_Inertia_04_e <- data.frame(Inertia = Inertia_04_e, Success = Success_04_e)
data_Inertia_16_e <- data.frame(Inertia = Inertia_16_e, Success = Success_16_e)


# INVERSION data #

data_Inversion_04_b <- data.frame(Inversion = Inversion_04_b[ IsInversion_04_b ],
                                  Success = Success_04_b[ IsInversion_04_b ]) 

data_Inversion_16_b <- data.frame(Inversion = Inversion_16_b[ IsInversion_16_b ],
                                  Success = Success_16_b[ IsInversion_16_b ]) 

data_Inversion_04_e <- data.frame(Inversion = Inversion_04_e[ IsInversion_04_e ],
                                  Success = Success_04_e[ IsInversion_04_e ]) 

data_Inversion_16_e <- data.frame(Inversion = Inversion_16_e[ IsInversion_16_e ],
                                  Success = Success_16_e[ IsInversion_16_e ])  


# ASYMETRIC VOLATILITY data #

Adj_Success_04_b <- Adjustment_04_b[ intersect( IsAdjustment_04_b, which(Success_04_b==1) ) ]
Adj_Fail_04_b <- Adjustment_04_b[ intersect( IsAdjustment_04_b, which(Success_04_b==0) ) ]

Adj_Success_16_b <- Adjustment_16_b[ intersect( IsAdjustment_16_b, which(Success_16_b==1) ) ]
Adj_Fail_16_b <- Adjustment_16_b[ intersect( IsAdjustment_16_b, which(Success_16_b==0) ) ]

Adj_Success_04_e <- Adjustment_04_e[ intersect( IsAdjustment_04_e, which(Success_04_e==1) ) ]
Adj_Fail_04_e <- Adjustment_04_e[ intersect( IsAdjustment_04_e, which(Success_04_e==0) ) ]

Adj_Success_16_e <- Adjustment_16_e[ intersect( IsAdjustment_16_e, which(Success_16_e==1) ) ]
Adj_Fail_16_e <- Adjustment_16_e[ intersect( IsAdjustment_16_e, which(Success_16_e==0) ) ]



# ASYMETRIC BREADTH data #

data_Abs_Adj_04_b <- data.frame(Abs_Adjustment = abs( Adjustment_04_b[ IsAdjustment_04_b ] ),
                                Success = Success_04_b[ IsAdjustment_04_b ] )

data_Abs_Adj_16_b <- data.frame(Abs_Adjustment = abs( Adjustment_16_b[ IsAdjustment_16_b ] ),
                                Success = Success_16_b[ IsAdjustment_16_b ] )

data_Abs_Adj_04_e <- data.frame(Abs_Adjustment = abs( Adjustment_04_e[ IsAdjustment_04_e ] ),
                                Success = Success_04_e[ IsAdjustment_04_e ] )

data_Abs_Adj_16_e <- data.frame(Abs_Adjustment = abs( Adjustment_16_e[ IsAdjustment_16_e ] ),
                                Success = Success_16_e[ IsAdjustment_16_e ] )



# DIRECTIONAL BIAS data #

data_Adj_after_Pos_Adj_04_b <- data.frame(Adjustment = Adj_After_Pos_Adj_04_b[ IsAdj_After_Pos_Adj_04_b ],
                                          Success = Success_04_b[ IsAdj_After_Pos_Adj_04_b ])
data_Adj_after_Neg_Adj_04_b <- data.frame(Adjustment = Adj_After_Neg_Adj_04_b[ IsAdj_After_Neg_Adj_04_b ],
                                          Success = Success_04_b[ IsAdj_After_Neg_Adj_04_b ])

data_Adj_after_Pos_Adj_16_b <- data.frame(Adjustment = Adj_After_Pos_Adj_16_b[ IsAdj_After_Pos_Adj_16_b ],
                                          Success = Success_16_b[ IsAdj_After_Pos_Adj_16_b ])
data_Adj_after_Neg_Adj_16_b <- data.frame(Adjustment = Adj_After_Neg_Adj_16_b[ IsAdj_After_Neg_Adj_16_b ],
                                          Success = Success_16_b[ IsAdj_After_Neg_Adj_16_b ])


data_Adj_after_Pos_Adj_04_e <- data.frame(Adjustment = Adj_After_Pos_Adj_04_e[ IsAdj_After_Pos_Adj_04_e ],
                                          Success = Success_04_e[ IsAdj_After_Pos_Adj_04_e ])
data_Adj_after_Neg_Adj_04_e <- data.frame(Adjustment = Adj_After_Neg_Adj_04_e[ IsAdj_After_Neg_Adj_04_e ],
                                          Success = Success_04_e[ IsAdj_After_Neg_Adj_04_e ])

data_Adj_after_Pos_Adj_16_e <- data.frame(Adjustment = Adj_After_Pos_Adj_16_e[ IsAdj_After_Pos_Adj_16_e ],
                                          Success = Success_16_e[ IsAdj_After_Pos_Adj_16_e ])
data_Adj_after_Neg_Adj_16_e <- data.frame(Adjustment = Adj_After_Neg_Adj_16_e[ IsAdj_After_Neg_Adj_16_e ],
                                          Success = Success_16_e[ IsAdj_After_Neg_Adj_16_e ])

# --- HYPOTHESIS TESTING --- #

# INERTIA -->> ORDERED PROBIT REGRESSION #

# R = 0.4 Beginning
hypo_Inertia_04_b <- glm(Inertia ~ Success,
                         data=data_Inertia_04_b,
                         family=binomial(link="probit"))
summary(hypo_Inertia_04_b)

# R = 1.6 Beginning
hypo_Inertia_16_b <- glm(Inertia ~ Success,
                         data=data_Inertia_16_b,
                         family=binomial(link="probit"))
summary(hypo_Inertia_16_b)

# R = 0.4 End
hypo_Inertia_04_e <- glm(Inertia ~ Success,
                         data=data_Inertia_04_e,
                         family=binomial(link="probit"))
summary(hypo_Inertia_04_e)

# R = 1.6 End
hypo_Inertia_16_e <- glm(Inertia ~ Success,
                         data=data_Inertia_16_e,
                         family=binomial(link="probit"))
summary(hypo_Inertia_16_e)



# INVERSION -->> ORDERED PROBIT REGRESSION #

# R = 0.4 Beginning
hypo_Inversion_04_b <- glm(Inversion ~ Success,
                         data=data_Inversion_04_b,
                         family=binomial(link="probit"))
summary(hypo_Inversion_04_b)

# R = 1.6 Beginning
hypo_Inversion_16_b <- glm(Inversion ~ Success,
                           data=data_Inversion_16_b,
                           family=binomial(link="probit"))
summary(hypo_Inversion_16_b)

# R = 0.4 End
hypo_Inversion_04_e <- glm(Inversion ~ Success,
                           data=data_Inversion_04_e,
                           family=binomial(link="probit"))
summary(hypo_Inversion_04_e)

# R = 1.6 End
hypo_Inversion_16_e <- glm(Inversion ~ Success,
                           data=data_Inversion_16_e,
                           family=binomial(link="probit"))
summary(hypo_Inversion_16_e)


# ASYMETRIC VOLATILITY -->> LEVINE's TEST + VARIANCE CALCULATION #

# R = 0.4 Beginning
IN_data <- c(Adj_Success_04_b, Adj_Fail_04_b)
IN_group <- as.factor(c(rep(1, length(Adj_Success_04_b)), rep(2, length(Adj_Fail_04_b))))

hypo_Asym_Volatility_04_b <- levene.test(IN_data, IN_group)
var_Adj_Success_04_b <- var(Adj_Success_04_b)
var_Adj_Fail_04_b <- var(Adj_Fail_04_b)


# R = 1.6 Beginning
IN_data <- c(Adj_Success_16_b, Adj_Fail_16_b)
IN_group <- as.factor(c(rep(1, length(Adj_Success_16_b)), rep(2, length(Adj_Fail_16_b))))

hypo_Asym_Volatility_16_b <- levene.test(IN_data, IN_group)
var_Adj_Success_16_b <- var(Adj_Success_16_b)
var_Adj_Fail_16_b <- var(Adj_Fail_16_b)


# R = 0.4 End
IN_data <- c(Adj_Success_04_e, Adj_Fail_04_e)
IN_group <- as.factor(c(rep(1, length(Adj_Success_04_e)), rep(2, length(Adj_Fail_04_e))))

hypo_Asym_Volatility_04_e <- levene.test(IN_data, IN_group)
var_Adj_Success_04_e <- var(Adj_Success_04_e)
var_Adj_Fail_04_e <- var(Adj_Fail_04_e)


# R = 1.6 Beginning
IN_data <- c(Adj_Success_16_e, Adj_Fail_16_e)
IN_group <- as.factor(c(rep(1, length(Adj_Success_16_e)), rep(2, length(Adj_Fail_16_e))))

hypo_Asym_Volatility_16_e <- levene.test(IN_data, IN_group)
var_Adj_Success_16_e <- var(Adj_Success_16_e)
var_Adj_Fail_16_e <- var(Adj_Fail_16_e)



# ASYMETRIC BREADTH -->> LINEAR REGRESSION of Absolute Adjustments vs. Success #

# R = 0.4 Beginning
hypo_Asym_Breadth_04_b <- lm(Abs_Adjustment ~ Success, data=data_Abs_Adj_04_b)
summary(hypo_Asym_Breadth_04_b)

# R = 1.6 Beginning
hypo_Asym_Breadth_16_b <- lm(Abs_Adjustment ~ Success, data=data_Abs_Adj_16_b)
summary(hypo_Asym_Breadth_16_b)

# R = 0.4 End
hypo_Asym_Breadth_04_e <- lm(Abs_Adjustment ~ Success, data=data_Abs_Adj_04_e)
summary(hypo_Asym_Breadth_04_e)

# R = 1.6 End
hypo_Asym_Breadth_16_e <- lm(Abs_Adjustment ~ Success, data=data_Abs_Adj_16_e)
summary(hypo_Asym_Breadth_16_e)



# DIRECTIONAL BIAS -->> LINEAR REGRESSION of Adjustment vs. Success #

# R = 0.4 Beginning
hypo_Directinal_Bias_Pos_04_b <- lm(Adjustment ~ Success, data=data_Adj_after_Pos_Adj_04_b)
summary(hypo_Directinal_Bias_Pos_04_b)

hypo_Directinal_Bias_Neg_04_b <- lm(Adjustment ~ Success, data=data_Adj_after_Neg_Adj_04_b)
summary(hypo_Directinal_Bias_Neg_04_b)


# R = 1.6 Beginning
hypo_Directinal_Bias_Pos_16_b <- lm(Adjustment ~ Success, data=data_Adj_after_Pos_Adj_16_b)
summary(hypo_Directinal_Bias_Pos_16_b)

hypo_Directinal_Bias_Neg_16_b <- lm(Adjustment ~ Success, data=data_Adj_after_Neg_Adj_16_b)
summary(hypo_Directinal_Bias_Neg_16_b)


# R = 0.4 End
hypo_Directinal_Bias_Pos_04_e <- lm(Adjustment ~ Success, data=data_Adj_after_Pos_Adj_04_e)
summary(hypo_Directinal_Bias_Pos_04_e)

hypo_Directinal_Bias_Neg_04_e <- lm(Adjustment ~ Success, data=data_Adj_after_Neg_Adj_04_e)
summary(hypo_Directinal_Bias_Neg_04_e)


# R = 1.6 End
hypo_Directinal_Bias_Pos_16_e <- lm(Adjustment ~ Success, data=data_Adj_after_Pos_Adj_16_e)
summary(hypo_Directinal_Bias_Pos_16_e)

hypo_Directinal_Bias_Neg_16_e <- lm(Adjustment ~ Success, data=data_Adj_after_Neg_Adj_16_e)
summary(hypo_Directinal_Bias_Neg_16_e)


































