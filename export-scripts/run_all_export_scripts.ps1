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

$base_dir = Get-Location

$Env:base_dir = $base_dir

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - #
# Choose database to use, set env var
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - #

$Env:data_env = Read-Host "staging [s] or production [p]?"

# make sure you're on the right branch

$current_branch = git branch --show-current

if (($Env:data_env -eq "s") -and ($current_branch -ne "staging")) {

    git checkout staging
    git pull
    
} elseif (($Env:data_env -eq "p") -and ($current_branch -ne "production")) {
    
    git checkout production
    git pull

}


# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - #
# Tell conda which environment to load
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - #

conda activate EHDP-data

#=========================================================================================#
# R
#=========================================================================================#

#-----------------------------------------------------------------------------------------#
# EXP data
#-----------------------------------------------------------------------------------------#

Write-Output ">>> EXP_indicator_data_writer"

Rscript $base_dir\export-scripts\EXP_indicator_data_writer.R

#-----------------------------------------------------------------------------------------#
# EXP comparisons metadata
#-----------------------------------------------------------------------------------------#

Write-Output ">>> EXP_measure_comparisons_writer"

Rscript $base_dir\export-scripts\EXP_measure_comparisons_writer.R

#-----------------------------------------------------------------------------------------#
# NR viz data (for VegaLite)
#-----------------------------------------------------------------------------------------#

Write-Output ">>> NR_data_csv_writer"

Rscript $base_dir\export-scripts\NR_data_csv_writer.R

#-----------------------------------------------------------------------------------------#
# NR JSON data (for report)
#-----------------------------------------------------------------------------------------#

Write-Output ">>> NR_json_writer"

Rscript $base_dir\export-scripts\NR_json_writer.R

#-----------------------------------------------------------------------------------------#
# GeoLookup
#-----------------------------------------------------------------------------------------#

# Write-Output ">>> create_GeoLookup"

# Rscript $base_dir\export-scripts\create_GeoLookup.R


#=========================================================================================#
# Python
#=========================================================================================#

#-----------------------------------------------------------------------------------------#
# EXP metadata
#-----------------------------------------------------------------------------------------#

Write-Output ">>> EXP_indicator_metadata_writer"

python $base_dir\export-scripts\EXP_indicator_metadata_writer.py

#-----------------------------------------------------------------------------------------#
# NR spark bars
#-----------------------------------------------------------------------------------------#

# Write-Output ">>> NR_SparkBarExport"

# python $base_dir\export-scripts\NR_SparkBarExport.py


# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# #
# #                             ---- THIS IS THE END! ----
# #
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
