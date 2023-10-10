#!/bin/bash

###########################################################################################-
###########################################################################################-
##
## Running all data export scripts
##
###########################################################################################-
###########################################################################################-

#-----------------------------------------------------------------------------------------#
# setup
#-----------------------------------------------------------------------------------------#

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - #
# get parent dir for absolute path
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - #

base_dir=$(pwd)
export base_dir=$base_dir

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - #
# set server based on computer name
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - #

if [ "$COMPUTERNAME" == "DESKTOP-PU7DGC1" ]; then
  export server="DESKTOP-PU7DGC1"
else
  export server="SQLIT04A"
fi

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - #
# make sure you're on the right branch
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - #

current_branch=$(git rev-parse --abbrev-ref HEAD)

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - #
# Choose database to use
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - #

if [ -z "$data_env" ]; then

  # if $data_env doesn't exist yet, ask about setting it
  echo "-------------------------------------------------------------"
  echo ">> 1: 'data_env' does not exist"

  echo "-------------------------------------------------------------"
  read -p "staging [*s] or production [p]? -- " -n 1 data_env_input
  printf "\n"

  export data_env=${data_env_input:-"s"}  # default to staging if nothing entered

  if [ "$data_env" == "s" ] && [ "$current_branch" != "staging" ]; then

    # ask about switching
    echo "-------------------------------------------------------------"
    echo ">> 3: 'data_env = s', not on <staging> branch"

    echo "-------------------------------------------------------------"
    read -p "Switch to <staging>? Yes [y] / No [*n] -- " -n 1 switch
    printf "\n"

    # switch branch, or not

    if [ "$switch" == "y" ]; then

      echo "-------------------------------------------------------------"
      echo ">> 4: 'switch = y', switching to <staging> branch"

      git checkout staging
      git pull

    elif [ "$switch" == "n" ]; then

      # don't switch
      echo "-------------------------------------------------------------"
      echo ">> 4: 'switch = n', staying on <$current_branch> branch"

    else

      # don't switch
      echo "-------------------------------------------------------------"
      echo ">> 4: 'switch = []', staying on <$current_branch> branch"

    fi

  elif [ "$data_env" == "p" ] && [ "$current_branch" != "production" ]; then

    # ask about switching
    echo "-------------------------------------------------------------"
    echo ">> 3: 'data_env = p', not on <production> branch"

    echo "-------------------------------------------------------------"
    read -p "Switch to <production> ? Yes [y] / No [*n] -- " -n 1 switch
    printf "\n"

    # switch branch, or not

    if [ "$switch" == "y" ]; then

      echo "-------------------------------------------------------------"
      echo ">> 4: 'switch = y', switching to <production> branch"

      git checkout production
      git pull

    elif [ "$switch" == "n" ]; then

      # don't switch
      echo "-------------------------------------------------------------"
      echo ">> 4: 'switch = n', staying on <$current_branch> branch"

    else

      # don't switch
      echo "-------------------------------------------------------------"
      echo ">> 4: 'switch = []', staying on <$current_branch> branch"

    fi

  else
  
    # stay on this branch
    echo "-------------------------------------------------------------"
    echo ">> 3: on <$current_branch>"

  fi

else

  # if the $data_env does exist, ask about setting it
  echo "-------------------------------------------------------------"
  echo ">> 1: 'data_env' exists"

  # if the $data_env does exist, ask about changing it
  echo "-------------------------------------------------------------"
  read -p "'data_env = $data_env' ... Switch environment? Yes [y] / No [*n] -- " -n 1 switch
  printf "\n"

  # change environment by overwriting $data_env

  if [ "$switch" == "y" ]; then

    echo "-------------------------------------------------------------"
    echo ">> 2: switch 'data_env'"

    echo "-------------------------------------------------------------"
    read -p "staging [*s] or production [p]? -- " -n 1 data_env_input
    printf "\n"

    export data_env=${data_env_input:-"s"}  # default to staging if nothing entered

    if [ "$data_env" == "s" ] && [ "$current_branch" != "staging" ]; then

      echo "-------------------------------------------------------------"
      echo ">> 4: 'data_env = s', not on staging branch"

      echo "-------------------------------------------------------------"
      read -p "Switch to staging? Yes [y] / No [*n] -- " -n 1 switch
      printf "\n"

      if [ "$switch" == "y" ]; then

        echo "-------------------------------------------------------------"
        echo ">> 5: switching to staging branch"

        git checkout staging
        git pull

      fi

    elif [ "$data_env" == "p" ] && [ "$current_branch" != "production" ]; then

      echo "-------------------------------------------------------------"
      echo ">> 4: 'data_env = p', not on <production> branch"

      echo "-------------------------------------------------------------"
      read -p "Switch to <production> ? Yes [y] / No [*n] -- " -n 1 switch
      printf "\n"

      if [ "$switch" == "y" ]; then

        echo "-------------------------------------------------------------"
        echo ">> 5: switching to <production> branch"

        git checkout production
        git pull

      elif [ "$switch" == "n" ]; then

        # don't switch
        echo "-------------------------------------------------------------"
        echo ">> 5: 'switch = n', staying on <$current_branch> branch"

      else
        # don't switch
        echo "-------------------------------------------------------------"
        echo ">> 5: 'switch = []', staying on <$current_branch> branch"

      fi

    else
      echo "-------------------------------------------------------------"
      echo ">> 4: staying on <$current_branch> branch"

    fi

  elif [ "$switch" == "n" ]; then

    # don't switch
    echo "-------------------------------------------------------------"
    echo ">> 5: 'switch = n', staying on <$current_branch> branch"

  else

    # don't switch
    echo "-------------------------------------------------------------"
    echo ">> 5: 'switch = []', staying on <$current_branch> branch"

  fi
fi

echo "-------------------------------------------------------------"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - #
# Tell conda which environment to load
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - #

# conda activate EHDP-data

#=========================================================================================#
# R
#=========================================================================================#

#-----------------------------------------------------------------------------------------#
# EXP data
#-----------------------------------------------------------------------------------------#

echo ">>> EXP_indicator_data_writer"
Rscript "$base_dir/export-scripts/EXP_indicator_data_writer.R"

#-----------------------------------------------------------------------------------------#
# EXP metadata
#-----------------------------------------------------------------------------------------#

echo ">>> EXP_indicator_metadata_writer"
Rscript $base_dir/export-scripts/EXP_indicator_metadata_writer.R

#-----------------------------------------------------------------------------------------#
# EXP comparisons metadata
#-----------------------------------------------------------------------------------------#

echo ">>> EXP_measure_comparisons_writer"
Rscript "$base_dir/export-scripts/EXP_measure_comparisons_writer.R"

#-----------------------------------------------------------------------------------------#
# NR viz data (for VegaLite)
#-----------------------------------------------------------------------------------------#

echo ">>> NR_data_csv_writer"
Rscript "$base_dir/export-scripts/NR_data_csv_writer.R"

#-----------------------------------------------------------------------------------------#
# NR JSON data (for report)
#-----------------------------------------------------------------------------------------#

echo ">>> NR_json_writer"
Rscript "$base_dir/export-scripts/NR_json_writer.R"

#-----------------------------------------------------------------------------------------#
# GeoLookup
#-----------------------------------------------------------------------------------------#

# echo ">>> create_GeoLookup"
# Rscript "$base_dir/export-scripts/create_GeoLookup.R"

#=========================================================================================#
# Python
#=========================================================================================#

#-----------------------------------------------------------------------------------------#
# EXP metadata
#-----------------------------------------------------------------------------------------#

# echo ">>> EXP_indicator_metadata_writer"
# python "$base_dir/export-scripts/EXP_indicator_metadata_writer.py"

#-----------------------------------------------------------------------------------------#
# NR spark bars
#-----------------------------------------------------------------------------------------#

# echo ">>> NR_SparkBarExport"
# python "$base_dir/export-scripts/NR_SparkBarExport.py"

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# #
# #                             ---- THIS IS THE END! ----
# #
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
