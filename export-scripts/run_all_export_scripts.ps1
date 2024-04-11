###########################################################################################-
###########################################################################################-
##
## Running all data export scripts
##
###########################################################################################-
###########################################################################################-

#=========================================================================================#
# setup
#=========================================================================================#

#-----------------------------------------------------------------------------------------#
# get parent dir for absolute path
#-----------------------------------------------------------------------------------------#

$base_dir = Get-Location

$Env:base_dir = $base_dir

#-----------------------------------------------------------------------------------------#
# source script to set environment params
#-----------------------------------------------------------------------------------------#

. $base_dir\export-scripts\set_environment.ps1

#-----------------------------------------------------------------------------------------#
# choose to export spark bars
#-----------------------------------------------------------------------------------------#

Write-Host "-------------------------------------------------------------"
$sparkbar = (Read-Host "Run 'NR_sparkbars.py'? Yes [y] / No [*n] -- ").ToLower().Trim()[0]
Write-Host "-------------------------------------------------------------"


#=========================================================================================#
# run scripts
#=========================================================================================#

#-----------------------------------------------------------------------------------------#
# EXP data
#-----------------------------------------------------------------------------------------#

Write-Output ">>> EXP_data_json"

Rscript $base_dir\export-scripts\EXP_data_json.R

#-----------------------------------------------------------------------------------------#
# EXP metadata
#-----------------------------------------------------------------------------------------#

Write-Output ">>> EXP_metadata_json"

Rscript $base_dir\export-scripts\EXP_metadata_json.R

#-----------------------------------------------------------------------------------------#
# EXP comparisons
#-----------------------------------------------------------------------------------------#

Write-Output ">>> EXP_comparisons_json"

Rscript $base_dir\export-scripts\EXP_comparisons_json.R

#-----------------------------------------------------------------------------------------#
# EXP TimePeriods
#-----------------------------------------------------------------------------------------#

Write-Output ">>> EXP_TimePeriods_json"

Rscript $base_dir\export-scripts\EXP_TimePeriods_json.R

#-----------------------------------------------------------------------------------------#
# EXP GeoLookup
#-----------------------------------------------------------------------------------------#

Write-Output ">>> EXP_GeoLookup_json"

Rscript $base_dir\export-scripts\EXP_GeoLookup_json.R

#-----------------------------------------------------------------------------------------#
# NR data (for hugo & VegaLite)
#-----------------------------------------------------------------------------------------#

Write-Output ">>> NR_data_json"

Rscript $base_dir\export-scripts\NR_data_json.R

#-----------------------------------------------------------------------------------------#
# NR spark bars
#-----------------------------------------------------------------------------------------#

if ($sparkbar -eq "y") {
    
    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - #
    # run script to construct the spec
    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - #

    Write-Output ">>> NR_sparkbar_spec"

    npm install --silent

    node $base_dir\export-scripts\NR_sparkbar_spec.js

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - #
    # run the SVG export script
    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - #

    Write-Output ">>> NR_sparkbars"

    Rscript $base_dir\export-scripts\NR_sparkbars.R

}

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# #
# #                             ---- THIS IS THE END! ----
# #
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
